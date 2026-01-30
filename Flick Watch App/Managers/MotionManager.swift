//
//  MotionManager.swift
//  Flick
//
//  Created by Liam Lefohn on 1/27/26.
//
// Reads sensors, detects gestures - runs as workout session for background execution

import Foundation
import CoreMotion
import Combine
import HealthKit

// Gesture types the app can detect
enum GestureType {
    case none
    case nextTrack      // Flick CCW (left)
    case previousTrack  // Flick CW (right)
    case playPause      // Hold upside-down
}

class MotionManager: NSObject, ObservableObject {
    @Published var lastGesture: GestureType = .none
    
    private let motion = CMMotionManager()
    private var lastGestureTime: Date = Date()
    private let gestureCooldown: TimeInterval = 0.8
    
    // Workout session for background execution
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    
    // Tunable thresholds
    private let twistThreshold: Double = 2.5
    private let upsideDownThreshold: Double = 0.7
    private var upsideDownStartTime: Date?
    private let upsideDownHoldTime: TimeInterval = 1.5
    
    var isLeftWrist: Bool = true
    
    override init() {
        super.init()
        requestHealthKitAuthorization()
    }
    
    private func requestHealthKitAuthorization() {
        let typesToShare: Set = [HKObjectType.workoutType()]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: nil) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    func startMonitoring() {
        // Start workout session for background execution
        startWorkoutSession()
        
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
        endWorkoutSession()
    }
    
    private func startWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other  // Generic activity type
        configuration.locationType = .unknown
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            
            workoutSession?.delegate = self
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { success, error in
                if let error = error {
                    print("Error starting workout builder: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error starting workout session: \(error.localizedDescription)")
        }
    }
    
    private func endWorkoutSession() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { success, error in
            if success {
                self.workoutBuilder?.finishWorkout { workout, error in
                    // Workout finished
                }
            }
        }
    }
    
    private func processMotion(_ data: CMDeviceMotion) {
        guard Date().timeIntervalSince(lastGestureTime) > gestureCooldown else {
            return
        }
        
        detectTwist(data)
        detectUpsideDown(data)
    }
    
    private func detectTwist(_ data: CMDeviceMotion) {
        let rotationRate = data.rotationRate.z
        
        if abs(rotationRate) > twistThreshold {
            if isLeftWrist {
                if rotationRate > 0 {
                    triggerGesture(.nextTrack)
                } else {
                    triggerGesture(.previousTrack)
                }
            } else {
                // Right wrist - flip it
                if rotationRate > 0 {
                    triggerGesture(.previousTrack)
                } else {
                    triggerGesture(.nextTrack)
                }
            }
        }
    }
    
    private func detectUpsideDown(_ data: CMDeviceMotion) {
        let gravity = data.gravity.z
        
        if gravity > upsideDownThreshold {
            if upsideDownStartTime == nil {
                upsideDownStartTime = Date()
            } else if let startTime = upsideDownStartTime,
                      Date().timeIntervalSince(startTime) >= upsideDownHoldTime {
                triggerGesture(.playPause)
                upsideDownStartTime = nil
            }
        } else {
            upsideDownStartTime = nil
        }
    }
    
    private func triggerGesture(_ gesture: GestureType) {
        lastGesture = gesture
        lastGestureTime = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.lastGesture = .none
        }
    }
}

// MARK: - HKWorkoutSessionDelegate
extension MotionManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        // Handle state changes if needed
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }
}
