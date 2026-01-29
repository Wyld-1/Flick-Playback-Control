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
        (gesture: "Hold upside-down", symbol: "flip.ccw", description: "Play/pause", expectedGesture: .playPause)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Progress indicator
                HStack {
                    Text("\(currentStep + 1) / \(tutorialSteps.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    // Manual advance button (upper right)
                    Button(action: advanceStep) {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.top, -30)
                
                // Show media icon when gesture detected, otherwise show instruction icon
                if showMediaIcon {
                    Image(systemName: mediaIcon(for: tutorialSteps[currentStep].expectedGesture))
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.45, height: geometry.size.width * 0.45)
                        .symbolEffect(.bounce, value: gestureDetected)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(tutorialSteps[currentStep].symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.65)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer(minLength: geometry.size.height * 0.12)
                
                // Instruction text
                VStack(spacing: 4) {
                    Text(tutorialSteps[currentStep].gesture)
                        .font(.system(size: geometry.size.width * 0.09))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Text(tutorialSteps[currentStep].description)
                        .font(.system(size: geometry.size.width * 0.07))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 12)
                .padding(.horizontal, 8)
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
        guard gesture == tutorialSteps[currentStep].expectedGesture else { return }
        
        gestureDetected.toggle()
        
        withAnimation(.spring(duration: 0.3)) {
            showMediaIcon = true
        }
        
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
