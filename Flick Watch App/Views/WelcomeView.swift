//
//  ContentView.swift
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
        VStack {
            Image(systemName: "play")
                .font(.system(size: 100))
                .symbolEffect(.bounce, value: triggerPulse)
                .symbolEffect(.breathe.plain.wholeSymbol, options: .repeat(.continuous))
                .imageScale(.large)
                .foregroundStyle(.orange)
                .onTapGesture {
                    // Trigger single bounce
                    triggerPulse.toggle()
                    
                    // Wait for animation, then transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState.completeWelcome()
                        }
                    }
                }
            
            Spacer()
                .frame(height: 40)
            
            Text("Tap to expierence")
                .foregroundStyle(.tint)
                .font(.system(size: 20))
            Text("effortless playback")
                .foregroundStyle(.tint)
                .font(.system(size: 20))
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppStateManager())
}
