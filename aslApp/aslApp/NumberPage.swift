//
//  NumberPage.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct NumberPage: View {
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text("Numbers Learning Page")
                    .font(.title)
                    .bold()
                NumberProgress()
                    .padding(.bottom, 25)
              /*  ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 40) {
                            LearningWidget(learning: "1", image: Image("1"), )
                            LearningWidget(learning: "2", image: Image("2"))
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "3", image: Image("3"))
                            LearningWidget(learning: "4", image: Image("4"))
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "5", image: Image("5"))
                            LearningWidget(learning: "6", image: Image("6"))
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "7", image: Image("7"))
                            LearningWidget(learning: "88", image: Image("8"))
                        }
                        HStack(spacing: 40) {
                            LearningWidget(learning: "9", image: Image("9"))
                            LearningWidget(learning: "10", image: Image("10"))
                        }
                    }
                }
                .scrollIndicators(.never)*/
            }
        }
    }
}

#Preview {
    NumberPage()
}
