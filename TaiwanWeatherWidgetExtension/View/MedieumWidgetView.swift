//
//  MedieumWidgetView.swift
//  TaiwanWeatherWidgetExtensionExtension
//
//  Created by 黃弘諺 on 2023/3/25.
//

import SwiftUI

struct MedieumWidgetView: View {
    var selectedTown: String
    var temperature: [(Int, Date)]
    var rainRate: [(Int, Date)]
    var bodyTemperature: [(Int, Date)]
    var timeLine: [Date]
    var info: String
    var currentTemperature: Int
    
    var body: some View {
        ZStack {
            Image("WidgetBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
            if info == "" {
                VStack(spacing: 8) {
                    HStack {
                        Text(selectedTown)
                            .font(Font.custom("ChalkboardSE-Bold", size: 25))
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("\(currentTemperature)° C")
                            .font(Font.custom("ChalkboardSE-Bold", size: 30))
                            .foregroundColor(Color.getTemperatureColor(temperature: currentTemperature))
                    }
                    .padding(.horizontal)
                    HStack {
                        VStack(spacing: 2) {
                            Image(systemName: "clock")
                            Image(systemName: "thermometer.medium")
                            Image(systemName: "cloud.rain")
                        }
                        .foregroundColor(Color.white)
                        ForEach(timeLine.prefix(5).indices, id: \.self) { idx in
                            VStack(spacing: 2) {
                                Text(timeLine[idx].formateToHour())
                                    .foregroundColor(Color.white)
                                Text("\(temperature[idx].0)°")
                                    .foregroundColor(Color.getTemperatureColor(temperature: temperature[idx].0))
                                Text("\(rainRate[idx].0)%")
                                    .foregroundColor(Color.getWidgetRainRateColor(rainRate: rainRate[idx].0))
                            }
                        }
                    }
                    .font(Font.custom("ChalkboardSE-Bold", size: 18))
                    .bold()
                    .padding(4)
                    .padding(.horizontal)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
            } else {
                VStack {
                    Text(info)
                        .font(Font.custom("ChalkboardSE-Bold", size: 20))
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}
