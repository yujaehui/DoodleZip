//
//  DoodleZipApp.swift
//  DoodleZip
//
//  Created by Jaehui Yu on 2/12/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct DoodleZipTestApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: Store(
                    initialState: NoteFeature.State(),
                    reducer: { NoteFeature() }
                )
            )
        }
    }
}
