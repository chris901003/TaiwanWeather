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
                                Text("\(getRainRate(targetTime: timeLine[idx]))%")
                                    .foregroundColor(Color.getWidgetRainRateColor(rainRate: getRainRate(targetTime: timeLine[idx])))
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

extension MedieumWidgetView {
    
    /// 獲取下雨機率，由於下雨機率是6小時為單位所以需要叉分
    func getRainRate(targetTime: Date) -> Int {
        let idx = rainRate.firstIndex { $0.1 == targetTime }
        if idx != nil {
            return rainRate[idx!].0
        }
        guard let futureTime = Calendar.current.date(byAdding: .hour, value: 3, to: targetTime) else {
            return 0
        }
        guard let pastTime = Calendar.current.date(byAdding: .hour, value: -3, to: targetTime) else {
            return 0
        }
        let idx1 = rainRate.firstIndex { $0.1 == futureTime }
        let idx2 = rainRate.firstIndex { $0.1 == pastTime }
        guard idx1 != nil || idx2 != nil else { return 0 }
        var tmp = 0
        if idx1 != nil { tmp += rainRate[idx1!].0 }
        if idx2 != nil { tmp += rainRate[idx2!].0 }
        tmp = tmp / ((idx1 != nil ? 1 : 0) + (idx2 != nil ? 1 : 0))
        return tmp
    }
}
