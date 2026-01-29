//
//  WelcomeView.swift
//  Flick Watch App
//
//  Created by Liam Lefohn on 1/27/26.
//
// First-time welcome screen

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var triggerPulse = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(systemName: "play")
                    .font(.system(size: geometry.size.width * 0.45))
                    .symbolEffect(.pulse, value: triggerPulse)
                    .symbolEffect(.breathe.plain.wholeSymbol, options: .repeat(.continuous))
                    .imageScale(.large)
                    .foregroundStyle(.orange)
                    .onTapGesture {
                        // Trigger single pulse
                        triggerPulse.toggle()
                        
                        // Wait for animation, then transition
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appState.completeWelcome()
                            }
                        }
                    }
                
                Spacer()
                    .frame(height: geometry.size.height * 0.2)
                
                Text("Playback just got")
                    .foregroundStyle(.tint)
                    .font(.system(size: geometry.size.width * 0.1))
                Text("convenient")
                    .foregroundStyle(.tint)
                    .font(.system(size: geometry.size.width * 0.1))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppStateManager())
}
