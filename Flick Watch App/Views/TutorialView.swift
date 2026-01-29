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
    @StateObject private var motionManager = MotionManager()
    @State private var currentStep = 0
    @State private var gestureDetected = false
    @State private var showMediaIcon = false
    
    let tutorialSteps: [(gesture: String, symbol: String, description: String, expectedGesture: GestureType)] = [
        (gesture: "Flick wrist left", symbol: "flick.ccw", description: "Next track", expectedGesture: .nextTrack),
        (gesture: "Flick wrist right", symbol: "flick.cw", description: "Previous track", expectedGesture: .previousTrack),
        (gesture: "Hold upside-down", symbol: "flip.ccw", description: "Play/Pause", expectedGesture: .playPause)
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                // Progress indicator
                HStack {
                    Text("\(currentStep + 1) / \(tutorialSteps.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    // Manual advance button (upper right)
                    Button(action: advanceStep) {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Show media icon when gesture detected, otherwise show instruction icon
                if showMediaIcon {
                    Image(systemName: mediaIcon(for: tutorialSteps[currentStep].expectedGesture))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .symbolEffect(.bounce, value: gestureDetected)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(tutorialSteps[currentStep].symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 150)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Instruction text
                VStack(spacing: 5) {
                    Text(tutorialSteps[currentStep].gesture)
                        .font(.headline)
                    
                    Text(tutorialSteps[currentStep].description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            motionManager.startMonitoring()
        }
        .onChange(of: motionManager.lastGesture) { oldValue, newValue in
            handleGestureDetection(newValue)
        }
    }
    
    private func handleGestureDetection(_ gesture: GestureType) {
        // Check if detected gesture matches current step
        guard gesture == tutorialSteps[currentStep].expectedGesture else { return }
        
        gestureDetected.toggle()
        
        withAnimation(.spring(duration: 0.3)) {
            showMediaIcon = true
        }
        
        // Auto-advance after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            advanceStep()
        }
    }
    
    private func advanceStep() {
        withAnimation {
            showMediaIcon = false
            
            if currentStep < tutorialSteps.count - 1 {
                currentStep += 1
            } else {
                appState.completeTutorial()
            }
        }
    }
    
    // Map gestures to media control icons
    private func mediaIcon(for gesture: GestureType) -> String {
        switch gesture {
        case .nextTrack:
            return "forward.fill"
        case .previousTrack:
            return "backward.fill"
        case .playPause:
            return "playpause.fill"
        case .none:
            return "circle"
        }
    }
}

#Preview {
    TutorialView()
        .environmentObject(AppStateManager())
}
