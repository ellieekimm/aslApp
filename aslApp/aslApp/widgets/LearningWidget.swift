//
//  LearningWidget.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct LearningWidget: View {
    var learning: String
    var image: Image
    let onSelect: (String) -> Void
    @State private var isSelected = false
    
    var body: some View {
        Button(action: {
            onSelect(learning)
            isSelected.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 4, y: 4)
                    .frame(width: 140, height: 180)
                if (isSelected) {
                    Circle()
                            .foregroundColor(Color("MainGreen"))
                            .frame(width: 40, height: 40)
                            .offset(y: -95)
                    Image(systemName: "checkmark")
                            .foregroundColor(Color.white)
                            .offset(y: -95)
                }
                VStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text(learning)
                        .font(.title)
                }
            
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}

