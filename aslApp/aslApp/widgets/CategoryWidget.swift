//
//  CategoryWidget.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct CategoryWidget: View {
    let text: String
    let image: String
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 4, y: 4)
                    .frame(width: 125, height: 150)
            if (isSelected) {
                Circle()
                    .foregroundColor(Color("MainGreen"))
                    .frame(width: 40, height: 40)
                    .offset(y: -70)
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white)
                    .offset(y: -70)
            }
            VStack(alignment: .center) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text(text)
                    .font(.title3)
            }
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    CategoryWidget(text: "Alphabet", image: "letters_category", isSelected: .constant(true))

}
