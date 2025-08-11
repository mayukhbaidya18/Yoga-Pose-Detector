//
//  TrikonasanaPose.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 02/07/25.
//

import Vision

struct TrikonasanaPose {
    
    static func isPoseDetected(from points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) -> Bool {
        let confidenceThreshold: Float = 0.15
        
        // Required joints
        guard
            let leftWrist = points[.leftWrist], leftWrist.confidence > confidenceThreshold,
            let rightWrist = points[.rightWrist], rightWrist.confidence > confidenceThreshold,
            let leftShoulder = points[.leftShoulder], leftShoulder.confidence > confidenceThreshold,
            let rightShoulder = points[.rightShoulder], rightShoulder.confidence > confidenceThreshold
        else {
            return false
        }

        // ✅ Basic logic for Trikonasana:
        // One arm raised straight above shoulder line, and body tilted (hips and shoulders not aligned horizontally)

        let oneArmRaised = (abs(leftWrist.location.x - leftShoulder.location.x) < 0.1 &&
                           (leftWrist.location.y > leftShoulder.location.y)) || (abs(rightWrist.location.x - rightShoulder.location.x) < 0.1 && (rightWrist.location.y > rightShoulder.location.y))

        let bodyTilted = abs(leftShoulder.location.y - rightShoulder.location.y) > 0.2

        return oneArmRaised && bodyTilted
    }
}

