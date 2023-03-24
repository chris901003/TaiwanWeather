//
//  WeatherApiManager.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import Foundation

class WeatherApiManager {
    
    // Singleton
    static let shared: WeatherApiManager = WeatherApiManager()
    
    // Pirvate Variable
    private var sharedAuthorizationCode: String = "CWB-2CECC8D4-D1DB-44BB-AF36-E38A4241DB96"
    private var authorizationCode: String {
        SharedInfoManager.shared.exclusiveAuthorizationCode == "" ? sharedAuthorizationCode : SharedInfoManager.shared.exclusiveAuthorizationCode
    }
    
    // Init Function
    private init() { }
    
    // Public Function
    /// 檢查授權碼是否合法
    func checkApiAuthorizationCodeIsValid() async -> Bool {
        let queryResult = await queryCityDistrict(cityCode: "F-D0047-069", districtName: "樹林區", elementName: ["AT"])
        switch queryResult {
        case .success(_):
            break
        case .failure(_):
            return false
        }
        return true
    }
    
    // Private Function
    func queryCityDistrict(cityCode: String, districtName: String, elementName: [String]) async -> Result<Data, QueryError> {
        var elementNameString: String = elementName.reduce(into: "") { partialResult, filterName in
            partialResult += ",\(filterName)"
        }
        elementNameString = String(elementNameString.dropFirst(1))
        let urlString = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/\(cityCode)?Authorization=\(authorizationCode)&locationName=\(districtName)&elementName=\(elementNameString)"
        guard let urlPath = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlPath) else {
            return .failure(.urlError)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            return .failure(.httpQueryError)
        }
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return .failure(.httpStatusCodeError)
        }
        return .success(data)
    }
}

extension WeatherApiManager {
    
    enum QueryError: String, LocalizedError {
        case urlError = "URL格式錯誤"
        case httpQueryError = "請求發生錯誤，請稍後再試"
        case httpStatusCodeError = "狀態碼錯誤，請確認網路狀態"
    }
}
