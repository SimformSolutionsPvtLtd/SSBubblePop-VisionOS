//
//  CountdownView.swift
//  BubblePop
//
//  Created by Krupanshu Sharma on 13/09/24.
//
import SwiftUI
import Combine

struct CountdownView: View {
    @State private var counter = 3
    var onCountdownComplete: () -> Void

    var body: some View {
        CardView {
            VStack {
                Text("\(counter)")
                    .font(.system(size: 100, weight: .bold))
                    .padding()
                    .onAppear {
                        startCountdown()
                    }
            }
        }
    }

    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if counter > 0 {
                counter -= 1
            } else {
                timer.invalidate()
                DispatchQueue.main.async {
                    onCountdownComplete()  // Call the completion handler here
                }
            }
        }
    }
}
