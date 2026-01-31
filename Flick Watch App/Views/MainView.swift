//
//  MainView.swift
//  Flick
//
//  Created by Liam Lefohn on 1/27/26.
//
// Main app screen (live app)

import SwiftUI

struct MainView: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var mediaManager = MediaManager()
    @State private var lastGesture: GestureType = .none
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var showHelp = false
    @EnvironmentObject var appState: AppStateManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background breathing circle
                Image(systemName: "circle")
                    .font(.system(size: geometry.size.width * 0.85))
                    .symbolEffect(.breathe.plain.wholeSymbol, isActive: !isLuminanceReduced)
                    .foregroundStyle(.orange)
                
                // Gesture icon (replaces "Flick" text)
                if lastGesture != .none {
                    Image(systemName: gestureIcon(for: lastGesture))
                        .font(.system(size: geometry.size.width * 0.25))
                        .foregroundStyle(.blue)
                        .fontWeight(.black)
                        .symbolEffect(.bounce, value: lastGesture)
                } else {
                    Text("Flick")
                        .foregroundStyle(.blue)
                        .font(.system(size: geometry.size.width * 0.2))
                        .fontWeight(.black)
                }
                
                // Button to open help menu
                VStack {
                    HStack {
                        Button(action: {
                            showHelp = true
                        }) {
                            Image(systemName: "questionmark.circle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .position(x:geometry.size.width * 0.15, y:geometry.size.height * -0.15)
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        
        .onAppear {
            motionManager.startMonitoring()
        }
        .onChange(of: motionManager.lastGesture) { oldValue, newValue in
            withAnimation {
                lastGesture = newValue
                mediaManager.handleGesture(newValue)
            }
        }
    }
    
    // Map gesture types to SF Symbols
    func gestureIcon(for gesture: GestureType) -> String {
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
    MainView()
}
