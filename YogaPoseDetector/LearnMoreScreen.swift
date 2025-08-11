//
//  LearnMoreScreen.swift
//  YogaPoseDetector
//
//  Created by Mayukh Baidya on 30/06/25.
//

import SwiftUI

struct LearnMoreScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Vrikshasana (Tree Pose)")
                    .font(.title)
                    .fontWeight(.bold)

                Text("🟢 Improves balance and stability in the legs.")
                Text("🟢 Strengthens the thighs, calves, and spine.")
                Text("🟢 Helps relieve sciatica and reduces flat feet.")
                Text("🟢 Promotes mindfulness and focus.")
            }
            .padding()
        }
        .navigationTitle("Learn More")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    LearnMoreScreen()
}
