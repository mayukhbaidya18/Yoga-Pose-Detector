//
//  HomeView.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 01/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: PoseDetectionViewModel 
    @State private var showProgressSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                VStack(spacing: 30) {
                    title
                    subtitle
                    letsexplore
                    progressbuttonsheet
                }
                .padding()
            }
        }
    }
}

#Preview {
    let vm = PoseDetectionViewModel()
    vm.yogaDates = [
        Calendar.current.startOfDay(for: Date()),
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    ]
    return HomeView()
        .environmentObject(vm) // ✅ Inject into preview too
}

extension HomeView {
    private var title: some View {
        Text("YogaFlex")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 40)
    }
    private var subtitle: some View {
        Text("Placeholder text for YogaFlex...")
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .font(.body)
    }
    private var letsexplore: some View {
        NavigationLink {
            LetsExplore()
        } label: {
            Text("Lets Explore!")
                .foregroundStyle(.white)
                .font(.title2)
                .frame(width: 250, height: 60)
                .background(.purple)
                .cornerRadius(15)
        }
    }
    private var progressbuttonsheet: some View {
        Button {
            showProgressSheet = true
        } label: {
            Text("📈 View Progress")
                .font(.title3)
                .foregroundStyle(.white)
                .padding()
                .frame(width: 200)
                .background(.blue)
                .cornerRadius(12)
        }
        .sheet(isPresented: $showProgressSheet) {
            StreakSheetView()
        }
    }
}
