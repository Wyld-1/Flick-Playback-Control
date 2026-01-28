//
//  TutorialView.swift
//  Flick Watch App
//
//  Created by Liam Lefohn on 1/27/26.
//
// Interactive gesture tutorial

import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentStep = 0
    
    let tutorialSteps = [
        (gesture: "Twist wrist left", icon: "speaker.plus", description: "Volume up"),
        (gesture: "Twist wrist right", icon: "speaker.minus", description: "Volume down"),
        (gesture: "Double flick left", icon: "forward", description: "Next track"),
        (gesture: "Double flick right", icon: "backward", description: "Previous track"),
        (gesture: "Hold upside-down", icon: "playpause", description: "Play/Pause")
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            // Progress indicator
            Text("\(currentStep + 1) / \(tutorialSteps.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            // Gesture icon
            Image(systemName: tutorialSteps[currentStep].icon)
                .font(.system(size: 60))
                .foregroundStyle(.orange)
                .symbolEffect(.bounce, value: currentStep)
            
            Spacer()
            
            // Instruction text
            VStack(spacing: 5) {
                Text(tutorialSteps[currentStep].gesture)
                    .font(.headline)
                
                Text(tutorialSteps[currentStep].description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Skip button for now (later: detect actual gesture)
            Button("Continue") {
                withAnimation {
                    if currentStep < tutorialSteps.count - 1 {
                        currentStep += 1
                    } else {
                        appState.completeTutorial()
                    }
                }
            }
            .buttonStyle(.glass)
        }
        .padding()
    }
}

#Preview {
    TutorialView()
        .environmentObject(AppStateManager())
}
