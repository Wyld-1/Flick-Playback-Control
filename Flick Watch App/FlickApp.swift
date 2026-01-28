//
//  FlickApp.swift
//  Flick Watch App
//
//  Created by Liam Lefohn on 1/27/26.
//
// Entry point, routes to correct view

import SwiftUI

@main
struct Flick_Watch_AppApp: App {
    @StateObject private var appState = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            // Show different views based on state
            switch appState.currentState {
            case .welcome:
                WelcomeView()
            case .tutorial:
                TutorialView()
            case .main:
                MainView()
            }
        }
        .environmentObject(appState)
    }
}
