//
//  AppModel.swift
//  Bubbles
//
//  Created by Sarang Borude on 7/21/24.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var currentScore: Int = 0
    var performCelebration: Bool = false
    var timeLeft = 60
}
