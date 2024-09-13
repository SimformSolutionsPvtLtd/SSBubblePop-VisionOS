//
//  NameEntryView.swift
//  BubblePop
//
//  Created by Krupanshu Sharma on 13/09/24.
//
import SwiftUI

struct NameEntryView: View {
    @Binding var name: String
    var onNameEntered: () -> Void

    var body: some View {
        CardView {
            VStack {
                Text("Enter your name")
                    .font(.largeTitle)
                TextField("Name", text: $name)
                    .font(.largeTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Next") {
                    onNameEntered()
                }
                .disabled(name.isEmpty)
            }
            .padding()
        }
    }
}
