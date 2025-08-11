//
//  Warrior2Pose.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 02/07/25.
//

import Vision

struct Warrior2Pose {
    
    static func isPoseDetected(from points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) -> Bool {
        let threshold: Float = 0.15

        guard
            let leftShoulder = points[.leftShoulder], leftShoulder.confidence > threshold,
            let rightShoulder = points[.rightShoulder], rightShoulder.confidence > threshold,
            let leftWrist = points[.leftWrist], leftWrist.confidence > threshold,
            let rightWrist = points[.rightWrist], rightWrist.confidence > threshold,
            let leftHip = points[.leftHip], leftHip.confidence > threshold,
            let rightHip = points[.rightHip], rightHip.confidence > threshold,
            let leftKnee = points[.leftKnee], leftKnee.confidence > threshold,
            let rightKnee = points[.rightKnee], rightKnee.confidence > threshold,
            let leftAnkle = points[.leftAnkle], leftAnkle.confidence > threshold,
            let rightAnkle = points[.rightAnkle], rightAnkle.confidence > threshold
        else {
            return false
        }

        // ✅ Heuristics

        // Arms level and extended
        let armsLevel = abs(leftShoulder.location.y - rightShoulder.location.y) < 0.1 &&
                        abs(leftShoulder.location.y - leftWrist.location.y) < 0.1 &&
                        abs(rightShoulder.location.y - rightWrist.location.y) < 0.1

        let armsExtended = abs(leftWrist.location.x - rightWrist.location.x) > 0.5

        // Front leg bent (knee and ankle close in x), back leg straight (hip–knee–ankle roughly aligned)
        let frontLegBentleft = abs(leftKnee.location.x - leftAnkle.location.x) < 0.1
                           
        let frontLegBentright = abs(rightKnee.location.x - rightAnkle.location.y) < 0.1
                           

        let backLegStraightright = abs(rightHip.location.x - rightAnkle.location.x) > 0.3
        let backLegStraightleft = abs(leftHip.location.x - leftAnkle.location.x) > 0.3

        // Hips level
        let hipsLevel = abs(leftHip.location.y - rightHip.location.y) < 0.1

        return armsLevel &&
               armsExtended &&
               ((frontLegBentleft && backLegStraightright) || (frontLegBentright && backLegStraightleft)) && hipsLevel
    }
}

