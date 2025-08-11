//
//  YogaPoseDetectorApp.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 28/06/25.
//

import SwiftUI

@main
struct YogaPoseDetectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PoseDetectionViewModel())
        }
    }
}
