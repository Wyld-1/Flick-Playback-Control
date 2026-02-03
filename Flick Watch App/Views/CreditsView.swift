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
                VStack(spacing: 15) {
                    Text("\nFlick 1.0\n\nCreated by Wyld-1")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Text("Built with 🧡 for adventure\n")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.orange)
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
