//
//  CoreDataManager.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton
    static let shared = CoreDataManager()
    
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
    func fetchTownEntity(cityName: String) -> TownEntity? {
        let townFetchRequest = NSFetchRequest<TownEntity>(entityName: "TownEntity")
        let filter: NSPredicate = NSPredicate(format: "name == %@", cityName)
        townFetchRequest.predicate = filter
        guard let townInfoSearchResult = try? container.viewContext.fetch(townFetchRequest) else {
            return nil
        }
        return townInfoSearchResult.first
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
