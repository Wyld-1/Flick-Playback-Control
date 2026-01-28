//
//  ContentView.swift
//  Flick Watch App
//
//  Created by Liam Lefohn on 1/27/26.
//
// First-time welcome screen

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "play")
                .font(.system(size: 80))
                .symbolEffect(.breathe.plain.wholeSymbol, options: .repeat(.continuous))
                .imageScale(.large)
                .foregroundStyle(.orange)
            Spacer()
                .frame(height:50)
            Text("Ready to begin?")
                .foregroundStyle(.tint)
                .font(.system(size: 25))
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
