//
//  TadasanaPose.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 02/07/25.
//

import Vision

struct TadasanaPose {
    
    static func isPoseDetected(from points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) -> Bool {
        let threshold: Float = 0.15

        guard
            let leftWrist = points[.leftWrist], leftWrist.confidence > threshold,
            let rightWrist = points[.rightWrist], rightWrist.confidence > threshold,
            let leftShoulder = points[.leftShoulder], leftShoulder.confidence > threshold,
            let rightShoulder = points[.rightShoulder], rightShoulder.confidence > threshold,
            let leftHip = points[.leftHip], leftHip.confidence > threshold,
            let rightHip = points[.rightHip], rightHip.confidence > threshold,
            let leftKnee = points[.leftKnee], leftKnee.confidence > threshold,
            let rightKnee = points[.rightKnee], rightKnee.confidence > threshold,
            let leftAnkle = points[.leftAnkle], leftAnkle.confidence > threshold,
            let rightAnkle = points[.rightAnkle], rightAnkle.confidence > threshold
        else {
            return false
        }

        // ✅ Arms raised above shoulders
        let armsRaised = leftWrist.location.y > leftShoulder.location.y &&
                         rightWrist.location.y > rightShoulder.location.y

        // ✅ Wrists close together overhead
        let wristsTogether = abs(leftWrist.location.x - rightWrist.location.x) < 0.15

        // ✅ Legs straight:
        let LegStraight = abs(leftAnkle.location.x - rightAnkle.location.x) < 0.1

        
        return armsRaised && wristsTogether && LegStraight
    }
}

