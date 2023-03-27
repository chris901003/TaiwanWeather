//
//  TaiwanWeatherWidgetExtension.swift
//  TaiwanWeatherWidgetExtension
//
//  Created by 黃弘諺 on 2023/3/19.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> WeatherInfoEntry {
        WeatherInfoEntry(date: Date(), info: "我只是固定顯示")
    }
    
    func getSnapshot(for configuration: SelectLocationIntent, in context: Context, completion: @escaping (WeatherInfoEntry) -> Void) {
        Task {
            let manager: ProviderManager = ProviderManager()
            let currentDate = Date()
            manager.getUserSelectedLocation()
            await manager.fetchWeatherInfo()
            var weatherInfoEntry = WeatherInfoEntry(date: currentDate, selectedTown: manager.selectedTown, temperature: manager.temperature, rainRate: manager.rainRate, bodyTemperature: manager.bodyTemperature, timeLine: manager.timeLine, currentTemperature: manager.currentTemperature, currentRainRate: manager.currentRainRate)
            if manager.isError {
                weatherInfoEntry.info = manager.errorMessage
            }
            completion(weatherInfoEntry)
        }
    }
    
    func getTimeline(for configuration: SelectLocationIntent, in context: Context, completion: @escaping (Timeline<WeatherInfoEntry>) -> Void) {
        Task {
            let manager: ProviderManager = ProviderManager()
            let nextUpdate = Date.getNextHalfHourTime()
            if let selectLocationString = configuration.Location {
                manager.getUserSelectedLocation(selectedLocation: selectLocationString)
            } else {
                manager.getUserSelectedLocation()
            }
            let currentDate = Date()
            await manager.fetchWeatherInfo()
            var weatherInfoEntry = WeatherInfoEntry(date: currentDate, selectedTown: manager.selectedTown, temperature: manager.temperature, rainRate: manager.rainRate, bodyTemperature: manager.bodyTemperature, timeLine: manager.timeLine, currentTemperature: manager.currentTemperature, currentRainRate: manager.currentRainRate)
            if manager.isError {
                weatherInfoEntry.info = manager.errorMessage
            }
            let timeline = Timeline(entries: [weatherInfoEntry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct WeatherInfoEntry: TimelineEntry {
    let date: Date
    var selectedTown: String = ""
    var temperature: [(Int, Date)] = []
    var rainRate: [(Int, Date)] = []
    var bodyTemperature: [(Int, Date)] = []
    var timeLine: [Date] = []
    var currentTemperature = 0
    var currentRainRate = 0
    var info: String = ""
}

struct TaiwanWeatherWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(selectedTown: entry.selectedTown, temperature: entry.currentTemperature, rainRate: entry.currentRainRate, info: entry.info)
        case .systemMedium:
            MedieumWidgetView(selectedTown: entry.selectedTown, temperature: entry.temperature, rainRate: entry.rainRate, bodyTemperature: entry.bodyTemperature, timeLine: entry.timeLine, info: entry.info, currentTemperature: entry.currentTemperature)
        default:
            Text("Error")
        }
    }
}

struct TaiwanWeatherWidgetExtension: Widget {
    let kind: String = "TaiwanWeatherWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectLocationIntent.self, provider: Provider()) { entry in
            TaiwanWeatherWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("天氣")
        .description("獲取當地天氣")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
