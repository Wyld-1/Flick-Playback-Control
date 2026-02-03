//
//  HelpView.swift
//  Flick
//
//  Created by Liam Lefohn on 1/30/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var showCredits = false
    
    var body: some View {
        List {
            Section {
                // Enable/disable tap for play/pause toggle
                Toggle(isOn: $appState.isTapEnabled) {
                    HStack(spacing: 4) {
                        Text("Tap screen to")
                        Image(systemName: "playpause.fill")
                    }
                }
                .tint(.orange)
                
                // Reverse flick directions
                Toggle(isOn: $appState.isFlickDirectionReversed) {
                    HStack(spacing: 4) {
                        Text("Flip")
                        Image(systemName: "backward.fill")
                        Text("/")
                        Image(systemName: "forward.fill")
                    }
                }
                .tint(.orange)
                
                // Feedback link
                Link(destination: URL(string: "https://forms.gle/srpX8xf9EpCDjmC18")!) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil.tip.crop.circle.fill")
                            .foregroundColor(.purple)
                        
                        Text("Build Flick with us")
                            .foregroundColor(.purple)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Restart tutorial button
                Button(action: {
                    appState.resetToTutorial()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName:  "arrow.counterclockwise.circle.fill")
                            .foregroundStyle(.orange)
                        Text("Restart tutorial")
                            .foregroundStyle(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Credits button
                Button(action: {
                    showCredits = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName:  "info.circle.fill")
                            .foregroundStyle(.secondary)
                        Text("About")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(.plain)
        }
        .sheet(isPresented: $showCredits) {
            CreditsView()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppStateManager())
}

