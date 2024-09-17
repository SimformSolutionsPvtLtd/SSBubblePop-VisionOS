//
//  ContentView.swift
//  VisionOSVR
//
//  Created by Krupanshu Sharma on 28/08/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ConfettiSwiftUI
import AVFoundation

struct ContentView: View {
    @State private var confettiCounter = 1
    @State private var name: String = ""
    @State private var showInstructions = true
    @State private var showNameInput = false

    @State private var showCountdown = false
    @State private var callbackTriggered = false
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var encouragementMessage: String? = nil
    private let speechSynthesizer = SpeechSynthesizer()

    var body: some View {
        ZStack {
            if callbackTriggered {
                CardView {
                    VStack {

                        // Restart and Finish Icons
                        HStack(spacing: 40) {
                            Button(action: {
                                appModel.currentScore = 0
                                appModel.immersiveSpaceState = .closed
                                toggleImmersiveSpaceAction()
                            }) {
                                VStack {
                                    Image(systemName: "arrow.counterclockwise.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.green)
                                    Text("Restart")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.green)
                                }
                            }

                            Spacer()
                            Text("Player: \(name)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.top, 20)

                            Spacer()
                            Button(action: {
                                toggleImmersiveSpaceAction()
                            }) {
                                VStack {
                                    Image(systemName: "flag.checkered.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.red)
                                    Text("Finish")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.bottom, 20)


                        if appModel.immersiveSpaceState == .open {
                            HStack(spacing: 10) {
                                Image(systemName: "timer")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                Text("\(appModel.timeLeft) sec left")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                    .bold()
                            }
                            .padding(.bottom, 10)
                        }

                        // Score Display
                        VStack {
                            Text("Score")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("\(appModel.currentScore)")
                                .font(.system(size: 150, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding()

                        if let message = encouragementMessage {
                            Text(message)
                                .font(.title2)
                                .foregroundColor(.green)
                                .bold()
                                .padding(.top, 20)
                        }

                        Spacer()
                    }
                }

                Text("").onAppear() {
                    toggleImmersiveSpaceAction()
                }

            } else if showCountdown {
                CountdownView {
                    // Callback once countdown is finished
                    callbackTriggered = true
                }
            } else if showNameInput {
                NameEntryView(name: $name) {
                    // Go to instructions after name is entered
                    showCountdown = true
                }
            } else {
                InstructionsView {
                    // Go to countdown screen after "I Understand"
                    showNameInput = true
                }
            }
            if appModel.performCelebration {
                ConfettiCannon(counter: $confettiCounter, repetitions: 5, repetitionInterval: 0.1)
                    .onAppear(){
                        confettiCounter += 1
                    }
            }
        }
        .onChange(of: appModel.currentScore) { newScore in
            checkScoreMilestones(score: newScore)
        }
    }

    // Check score milestones to show encouraging texts
    func checkScoreMilestones(score: Int) {
        switch score {
        case 10:
            encouragementMessage = "Nice start! Keep it up!"
        case 20:
            encouragementMessage = "You're on fire! Keep popping!"
        case 30:
            encouragementMessage = "Amazing! You're unstoppable!"
        case 50:
            encouragementMessage = "Incredible! You're a bubble-popping pro!"
        case 75:
            encouragementMessage = "Unbelievable! You're breaking records!"
        case 100:
            encouragementMessage = "Legendary! Keep going for more!"
        default:
            encouragementMessage = nil
        }

        if let message = encouragementMessage {
            speechSynthesizer.speak(message)
        }
    }

    func toggleImmersiveSpaceAction() {
        Task { @MainActor in
            switch appModel.immersiveSpaceState {
            case .open:
                appModel.immersiveSpaceState = .inTransition
                appModel.performCelebration = true
                await dismissImmersiveSpace()

            case .closed:
                appModel.immersiveSpaceState = .inTransition
                appModel.performCelebration = false
                switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                case .opened:
                    break

                case .userCancelled, .error:
                    fallthrough
                @unknown default:
                    appModel.immersiveSpaceState = .closed
                }

            case .inTransition:
                break
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
