//
//  MotionManager.swift
//  Flick
//
//  Created by Liam Lefohn on 1/27/26.
//
// Reads sensors, detects gestures

import Foundation
import CoreMotion
import Combine

// Gesture types the app can detect
enum GestureType {
    case none
    case volumeUp
    case volumeDown
    case nextTrack
    case previousTrack
    case playPause
}

class MotionManager: ObservableObject {
    @Published var lastGesture: GestureType = .none
    
    private let motion = CMMotionManager()
    private var lastGestureTime: Date = Date()
    private let gestureCooldown: TimeInterval = 0.8  // Prevent double-triggers
    
    // Tunable thresholds
    private let twistThreshold: Double = 2.5  // rad/s for wrist rotation
    private let upsideDownThreshold: Double = 0.7  // gravity threshold
    private var upsideDownStartTime: Date?
    private let upsideDownHoldTime: TimeInterval = 1.5  // seconds to hold
    
    func startMonitoring() {
        guard motion.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }
        
        motion.deviceMotionUpdateInterval = 0.05  // 20Hz
        motion.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            self.processMotion(data)
        }
    }
    
    func stopMonitoring() {
        motion.stopDeviceMotionUpdates()
    }
    
    private func processMotion(_ data: CMDeviceMotion) {
        // Check cooldown period
        guard Date().timeIntervalSince(lastGestureTime) > gestureCooldown else {
            return
        }
        
        // Detect twist gestures (volume control)
        detectTwist(data)
        
        // Detect upside-down hold (play/pause)
        detectUpsideDown(data)
        
        // TODO: Add double-flick detection for track skip
    }
    
    private func detectTwist(_ data: CMDeviceMotion) {
        let rotationRate = data.rotationRate.z  // Rotation around Z-axis (pronation/supination)
        
        if abs(rotationRate) > twistThreshold {
            if rotationRate > 0 {
                triggerGesture(.volumeUp)
            } else {
                triggerGesture(.volumeDown)
            }
        }
    }
    
    private func detectUpsideDown(_ data: CMDeviceMotion) {
        let gravity = data.gravity.z
        
        // Hand is upside-down
        if gravity > upsideDownThreshold {
            if upsideDownStartTime == nil {
                upsideDownStartTime = Date()
            } else if let startTime = upsideDownStartTime,
                      Date().timeIntervalSince(startTime) >= upsideDownHoldTime {
                triggerGesture(.playPause)
                upsideDownStartTime = nil  // Reset
            }
        } else {
            upsideDownStartTime = nil  // Reset if hand returns to normal
        }
    }
    
    private func triggerGesture(_ gesture: GestureType) {
        lastGesture = gesture
        lastGestureTime = Date()
        
        // Reset to .none after a brief display period
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.lastGesture = .none
        }
    }
}
