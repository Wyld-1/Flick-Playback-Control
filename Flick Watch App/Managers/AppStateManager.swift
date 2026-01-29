//
//  AppStateManager.swift
//  Flick
//
//  Created by Liam Lefohn on 1/27/26.
//
// Tracks which screen to show

import SwiftUI
import Combine

enum AppState {
    case welcome
    case tutorial
    case main
}

class AppStateManager: ObservableObject {
    @Published var currentState: AppState
    
    init() {
        // Check if first launch
        let hasCompletedWelcome = UserDefaults.standard.bool(forKey: "hasCompletedWelcome")
        self.currentState = hasCompletedWelcome ? .main : .welcome
    }
    
    func completeWelcome() {
        UserDefaults.standard.set(true, forKey: "hasCompletedWelcome")
        currentState = .tutorial
    }
    
    func completeTutorial() {
        currentState = .main
    }
}
