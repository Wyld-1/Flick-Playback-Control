//
//  HelpView.swift
//  Flick
//
//  Created by Liam Lefohn on 1/30/26.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var showCredits = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("\nGo on, play the music you 💕\n\nFlick will run behind the scenes.")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
               
                // Restart tutorial button
                Button(action: {
                    appState.resetToTutorial()
                }) {
                    Text("Restart tutorial")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.glass)
                
                // Credits button
                Button(action: {
                    showCredits = true
                }) {
                    Text("About")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .sheet(isPresented: $showCredits) {
                CreditsView()
            }
        }
    }
}

#Preview {
    HelpView()
        .environmentObject(AppStateManager())
}

