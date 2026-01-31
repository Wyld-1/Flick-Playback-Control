//
//  MediaManager.swift
//  Flick
//
//  Created by Liam Lefohn on 1/27/26.
//
// Controls media playback

import Foundation
import MediaPlayer
import WatchKit
import Combine

class MediaManager: ObservableObject {
    private let commandCenter = MPRemoteCommandCenter.shared()
    
    func handleGesture(_ gesture: GestureType) {
        switch gesture {
        case .nextTrack:
            commandCenter.nextTrackCommand.perform(nil)
            WKInterfaceDevice.current().play(.success)
            
        case .previousTrack:
            commandCenter.previousTrackCommand.perform(nil)
            WKInterfaceDevice.current().play(.success)
            
        case .playPause:
            commandCenter.togglePlayPauseCommand.perform(nil)
            WKInterfaceDevice.current().play(.success)
            
        case .none:
            break
        }
    }
}
