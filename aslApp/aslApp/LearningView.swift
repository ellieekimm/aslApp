//
//  LearningView.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct LearningView: View {
    @State var disabled: Bool = true
    @State private var isAlphabetSelected: Bool = false
    @State private var isNumbersSelected: Bool = false
    
    var body: some View {
        ZStack {
            Color(Color.white)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Text("Choose Your Category")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .padding(.bottom, 60)
                    .padding(.top, 20)
                HStack {
                    Spacer()
                    Button(action: {
                        if (isNumbersSelected == false) {
                            isAlphabetSelected.toggle()
                            disabled.toggle()
                        }
                    }, label: {
                        CategoryWidget(text: "Alphabet", image: "letters_category", isSelected: $isAlphabetSelected)                    })
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                    Button(action: {
                        if (isAlphabetSelected == false) {
                            disabled.toggle()
                            isNumbersSelected.toggle()
                        }

                    }, label: {
                        CategoryWidget(text: "Numbers", image: "numbers_category", isSelected: $isNumbersSelected)                    })
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
                Spacer()
                Button(action: {
                }) {
                    Text("Next")
                        .foregroundColor(disabled ? Color.gray : Color.white)
                        .padding()
                        .frame(minWidth: 100)
                }
                .background(disabled ? Color.gray.opacity(0.4) : Color("MainGreen"))
                .cornerRadius(20)
                .disabled(disabled)
            }
        }
    }
}

#Preview {
    LearningView()
}
