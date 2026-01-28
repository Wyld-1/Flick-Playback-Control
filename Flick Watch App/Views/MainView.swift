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
    @State private var lastGesture: GestureType = .none
    
    var body: some View {
        ZStack {
            // Background breathing circle
            Image(systemName: "circle")
                .font(.system(size: 170))
                .symbolEffect(.breathe.plain.wholeSymbol, options: .repeat(.continuous))
                .foregroundStyle(.orange)
            
            // Gesture icon (replaces "Flick" text)
            if lastGesture != .none {
                Image(systemName: gestureIcon(for: lastGesture))
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                    .fontWeight(.black)
                    .symbolEffect(.bounce, value: lastGesture)
            } else {
                Text("Flick")
                    .foregroundStyle(.blue)
                    .font(.system(size: 40))
                    .fontWeight(.black)
            }
        }
        .onAppear {
            motionManager.startMonitoring()
        }
        .onChange(of: motionManager.lastGesture) { oldValue, newValue in
            withAnimation {
                lastGesture = newValue
            }
        }
    }
    
    // Map gesture types to SF Symbols
    func gestureIcon(for gesture: GestureType) -> String {
        switch gesture {
        case .volumeUp:
            return "speaker.plus.fill"
        case .volumeDown:
            return "speaker.minus.fill"
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
