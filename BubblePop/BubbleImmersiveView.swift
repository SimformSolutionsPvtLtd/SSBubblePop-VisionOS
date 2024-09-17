//
//  BubbleImmersiveView.swift
//  VisionOSVR
//
//  Created by Krupanshu Sharma on 29/08/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct BubbleImmersiveView: View {
    @State private var predicate = QueryPredicate<Entity>.has(ModelComponent.self)
    @State private var timer: Timer?
    @State private var bubble = Entity()
    @Environment(AppModel.self) private var appModel
    let bubbleCount = 100
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @State private var countdownTimer: Timer?
    @State private var timeLeft = 60 // 60 seconds countdown

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Scene", in: realityKitContentBundle) {


                bubble = immersiveContentEntity.findEntity(named: "Bubble")!

                for _ in 1...bubbleCount {
                    var bubbleClone = bubble.clone(recursive: true)
                    let x = Float.random(in: -1.5...1.5)
                    let y = Float.random(in: 1...1.5)
                    let z = Float.random(in: -1.5...1.5)
                    bubbleClone.position = [x, y, z]

                    /// Uncomment the code below if you want to enable the system to move the bubbles.
                    ///
                    /// Also uncomment the register system line in BubblesApp file
//                                        guard var bubbleComponent = bubbleClone.components[BubbleComponent.self] else { return }
//                                        bubbleComponent.direction = [
//                                            Float.random(in: -1...1),
//                                            Float.random(in: -1...1),
//                                            Float.random(in: -1...1)
//                                        ]
//                                        bubbleClone.components[BubbleComponent.self] = bubbleComponent

                    // comment out addind the pb and pm  when you want to enable the system

                    var pb = PhysicsBodyComponent()
                    pb.isAffectedByGravity = false
                    pb.linearDamping = 0

                    let linearVelX = Float.random(in: -0.05...0.05)
                    let linearVelY = Float.random(in: -0.05...0.05)
                    let linearVelZ = Float.random(in: -0.05...0.05)

                    var pm = PhysicsMotionComponent(linearVelocity: [linearVelX, linearVelY, linearVelZ])

                    bubbleClone.components[PhysicsBodyComponent.self] = pb
                    bubbleClone.components[PhysicsMotionComponent.self] = pm

                    content.add(bubbleClone)
                }

                // Start the countdown timer
                startCountdown()
            }
        }
        .gesture(SpatialTapGesture().targetedToEntity(where: predicate).onEnded({ value in
            let entity = value.entity

            // Get the bubble material from the model component of the bubble entity
            var mat = entity.components[ModelComponent.self]?.materials.first as! ShaderGraphMaterial

            let frameRate: TimeInterval = 1.0/60.0 // 60FPS
            let duration: TimeInterval = 0.25
            let targetValue: Float = 1
            let totalFrames = Int(duration / frameRate)
            var currentFrame = 0
            var popValue: Float = 0

            timer?.invalidate()

            // The timer updates the popValue each time it fires.
            timer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true, block: { timer in
                currentFrame += 1
                let progress = Float(currentFrame) / Float(totalFrames)

                popValue = progress * targetValue

                // set the parameter value and then assign the material back to the model component
                do {
                    try mat.setParameter(name: "Pop", value: .float(popValue))
                    entity.components[ModelComponent.self]?.materials = [mat]
                }
                catch {
                    print(error.localizedDescription)
                }

                if currentFrame >= totalFrames {
                    timer.invalidate()
                    entity.removeFromParent()
                    DispatchQueue.main.async {
                        appModel.currentScore += 1
                        print(appModel.currentScore)
                    }
                }
            })
        }))
        .onDisappear() {
            countdownTimer?.invalidate()
        }
    }

    // Function to start the 30-second countdown timer
    private func startCountdown() {
        countdownTimer?.invalidate() // Ensure previous timer is invalidated
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timeLeft -= 1
            print("Time left: \(timeLeft) seconds")
            DispatchQueue.main.async {
                appModel.timeLeft = timeLeft
            }
            if timeLeft <= 0 {
                timer.invalidate()
                performTimeoutAction() // Perform the action when time is up
            }
        }
    }

    // Function to perform the action when the 30 seconds are up
    private func performTimeoutAction() {
        // Add your custom action here, such as ending the game or showing a message
        print("Time's up! Performing action...")
        Task { @MainActor in
            appModel.performCelebration = true
            await dismissImmersiveSpace()
            appModel.immersiveSpaceState = .closed

        }
    }

    func createParticle() -> ModelEntity {
        let sphere = MeshResource.generateSphere(radius: 0.01)
        var material = SimpleMaterial(color: .blue, isMetallic: false)
        material.baseColor = MaterialColorParameter.color(UIColor(white: 1.0, alpha: 0.5))

        let particleEntity = ModelEntity(mesh: sphere, materials: [material])
        particleEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)]))
        return particleEntity
    }

    func addParticleEffect(at position: SIMD3<Float>, in scene: Entity) {
        let particleCount = 20

        for _ in 0..<particleCount {
            let particle = createParticle()
            particle.position = position

            // Add random velocity to the particle
            let randomX = Float.random(in: -0.05...0.05)
            let randomY = Float.random(in: 0.05...0.1)
            let randomZ = Float.random(in: -0.05...0.05)
            let velocity = SIMD3<Float>(x: randomX, y: randomY, z: randomZ)

            particle.addForce(velocity, relativeTo: nil)

            scene.addChild(particle)

            // Animate particle lifetime (fade out and remove)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                particle.setScale([0, 0, 0], relativeTo: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    particle.removeFromParent()
                }
            }
        }
    }
}

#Preview {
    BubbleImmersiveView()
}
