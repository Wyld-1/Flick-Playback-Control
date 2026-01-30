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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Centered app name
                VStack(spacing: 4) {
                    Text("Flick")
                        .font(.system(size: geometry.size.width * 0.15))
                        .fontWeight(.black)
                        .foregroundStyle(.blue)
                }
                
                // Gesture confirmation icon - small in lower right
                if lastGesture != .none {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: gestureIcon(for: lastGesture))
                                .font(.system(size: geometry.size.width * 0.15))
                                .foregroundStyle(.orange)
                                .symbolEffect(.bounce, value: lastGesture)
                                .padding(.trailing, 8)
                                .padding(.bottom, 8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
