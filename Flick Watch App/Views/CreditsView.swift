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
        List {
            Section {
                VStack(spacing: 20) {
                    Text("")
                    
                    Text("Flick 1.0")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Text("Created by Wyld-1")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Text("Built with 🧡 for adventure")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.orange)
                    
                    Text("")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    CreditsView()
        .environmentObject(AppStateManager())
}
