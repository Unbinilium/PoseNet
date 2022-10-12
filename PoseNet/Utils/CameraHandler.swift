import AVFoundation
import SwiftUI

class CameraHandler: ObservableObject {
    private var poseNet: PoseNet!
    private var poseVisualizer = PoseVisualizer()
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    private let videoCapture = VideoCapture()
    private var currentFrame: CGImage?
    @Published var cachedFrame: CGImage?
    
    
    init() {
        // For convenience, the idle timer is disabled to prevent the screen from locking.
        UIApplication.shared.isIdleTimerDisabled = true
        
        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        
        poseNet.delegate = self
        setupAndBeginCapturingVideoFrames()
    }
    
    
    // MARK: - Setup and Capture
    
    private func setupAndBeginCapturingVideoFrames() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }
            
            self.videoCapture.delegate = self
            self.videoCapture.startCapturing()
        }
    }
    
    
    // MARK: - Flip Camera
    
    func flipCamera() {
        videoCapture.flipCamera { error in
            if let error = error {
                print("Failed to flip camera with error \(error)")
            }
        }
    }
    
    
    // MARK: - Update PoseBuilder Configuration
    
    func updatePoseBuilderConfiguration(poseBuilderConfiguration: PoseBuilderConfiguration) {
        self.poseBuilderConfiguration = poseBuilderConfiguration
    }
}


// MARK: - VideoCapture Delegate

extension CameraHandler: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }
        
        currentFrame = image
        poseNet.predict(image)
    }
}


// MARK: - PoseNet Delegate

extension CameraHandler: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }
        
        let poseBuilder = PoseBuilder(output: predictions, configuration: poseBuilderConfiguration, inputImage: currentFrame)
        
        let poses = poseBuilderConfiguration.algorithm == .single ? [poseBuilder.pose] : poseBuilder.poses
        
        if let frame = poseVisualizer.render(poses: poses, on: currentFrame) {
            cachedFrame = frame
        }
    }
}
