//
//  TaiwanWeatherWidgetExtension.swift
//  TaiwanWeatherWidgetExtension
//
//  Created by 黃弘諺 on 2023/3/19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
//    private var manager: ProviderManager = ProviderManager()
    
    func placeholder(in context: Context) -> WeatherInfoEntry {
        WeatherInfoEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherInfoEntry) -> ()) {
        Task {
            var entry = WeatherInfoEntry(date: Date())
            entry.info = await ProviderManager.getInfo()
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        Task {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            var entry = WeatherInfoEntry(date: entryDate)
            entry.info = await ProviderManager.getInfo()
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct WeatherInfoEntry: TimelineEntry {
    let date: Date
    var temperature: [(Int, Date)] = []
    var rainRate: [(Int, Date)] = []
    var bodyTemperature: [(Int, Date)] = []
    var timeLine: [Date] = []
    
    var info: String = ""
}

struct TaiwanWeatherWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    let t = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hungyen.TaiwanWeatherWidget")?.appending(path: "Weather")

    var body: some View {
        Text(entry.info)
    }
}

struct TaiwanWeatherWidgetExtension: Widget {
    let kind: String = "TaiwanWeatherWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaiwanWeatherWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("天氣")
        .description("獲取當地天氣")
        .supportedFamilies([.systemMedium])
    }
}
