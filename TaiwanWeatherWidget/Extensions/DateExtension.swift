//
//  DateExtension.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/23.
//

import Foundation

extension Date {
    
    /// 將從氣象局獲取的時間轉換成Date格式
    static func formateToDate(from info: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let timeDate = formatter.date(from: info) else {
            return Date()
        }
        return timeDate
    }
    
    /// 轉換成小時資料
    func formateToHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let hourString = formatter.string(from: self) + "時"
        return hourString
    }
    
    /// 獲取下個半小時的時間，如果小於30分就會給30，否則就會給下個小時
    static func getNextHalfHourTime() -> Date {
        let currentDate = Date()
        let currentMin = Calendar.current.component(.minute, from: currentDate)
        let currentSec = Calendar.current.component(.second, from: currentDate)
        let toNextHalfHour = 30 * 60 - (currentMin * 60 + currentSec)
        let toNextHour = 60 * 60 - (currentMin * 60 + currentSec)
        if toNextHalfHour > 0 {
            let nextHalfHour = Calendar.current.date(byAdding: .second, value: toNextHalfHour, to: currentDate)!
            return nextHalfHour
        } else {
            let nextHalfHour = Calendar.current.date(byAdding: .second, value: toNextHour, to: currentDate)!
            return nextHalfHour
        }
    }
}
