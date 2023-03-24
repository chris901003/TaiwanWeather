//
//  TaiwanWeatherWidgetApp.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import SwiftUI

@main
struct TaiwanWeatherWidgetApp: App {
    
    let coreDataController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
