//
//  ContentView.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isNavigated = false
    var body: some View {
        if isNavigated {
            LearningView()
        } else {
            ZStack {
                Color(Color.white)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 650, height: 600)
                    Text("SignSprouts")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("MainGreen"))
                        .offset(y: -100)
                    ProgressView()
                         .progressViewStyle(CircularProgressViewStyle())
                         .scaleEffect(2.0)
                         .padding()
                         .offset(y: -100)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        isNavigated = true
                    }
                }
            }
        }
    }
}


#Preview{
    ContentView()
}
