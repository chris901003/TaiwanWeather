//
//  TaiwanWeatherWidgetApp.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import SwiftUI
import GoogleMobileAds

@main
struct TaiwanWeatherWidgetApp: App {
    
    let coreDataController = CoreDataManager.shared
    init() {
        GADMobileAds.sharedInstance().start()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
