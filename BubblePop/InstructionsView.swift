//
//  InstructionsView.swift
//  BubblePop
//
//  Created by Krupanshu Sharma on 13/09/24.
//
import SwiftUI

struct InstructionsView: View {
    @State private var currentInstructionIndex = 0
    let instructions = [
        "You have 60 seconds to pop as many bubbles as you can.",
        "Tap on the bubbles quickly before they disappear.",
        "Enter the name and step into the virtual world"
    ]
    var onUnderstand: () -> Void

    var body: some View {
        CardView {
            VStack(spacing: 30) {
                // Title
                Text("Welcome to Bubble Pop")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)

                // Subtitle
                Text("A fast-paced and fun game built for VisionOS.")
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                // Instructions
                Text(instructions[currentInstructionIndex])
                    .font(.system(size: 25))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .animation(.easeInOut, value: currentInstructionIndex)

                Spacer()

                // Next Button
                Button(action: {
                    if currentInstructionIndex < instructions.count - 1 {
                        currentInstructionIndex += 1
                    } else {
                        onUnderstand()
                    }
                }) {
                    Text(currentInstructionIndex == 2 ? "Start Game" : "Next")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 40)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 40)
            }
            .frame(maxHeight: .infinity) // Ensure content fills the card
        }
        .padding(.horizontal, 30)
    }
}
