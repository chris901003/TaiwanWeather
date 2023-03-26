//
//  Sma.swift
//  TaiwanWeatherWidgetExtensionExtension
//
//  Created by 黃弘諺 on 2023/3/25.
//

import SwiftUI

struct SmallWidgetView: View {
    
    var selectedTown: String
    var temperature: Int
    var rainRate: Int
    var info: String
    
    var body: some View {
        ZStack {
            Image("WidgetBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Text(selectedTown)
                    .foregroundColor(Color.white)
                    .font(.title)
                    .bold()
                Text("\(temperature)° C")
                    .foregroundColor(Color.getTemperatureColor(temperature: temperature))
                    .font(Font.custom("ChalkboardSE-Bold", size: 30))
                Text("\(rainRate)%")
                    .foregroundColor(Color.getWidgetRainRateColor(rainRate: rainRate))
                    .font(Font.custom("ChalkboardSE-Bold", size: 30))
            }
        }
    }
}
