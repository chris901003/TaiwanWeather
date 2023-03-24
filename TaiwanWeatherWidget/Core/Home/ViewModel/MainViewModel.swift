//
//  MainViewModel.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    // Published Variable
    @Published var authorizationCode: String = ""
    @Published var isShowSuccessSaveAuthorizationCode: Bool = false
    
    @Published var selectedCity: String = "新北市"
    @Published var selectedTown: String = "樹林區"
    @Published var selectedElementNameShow: String = "-"
    @Published var selectedElementNames: [String] = ["體感溫度", "溫度", "降雨機率"]
    @Published var selectedElementNamesTmp: [String] = []
    @Published var isValidSelect: Bool = false
    @Published var isLoadingWeatherInfo: Bool = false
    
    @Published var temperature: [(Int, Date)] = []
    @Published var rainRate: [(Int, Date)] = []
    @Published var bodyTemperature: [(Int, Date)] = []
    @Published var timeLine: [Date] = []
    
    // Public Variable
    var weatherInfo: WeatherInfoModel? = nil
    
    // Private Variable
    private var userInfoEntity: UserInfoEntity
    private var selectedAnyCancellable: AnyCancellable? = nil
    private var maximumWeatherQueryTime: Int = 100
    private var updateTimeSpace: Int = 10 // (30 * 60)
    
    // Init Function
    init() {
        if let userInfoEntity = CoreDataManager.shared.fetchUserInfo() {
            self.userInfoEntity = userInfoEntity
            let lastQueryCountUpdateTime = userInfoEntity.queryCountUpdateTime ?? Date()
            let updateDay = Calendar.current.component(.day, from: lastQueryCountUpdateTime)
            let nowDay = Calendar.current.component(.day, from: Date())
            if(updateDay != nowDay) {
                userInfoEntity.queryCount = 0
                userInfoEntity.queryCountUpdateTime = Date()
                CoreDataManager.shared.saveCoreData()
            }
        } else {
            let newUserInfoEntity = UserInfoEntity(context: CoreDataManager.shared.container.viewContext)
            newUserInfoEntity.queryCountUpdateTime = Date()
            newUserInfoEntity.queryCount = 0
            newUserInfoEntity.authorizationCode = ""
            CoreDataManager.shared.saveCoreData()
            self.userInfoEntity = newUserInfoEntity
        }
        if let code = self.userInfoEntity.authorizationCode {
            authorizationCode = code
            SharedInfoManager.shared.exclusiveAuthorizationCode = code
        }
        subscribeSelected()
    }
    
    // Public Function
    /// 更新API碼
    func saveAuthorizationCode() async {
        await MainActor.run {
            SharedInfoManager.shared.isProcessing.toggle()
            SharedInfoManager.shared.exclusiveAuthorizationCode = authorizationCode
        }
        let checkAuthCodeResult = await WeatherApiManager.shared.checkApiAuthorizationCodeIsValid()
        if !checkAuthCodeResult {
            await processErrorHandler(errorStatus: UpdateAuthorizationCodeError.invalidAuthorizationCode)
            await MainActor.run {
                SharedInfoManager.shared.exclusiveAuthorizationCode = ""
            }
            return
        } else {
            await MainActor.run {
                SharedInfoManager.shared.exclusiveAuthorizationCode = authorizationCode
            }
        }
        userInfoEntity.authorizationCode = authorizationCode
        CoreDataManager.shared.saveCoreData()
        await MainActor.run {
            isShowSuccessSaveAuthorizationCode.toggle()
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            SharedInfoManager.shared.isProcessing.toggle()
            isShowSuccessSaveAuthorizationCode.toggle()
        }
    }
    
    /// 更新暫時選擇的天氣資訊
    func updateSelectedElementNameTmp(selectElementName: String) {
        if let idx = selectedElementNamesTmp.firstIndex(where: { $0 ==  selectElementName }) {
            selectedElementNamesTmp.remove(at: idx)
        } else {
            selectedElementNamesTmp.append(selectElementName)
        }
    }
    
    /// 將暫時選的資料更新到正式使用中
    func updateSelectedElementName() {
        selectedElementNames = selectedElementNamesTmp
        if selectedElementNames.count == 0 {
            selectedElementNameShow = "-"
            return
        }
        selectedElementNameShow = ""
        for idx in selectedElementNames.indices {
            selectedElementNameShow += selectedElementNames[idx]
            if idx != selectedElementNames.count - 1 {
                selectedElementNameShow += ", "
            }
        }
    }
    
    // Private Function
    /// 處理過程發生錯誤
    private func processErrorHandler(errorStatus: any RawRepresentable<String>, customErrorMessage: String = "") async {
        await MainActor.run {
            SharedInfoManager.shared.processErrorMessage = errorStatus.rawValue
            SharedInfoManager.shared.isProcessError.toggle()
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            SharedInfoManager.shared.isProcessError.toggle()
            SharedInfoManager.shared.processErrorMessage = ""
            SharedInfoManager.shared.isProcessing.toggle()
        }
    }
    
    /// 更新天氣資訊到指定地點
    private func searchSelectedPlaceWeather() async {
        await MainActor.run {
            SharedInfoManager.shared.isProcessing.toggle()
        }
        if SharedInfoManager.shared.exclusiveAuthorizationCode == "" {
            // 若使用公用授權碼將受限於請求次數，優先使用本地資料
            let loadResult = await loadWeatherInfoFromCoreData()
            if loadResult {
                await MainActor.run {
                    SharedInfoManager.shared.isProcessing.toggle()
                }
                return
            } else {
                await MainActor.run {
                    temperature.removeAll()
                    bodyTemperature.removeAll()
                    rainRate.removeAll()
                    timeLine.removeAll()
                }
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
                await processErrorHandler(errorStatus: SearchWeatherInfoError.dataTransferError)
                return
            }
            weatherInfo = returnedWeatherInfo
        case .failure(let errorStatus):
            await processErrorHandler(errorStatus: SearchWeatherInfoError.internetQueryError, customErrorMessage: errorStatus.localizedDescription)
            return
        }
        
        guard let weatherInfo = weatherInfo else { return }
        guard weatherInfo.success == "true" else {
            await processErrorHandler(errorStatus: SearchWeatherInfoError.internetQueryError)
            return
        }
        
        // 將資料保存到本地設備當中
        await saveWeatherInfoIntoCoreData(cityName: selectedCity, townName: selectedTown, elementNames: selectedElementNames)
        // 調用從CoreData中獲取天氣資料
        guard await loadWeatherInfoFromCoreData() else {
            await processErrorHandler(errorStatus: SearchWeatherInfoError.loadWeatherInfoFromCoreDataError)
            return
        }
        
        if SharedInfoManager.shared.exclusiveAuthorizationCode == "" {
            userInfoEntity.queryCount += 1
        }
        await MainActor.run {
            SharedInfoManager.shared.isProcessing.toggle()
        }
    }
    
    /// 從CoreData獲取氣象資料
    private func loadWeatherInfoFromCoreData() async -> Bool {
        let townEntity = CoreDataManager.shared.fetchTownEntity(cityName: selectedCity)
        guard let townEntity = townEntity else { return false }
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
        }
        return true
    }
    
    /// 將資料保存到本地設備當中
    private func saveWeatherInfoIntoCoreData(cityName: String, townName: String, elementNames: [String]) async {
        guard let weatherInfo = weatherInfo,
              let weatherElementsInfo = weatherInfo.records.locations.first?.location.first?.weatherElement else { return }
        var townEntity = CoreDataManager.shared.fetchTownEntity(cityName: cityName)
        if townEntity != nil {
            CoreDataManager.shared.deleteEntity(entities: [townEntity!])
        }
        townEntity = TownEntity(context: CoreDataManager.shared.container.viewContext)
        guard let townEntity = townEntity else { return }
        townEntity.name = cityName
        townEntity.updateTime = Date()
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
    
    // Subscribe Private Function
    /// 追蹤選擇的地點
    private func subscribeSelected() {
        selectedAnyCancellable = $selectedCity
            .combineLatest($selectedTown, $selectedElementNames)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedSelectedCity, returnedSelectedTown, returnedSelectedElementNames in
                guard let self = self else { return }
                if returnedSelectedCity == "-" || returnedSelectedTown == "-" || returnedSelectedElementNames.count == 0 {
                    self.isValidSelect = false
                } else {
                    self.isValidSelect = true
                    Task {
                        await MainActor.run { self.isLoadingWeatherInfo.toggle() }
                        await self.searchSelectedPlaceWeather()
                        await MainActor.run { self.isLoadingWeatherInfo.toggle() }
                    }
                }
            }
    }
}

extension MainViewModel {
    
    enum UpdateAuthorizationCodeError: String, LocalizedError {
        case invalidAuthorizationCode = "不合法的授權碼"
    }
    
    enum SearchWeatherInfoError: String, LocalizedError {
        case internetQueryError = "請求資料時發生錯誤"
        case dataTransferError = "資料錯誤，請聯絡開發者"
        case loadWeatherInfoFromCoreDataError = "資料讀取錯誤，請聯絡開發者"
    }
}