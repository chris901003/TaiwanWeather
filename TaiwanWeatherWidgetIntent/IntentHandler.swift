//
//  IntentHandler.swift
//  TaiwanWeatherWidgetIntent
//
//  Created by 黃弘諺 on 2023/3/26.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: SelectLocationIntentHandling {
    
    func provideLocationOptionsCollection(for intent: SelectLocationIntent) async throws -> INObjectCollection<NSString> {
        let allLocationsDict = TownCodeModel.townCode
        let allLocationsList = allLocationsDict.map { cityName, townsName in
            let locationsName = townsName.map { townName in
                cityName + " " + townName
            }
            return locationsName
        }
        let allLocations = allLocationsList.flatMap { $0 }
        return INObjectCollection(items: allLocations as [NSString])
    }
    
    func defaultLocation(for intent: SelectLocationIntent) -> String? {
        if let userInfo = CoreDataManager.shared.fetchUserInfo() {
            let selectedCity = userInfo.selectedCity!
            let selectedTown = userInfo.selectedTown!
            return selectedCity + " " + selectedTown
        } else {
            return "新北市 樹林區"
        }
    }
}
