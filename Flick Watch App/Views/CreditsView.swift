//
//  CreditsView.swift
//  Flick
//
//  Created by Liam Lefohn on 1/30/26.
//

import SwiftUI

struct CreditsView: View {
    @Environment(\.dismiss) var dismiss  // ← Auto dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Text("Flick 1.0\n\nCreated by Wyld-1\n\nhttps://github.com/Wyld-1/Flick-Playback-Control")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    .foregroundStyle(.secondary)
                
                Text("Built with 🧡 for adventure")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    .foregroundStyle(.orange)
            }
        }
    }
}

#Preview {
    CreditsView()
        .environmentObject(AppStateManager())
}
