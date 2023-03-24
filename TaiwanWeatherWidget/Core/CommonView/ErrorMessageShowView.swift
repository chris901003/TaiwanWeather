//
//  ErrorMessageShowView.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/22.
//

import Foundation
import SwiftUI

struct ErrorMessageShowView: View {
    
    var message: String
    var textFont: Font
    var textColor: Color
    
    init(message: String, textFont: Font = .headline, textColor: Color = .red) {
        self.message = message
        self.textFont = textFont
        self.textColor = textColor
    }
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text(message)
                .font(textFont)
                .foregroundColor(textColor)
                .padding()
                .padding(.horizontal)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .transition(AnyTransition.move(edge: .bottom))
            Spacer()
        }
    }
}
