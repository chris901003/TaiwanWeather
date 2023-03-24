//
//  WeatherInfoModel.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/23.
//

import Foundation

// 獲取到的資訊格式
struct WeatherInfoModel: Decodable {
    let success: String
    let records: Records
    
    struct Records: Decodable {
        let locations: [RecordsLocation]
    }
    
    struct RecordsLocation: Decodable {
        let location: [LocationLocation]
    }
    
    struct LocationLocation: Decodable {
        let weatherElement: [WeatherElement]
    }
    
    struct WeatherElement: Decodable {
        let elementName, description: String
        let time: [Time]
    }
    
    struct Time: Decodable {
        let dataTime: String?
        let elementValue: [ElementValue]
        let startTime, endTime: String?
    }
    
    struct ElementValue: Decodable {
        let value: String
    }
}
