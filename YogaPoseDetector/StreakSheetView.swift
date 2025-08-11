//
//  StreakSheetView.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 03/07/25.
//

import SwiftUI
import Charts

struct StreakSheetView: View {
    @EnvironmentObject var viewModel: PoseDetectionViewModel 
    
    struct PoseChartData: Identifiable {
        let id = UUID()
        let poseName: String
        let duration: Double
    }
    
    var chartData: [PoseChartData] {
        let durations = viewModel.poseDurations
        return durations.map { (pose, seconds) in
            PoseChartData(poseName: pose, duration: seconds)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("🗓️ Your Yoga Calendar")
                    .font(.title2)
                    .bold()
                    .padding(.top, 24)

                HorizontalCalendarView(viewModel: viewModel)
                    .frame(height: 100)

                Text("🔥 Longest Streak: \(viewModel.maxStreak) days")
                    .font(.headline)
                    .padding()
                
                Text("🧘‍♂️ Time Spent on Each Pose")
                    .font(.headline)

                Chart {
                    ForEach(chartData) { data in
                        SectorMark(
                            angle: .value("Time", data.duration),
                            innerRadius: .ratio(0.4)
                        )
                        .foregroundStyle(by: .value("Pose", data.poseName))
                    }
                }
                .frame(height: 250)
                .padding(.bottom, 10)
                
                Spacer()

            }
            .padding()
        }
        
        .padding()
        .presentationDetents([.medium, .large])
    }
}
