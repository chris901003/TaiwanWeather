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
}
