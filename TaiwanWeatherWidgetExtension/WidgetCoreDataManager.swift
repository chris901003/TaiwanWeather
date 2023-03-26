//
//  CoreDataManager.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import Foundation
import CoreData

class WidgetCoreDataManager {
    
    // Singleton
    static let shared = WidgetCoreDataManager()
    
    private var shareStoreUrl: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hungyen.TaiwanWeatherWidget")!
        return container.appending(path: "TaiwanWeatherWidget.sqlite")
    }
    
    let container: NSPersistentContainer
    
    // Init Function
    private init() {
        container = NSPersistentContainer(name: "TaiwanWeatherWidget")
        container.persistentStoreDescriptions.first?.url = shareStoreUrl
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("❌ Core Data Load Error: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Public Function
    /// 獲取使用者資料
    func fetchUserInfo() -> UserInfoEntity? {
        var userInfoFetchRequest: NSFetchRequest<UserInfoEntity> {
            let request = UserInfoEntity.fetchRequest()
            return request
        }
        guard let fetchResult = try? container.viewContext.fetch(userInfoFetchRequest) else {
            return nil
        }
        return fetchResult.first
    }
    
    /// 獲取城市資料
    func fetchCityEntity(cityName: String) -> CityEntity? {
        let cityFetchRequest = NSFetchRequest<CityEntity>(entityName: "CityEntity")
        let filter = NSPredicate(format: "name == %@", cityName)
        cityFetchRequest.predicate = filter
        let cityEntitySearchResult = try? container.viewContext.fetch(cityFetchRequest)
        return cityEntitySearchResult?.first
    }
    
    /// 獲取鄉鎮資料
    func fetchTownEntity(townName: String) -> [TownEntity]? {
        let townFetchRequest = NSFetchRequest<TownEntity>(entityName: "TownEntity")
        let filter = NSPredicate(format: "name == %@", townName)
        townFetchRequest.predicate = filter
        let townEntitiesSearchResult = try? container.viewContext.fetch(townFetchRequest)
        return townEntitiesSearchResult
    }
    
    /// 提供城市名稱下獲取鄉鎮資料
    func fetchTownEntity(cityName: String, townName: String) -> TownEntity? {
        let townFetchRequest = NSFetchRequest<TownEntity>(entityName: "TownEntity")
        let filter = NSPredicate(format: "name == %@ && city.name == %@", townName, cityName)
        townFetchRequest.predicate = filter
        let townEntitySearchResult = try? container.viewContext.fetch(townFetchRequest)
        return townEntitySearchResult?.first
    }
    
    /// 保存資料
    func saveCoreData() {
        do {
            try container.viewContext.save()
        } catch {
            print("❌ Core data save error: \(error.localizedDescription)")
        }
    }
    
    /// 刪除Entity
    func deleteEntity(entities: [NSManagedObject]) {
        for entity in entities {
            container.viewContext.delete(entity)
        }
        saveCoreData()
    }
}

extension WidgetCoreDataManager {
    /// 獲取所有城市
    func fetchCityEntity() -> [CityEntity]? {
        let cityFetchRequest = NSFetchRequest<CityEntity>(entityName: "CityEntity")
        let cityEntitiesSearchResult = try? container.viewContext.fetch(cityFetchRequest)
        return cityEntitiesSearchResult
    }
    
    /// 獲取所有鄉鎮資料
    func fetchTownEntity() -> [TownEntity]? {
        let townFetchRequest = NSFetchRequest<TownEntity>(entityName: "TownEntity")
        let townEntitiesSearchResult = try? container.viewContext.fetch(townFetchRequest)
        return townEntitiesSearchResult
    }
    
    /// 獲取所有溫度
    func fetchTEntity() -> [TEntity]? {
        let tFetchRequest = NSFetchRequest<TEntity>(entityName: "TEntity")
        let tEntitiesSearchResult = try? container.viewContext.fetch(tFetchRequest)
        return tEntitiesSearchResult
    }
    
    /// 獲取所有體感溫度
    func fetchATEntity() -> [ATEntity]? {
        let atFetchRequest = NSFetchRequest<ATEntity>(entityName: "ATEntity")
        let atEntitiesSearchResult = try? container.viewContext.fetch(atFetchRequest)
        return atEntitiesSearchResult
    }
    
    /// 獲取所有降雨機率
    func fetchPoPEntity() -> [PoPEntity]? {
        let popFetchRequest = NSFetchRequest<PoPEntity>(entityName: "PoPEntity")
        let popEntitiesSearchResult = try? container.viewContext.fetch(popFetchRequest)
        return popEntitiesSearchResult
    }
}
