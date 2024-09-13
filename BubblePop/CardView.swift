//
//  CardView.swift
//  BubblePop
//
//  Created by Krupanshu Sharma on 13/09/24.
//
import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .frame(width: 700, height: 600) // Fixed width and height
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
    }
}
