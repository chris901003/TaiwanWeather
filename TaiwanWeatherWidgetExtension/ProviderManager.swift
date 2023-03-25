//
//  ProviderManager.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/24.
//

import Foundation

class ProviderManager {
    
    // Public Variable
    var selectedCity: String = ""
    var selectedTown: String = ""
    var temperature: [(Int, Date)] = []
    var rainRate: [(Int, Date)] = []
    var bodyTemperature: [(Int, Date)] = []
    var timeLine: [Date] = []
    var isValidSelected: Bool {
        selectedCity != "-" && selectedTown != "-"
    }
    var isError: Bool = false
    
    // Private Variable
    private var userInfoEntity: UserInfoEntity
    private var selectedElementNames: [String] = ["體感溫度", "溫度", "降雨機率"]
    private var weatherInfo: WeatherInfoModel? = nil
    private var updateTimeSpace: Int = 10 // (30 * 60)
    
    // Init Function
    init() {
        if let userInfoEntity = CoreDataManager.shared.fetchUserInfo() {
            self.userInfoEntity = userInfoEntity
        } else {
            let newUserInfoEntity = UserInfoEntity(context: CoreDataManager.shared.container.viewContext)
            newUserInfoEntity.selectedCity = "-"
            newUserInfoEntity.selectedTown = "-"
            newUserInfoEntity.authorizationCode = ""
            newUserInfoEntity.queryCount = 0
            newUserInfoEntity.queryCountUpdateTime = Date()
            CoreDataManager.shared.saveCoreData()
            self.userInfoEntity = newUserInfoEntity
        }
        selectedCity = self.userInfoEntity.selectedCity!
        selectedTown = self.userInfoEntity.selectedTown!
    }
    
    // Public Function
    func fetchWeatherInfo() async {
        
    }
    
    // Private Function
    /// 從CoreData中獲取天氣資訊
    private func loadWeatherInfoFromCoreData() async -> Bool {
        return true
    }
    
    private func saveWeatherInfoIntoCoreData() async {
        
    }
    
    /// 移除所有天氣相關資訊
    private func removeAllWeatherInfo() {
        temperature.removeAll()
        rainRate.removeAll()
        bodyTemperature.removeAll()
        timeLine.removeAll()
    }
}

extension ProviderManager {
    
    static func getInfo() async -> String {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return "今天天氣真好<可以去看星星<是真的喔"
    }
}
