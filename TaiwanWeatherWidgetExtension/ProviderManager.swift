//
//  ProviderManager.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/24.
//

import Foundation
import WidgetKit

class ProviderManager {
    
    // Public Variable
    var t: String = ""
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
    private var selectedElementNames: [String] = ["體感溫度", "溫度", "降雨機率"]
    private var weatherInfo: WeatherInfoModel? = nil
    private var updateTimeSpace: Int = 10 // (30 * 60)
    
    // Init Function
    init() {
        getUserSelectedLocation()
    }
    
    // Public Function
    /// 獲取使用者選擇位置
    func getUserSelectedLocation(selectedLocation: String = "") {
        if selectedLocation == "" {
            guard let userInfo = CoreDataManager.shared.fetchUserInfo() else { return }
            selectedCity = userInfo.selectedCity!
            selectedTown = userInfo.selectedTown!
        } else {
            let select = selectedLocation.components(separatedBy: " ")
            let cityName = select[0]
            let townName = select[1]
            selectedCity = cityName
            selectedTown = townName
        }
    }
    
    /// 獲取天氣資訊
    func fetchWeatherInfo() async {
        guard selectedCity != "-" && selectedTown != "-" else { return }
        isError = false
        removeAllWeatherInfo()
        if SharedInfoManager.shared.exclusiveAuthorizationCode == "" {
            // 若使用公用授權碼將受限於請求次數，優先使用本地資料
            let loadResult = await loadWeatherInfoFromCoreData()
            if loadResult {
//                print("✅ Load weather info from core data.")
                await MainActor.run {
                    SharedInfoManager.shared.isProcessing.toggle()
                }
                return
            } else {
//                print("❌ Reget weather info from web")
                removeAllWeatherInfo()
            }
        }
        let transCityName = CityCodeModel.cityCode[selectedCity]!
        let transElementName = selectedElementNames.map { elementName in
            ElementNameCodeModel.elementNameCode[elementName]!
        }
        let queryWeatherResult = await WeatherApiManager.shared.queryCityDistrict(cityCode: transCityName, districtName: selectedTown, elementName: transElementName)
        switch queryWeatherResult {
        case .success(let resultData):
            guard let returnedWeatherInfo = try? JSONDecoder().decode(WeatherInfoModel.self, from: resultData) else {
                isError = true
                return
            }
            weatherInfo = returnedWeatherInfo
        case .failure(_):
            isError = true
            return
        }
        
        guard let weatherInfo = weatherInfo else { return }
        guard weatherInfo.success == "true" else {
            isError = true
            return
        }
        
        // 將資料保存到本地設備當中
        await MainActor.run {
            saveWeatherInfoIntoCoreData()
        }
        // 調用從CoreData中獲取天氣資料
        guard await loadWeatherInfoFromCoreData() else {
            isError = true
            return
        }
        
        await MainActor.run {
            SharedInfoManager.shared.isProcessing.toggle()
        }
    }
    
    // Private Function
    /// 從CoreData中獲取天氣資訊
    private func loadWeatherInfoFromCoreData() async -> Bool {
        let townEntity = CoreDataManager.shared.fetchTownEntity(cityName: selectedCity, townName: selectedTown)
        guard let townEntity = townEntity else {
            return false
        }
        let timeGap = abs(Int(townEntity.updateTime!.timeIntervalSinceNow))
        if timeGap > updateTimeSpace { return false }
        for elementName in selectedElementNames {
            switch elementName {
            case "體感溫度":
                guard let atEntities = townEntity.at?.allObjects as? [ATEntity],
                      atEntities.count > 0 else { return false }
                for atEntity in atEntities {
                    let time = atEntity.time!
                    let value = Int(atEntity.temperature)
                    await MainActor.run { bodyTemperature.append((value, time)) }
                }
            case "溫度":
                guard let tEntities = townEntity.t?.allObjects as? [TEntity],
                      tEntities.count > 0 else { return false }
                for tEntity in tEntities {
                    let time = tEntity.time!
                    let value = Int(tEntity.temperature)
                    await MainActor.run { temperature.append((value, time)) }
                }
            case "降雨機率":
                guard let popEntities = townEntity.pop?.allObjects as? [PoPEntity],
                      popEntities.count > 0 else { return false }
                for popEntity in popEntities {
                    let time = popEntity.startTime!
                    let value = Int(popEntity.probability)
                    await MainActor.run { rainRate.append((value, time)) }
                }
            default:
                print("❌發現其他Element: \(elementName)")
            }
        }
        // 更新時間軸
        await MainActor.run {
            let atTimeLine = bodyTemperature.map { $0.1 }
            let tTimeLine = temperature.map { $0.1 }
            let popTimeLine = rainRate.map { $0.1 }
            timeLine = atTimeLine
            if tTimeLine.count > timeLine.count { timeLine = tTimeLine }
            if popTimeLine.count > timeLine.count { timeLine = popTimeLine }
            timeLine.sort()
            bodyTemperature.sort { $0.1 < $1.1 }
            temperature.sort { $0.1 < $1.1 }
            rainRate.sort { $0.1 < $1.1 }
        }
        return true
    }
    
    @MainActor
    private func saveWeatherInfoIntoCoreData() {
        guard let weatherInfo = weatherInfo,
              let weatherElementsInfo = weatherInfo.records.locations.first?.location.first?.weatherElement else {
            return
        }
        var cityEntity = CoreDataManager.shared.fetchCityEntity(cityName: selectedCity)
        if cityEntity == nil {
            let newCityEntity = CityEntity(context: CoreDataManager.shared.container.viewContext)
            newCityEntity.name = selectedCity
            CoreDataManager.shared.saveCoreData()
            cityEntity = CoreDataManager.shared.fetchCityEntity(cityName: selectedCity)
        }
        let oldTownEntity = CoreDataManager.shared.fetchTownEntity(cityName: selectedCity, townName: selectedTown)
        if oldTownEntity != nil {
            cityEntity?.removeFromTown(oldTownEntity!)
            CoreDataManager.shared.deleteEntity(entities: [oldTownEntity!])
        }
        let townEntity = TownEntity(context: CoreDataManager.shared.container.viewContext)
        townEntity.name = selectedTown
        townEntity.updateTime = Date()
        CoreDataManager.shared.saveCoreData()
        guard let cityEntity = cityEntity else { return }
        cityEntity.addToTown(townEntity)
        CoreDataManager.shared.saveCoreData()
        for weatherElementInfo in weatherElementsInfo {
            let elementName = weatherElementInfo.elementName
            let infos = weatherElementInfo.time
            switch elementName {
            case "AT":
                for info in infos {
                    let atEntity = ATEntity(context: CoreDataManager.shared.container.viewContext)
                    atEntity.time = Date.formateToDate(from: info.dataTime!)
                    atEntity.temperature = Int32(info.elementValue.first!.value)!
                    atEntity.updateTime = Date()
                    townEntity.addToAt(atEntity)
                }
            case "T":
                for info in infos {
                    let tEntity = TEntity(context: CoreDataManager.shared.container.viewContext)
                    tEntity.time = Date.formateToDate(from: info.dataTime!)
                    tEntity.temperature = Int32(info.elementValue.first!.value)!
                    tEntity.updateTime = Date()
                    townEntity.addToT(tEntity)
                }
            case "PoP6h":
                for info in infos {
                    let popEntity = PoPEntity(context: CoreDataManager.shared.container.viewContext)
                    popEntity.startTime = Date.formateToDate(from: info.startTime!)
                    popEntity.endTime = Date.formateToDate(from: info.endTime!)
                    popEntity.probability = Int32(info.elementValue.first!.value)!
                    popEntity.updateTime = Date()
                    townEntity.addToPop(popEntity)
                }
            default:
                break
            }
        }
        CoreDataManager.shared.saveCoreData()
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
