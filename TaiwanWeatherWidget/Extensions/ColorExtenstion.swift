//
//  ColorExtenstion.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/24.
//

import Foundation
import SwiftUI

struct ColorTheme {
    
    let temperatureColor: [String: Color] = ["veryColdColor": Color(hex: "#5BC0F8"), "coldColor": Color(hex: "#86E5FF"), "warmColor": Color(hex: "#FFC93C"), "littleHotColor": Color(hex: "#FF8787"), "mediumHotColor": Color(hex: "#E64848"), "veryHotColor": Color(hex: "#C21010")]
    let rainRateColor: [String: Color] = ["rate20": Color(hex: "#00FFF6"), "rate40": Color(hex: "#00E7FF"), "rate60": Color(hex: "009EFF"), "rate80": Color(hex: "#0014FF"), "rate100": Color(hex: "#070D59")]
}

extension Color {
    
    static let theme = ColorTheme()
}

extension Color {
    
    /// 根據輸入的溫度獲取顏色
    static func getTemperatureColor(temperature: Int) -> Color {
        if temperature < 15 {
            return self.theme.temperatureColor["veryColdColor"]!
        } else if temperature < 20 {
            return self.theme.temperatureColor["coldColor"]!
        } else if temperature < 23 {
            return self.theme.temperatureColor["warmColor"]!
        } else if temperature < 26 {
            return self.theme.temperatureColor["littleHotColor"]!
        } else if temperature < 30 {
            return self.theme.temperatureColor["mediumHotColor"]!
        } else {
            return self.theme.temperatureColor["veryHotColor"]!
        }
    }
    
    static func getRainRateColor(rainRate: Int) -> Color {
        if rainRate <= 20 {
            return self.theme.rainRateColor["rate20"]!
        } else if rainRate <= 40 {
            return self.theme.rainRateColor["rate40"]!
        } else if rainRate <= 60 {
            return self.theme.rainRateColor["rate60"]!
        } else if rainRate <= 80 {
            return self.theme.rainRateColor["rate80"]!
        } else {
            return self.theme.rainRateColor["rate100"]!
        }
    }
}

extension Color {
    
    // Source Code: https://juejin.cn/post/6948250295549820942
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
