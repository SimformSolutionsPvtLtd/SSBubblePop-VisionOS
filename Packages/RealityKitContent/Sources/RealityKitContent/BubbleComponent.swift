//
//  Untitled.swift
//  RealityKitContent
//
//  Created by Krupanshu Sharma on 29/08/24.
//

import RealityKit

// Ensure you register this component in your app’s delegate using:
// BubbleComponent.registerComponent()
public struct BubbleComponent: Component, Codable {
    // This is an example of adding a variable to the component.
    public var direction: SIMD3<Float> = [0,0,0]

    public init() {
    }
}
