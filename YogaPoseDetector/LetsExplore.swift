//
//  LetsExplore.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 01/07/25.
//

import SwiftUI

struct Card: Identifiable
{
    var id: UUID = .init()
    var image: String
    var title: String
}
struct LetsExplore: View {
    @State var currentIndex: Int = 0
    @GestureState var dragOffset: CGFloat = 0
    @State var showTutorial: Bool = false
    @State var showPractice: Bool = false
    @State var showLearnMore: Bool = false
    @EnvironmentObject var viewModel: PoseDetectionViewModel
    
    @State var cards: [Card] = [
        Card(image: "vrikshasana", title: "Vrikshasana"),
        Card(image: "warrior_2", title: "Warrior 2"),
        Card(image: "goddess_pose", title: "Goddess Pose"),
        Card(image: "trikonasana", title: "Trikonasana"),
        Card(image: "tadasana2", title: "Tadasana")
    ]
    
    var body: some View {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                attachNavigation(to:
                VStack(spacing: 20) {
                    title
                    subtitle

                    ZStack {
                        carddrag
                    }
                    .frame(maxHeight: .infinity)
                    bottomButtons
                    .padding(.bottom, 20)
                }
                .padding()
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            handleSwipe(value: value)
                        }
                    )
                )
                
            }
    }
}
struct PoseDetectionWrapperView: View {
    let poseName: String
    @EnvironmentObject var viewModel: PoseDetectionViewModel

    var body: some View {
        PoseDetectionScreen(poseName: poseName)
            .onAppear {
                viewModel.startPoseTimer(poseName: poseName)
            }
            .onDisappear {
                viewModel.stopPoseTimer()
            }
    }
}

extension LetsExplore {
    private var title: some View {
        Text("Ready?")
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    private var subtitle: some View {
        Text("Swipe through and click on the pose you want to try out!")
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    private var carddrag: some View {
        ForEach(0..<cards.count, id: \.self) { index in
            Image(cards[index].image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280, maxHeight: 340)
                .cornerRadius(15)
                .opacity(currentIndex == index ? 1.0 : 0.5)
                .scaleEffect(currentIndex == index ? 1.0 : 0.5)
                .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset)
                .zIndex(currentIndex == index ? 1.0 : 0.5)
        }
    }
    private var bottomButtons: some View {
        HStack {
            Spacer()
            Button("Tutorial") {
                showTutorial = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Button("Practice") {
                showPractice = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Button("Learn More") {
                showLearnMore = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        
    }
    private func handleSwipe(value: DragGesture.Value) {
            let threshold: CGFloat = 50
            if value.translation.width > threshold {
                withAnimation(.easeInOut) {
                    currentIndex = max(0, currentIndex - 1)
                }
            } else if value.translation.width < -threshold {
                withAnimation(.easeInOut) {
                    currentIndex = min(cards.count - 1, currentIndex + 1)
                }
            }
        }
    private func attachNavigation(to view: some View) -> some View {
            withAnimation(.easeInOut)
            {
                view
                    .navigationDestination(isPresented: $showTutorial) {
                        cards[currentIndex].title == "Vrikshasana" ? AnyView(ARViewScreen()) : AnyView(LearnMoreScreen())
                    }
                    .navigationDestination(isPresented: $showPractice) {
                        PoseDetectionWrapperView(poseName: cards[currentIndex].title)
                    }
                    .navigationDestination(isPresented: $showLearnMore) {
                        LearnMoreScreen()
                    }
            }
            
        }
}
#Preview {
    LetsExplore()
}

