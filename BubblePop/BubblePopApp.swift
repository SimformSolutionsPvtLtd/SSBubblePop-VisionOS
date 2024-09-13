//
//  BubblePopApp.swift
//  BubblePop
//
//  Created by Krupanshu Sharma on 11/09/24.
//

import SwiftUI

@main
struct BubblePopApp: App {
    @State var immersionStyle: ImmersionStyle = .progressive
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            BubbleImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
