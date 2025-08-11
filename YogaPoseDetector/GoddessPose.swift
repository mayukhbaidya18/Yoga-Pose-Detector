//
//  GoddessPose.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 02/07/25.
//

import Vision

struct GoddessPose {
    
    static func isPoseDetected(from points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) -> Bool {
        let threshold: Float = 0.15

        guard
            let leftKnee = points[.leftKnee], leftKnee.confidence > threshold,
            let rightKnee = points[.rightKnee], rightKnee.confidence > threshold,
            let leftHip = points[.leftHip], leftHip.confidence > threshold,
            let rightHip = points[.rightHip], rightHip.confidence > threshold,
            let leftAnkle = points[.leftAnkle], leftAnkle.confidence > threshold,
            let rightAnkle = points[.rightAnkle], rightAnkle.confidence > threshold,
            let leftWrist = points[.leftWrist], leftWrist.confidence > threshold,
            let rightWrist = points[.rightWrist], rightWrist.confidence > threshold,
            let leftShoulder = points[.leftShoulder], leftShoulder.confidence > threshold,
            let rightShoulder = points[.rightShoulder], rightShoulder.confidence > threshold
        else {
            return false
        }

        // ✅ Wide feet: distance between ankles
        let ankleDistance = abs(leftAnkle.location.x - rightAnkle.location.x)
        let wideStance = ankleDistance > 0.5

        // ✅ Knees bent: knees lower than hips
        let kneesBent = leftKnee.location.y - leftHip.location.y < 0.2 &&
                        rightKnee.location.y - rightHip.location.y < 0.2

        // ✅ Hands close together in front of chest (prayer position)
        let handsNearCenter = abs(leftWrist.location.x - rightWrist.location.x) < 0.1 &&
                              abs(leftWrist.location.y - rightWrist.location.y) < 0.1 &&
                              abs(leftWrist.location.y - leftShoulder.location.y) < 0.2

        // ✅ Shoulders level
        let shouldersLevel = abs(leftShoulder.location.y - rightShoulder.location.y) < 0.1

        return wideStance && kneesBent && handsNearCenter && shouldersLevel
    }
}

