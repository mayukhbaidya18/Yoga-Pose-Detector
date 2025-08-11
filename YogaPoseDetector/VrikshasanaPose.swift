//
//  VrikshasanaPose.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 02/07/25.
//

import Vision

struct VrikshasanaPose {
    
    static func isPoseDetected(from points: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) -> Bool {
        let confidenceThreshold: Float = 0.15

        guard
            let leftAnkle = points[.leftAnkle], leftAnkle.confidence > confidenceThreshold,
            let rightAnkle = points[.rightAnkle], rightAnkle.confidence > confidenceThreshold,
            let leftKnee = points[.leftKnee], leftKnee.confidence > confidenceThreshold,
            let rightKnee = points[.rightKnee], rightKnee.confidence > confidenceThreshold,
            let leftHip = points[.leftHip], leftHip.confidence > confidenceThreshold,
            let rightHip = points[.rightHip], rightHip.confidence > confidenceThreshold
        else {
            return false
        }

        let leftWrist = points[.leftWrist]
        let rightWrist = points[.rightWrist]
        let leftShoulder = points[.leftShoulder]
        let rightShoulder = points[.rightShoulder]

        let leftFootNearRightKnee = abs(leftAnkle.location.y - rightKnee.location.y) < 0.15 &&
                                    abs(leftAnkle.location.x - rightKnee.location.x) < 0.15
        let rightFootNearLeftKnee = abs(rightAnkle.location.y - leftKnee.location.y) < 0.15 &&
                                    abs(rightAnkle.location.x - leftKnee.location.x) < 0.15

        let oneLegStanding = abs(leftAnkle.location.y - rightAnkle.location.y) > 0.15 ||
                             abs(leftKnee.location.y - rightKnee.location.y) > 0.15

        let hipsLevel = abs(leftHip.location.y - rightHip.location.y) < 0.1

        var handsAboveShoulders = false
        var handsCloseTogether = false

        if let lWrist = leftWrist, let rWrist = rightWrist,
           let lShoulder = leftShoulder, let rShoulder = rightShoulder,
           lWrist.confidence > confidenceThreshold,
           rWrist.confidence > confidenceThreshold,
           lShoulder.confidence > confidenceThreshold,
           rShoulder.confidence > confidenceThreshold {

            let shoulderWidth = abs(lShoulder.location.x - rShoulder.location.x)

            handsAboveShoulders = (lWrist.location.y > lShoulder.location.y) &&
                                  (rWrist.location.y > rShoulder.location.y)

            handsCloseTogether = abs(lWrist.location.x - rWrist.location.x) < shoulderWidth
        }

        return (leftFootNearRightKnee || rightFootNearLeftKnee) &&
               oneLegStanding &&
               hipsLevel &&
               (handsAboveShoulders && handsCloseTogether)
    }
}

