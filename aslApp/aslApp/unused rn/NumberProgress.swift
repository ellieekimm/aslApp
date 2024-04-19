//
//  NumberProgress.swift
//  aslApp
//
//  Created by Ellie Kim on 4/11/24.
//

import SwiftUI

struct NumberProgress: View {
    @State private var downloadAmount = 0.0

    var body: some View {
        ProgressView(value: downloadAmount, total: 10) {
        }
        .progressViewStyle(LinearProgressViewStyle())
        .accentColor(Color("label-bg"))
        .frame(height: 20)
        .padding([.leading, .trailing], 15)

    }
}

#Preview {
    NumberProgress()
}
