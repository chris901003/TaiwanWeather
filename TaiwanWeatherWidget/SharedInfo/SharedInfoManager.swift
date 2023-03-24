//
//  ShareInfoManager.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/22.
//

import Foundation

class SharedInfoManager: ObservableObject {
    
    // Singleton
    static let shared: SharedInfoManager = SharedInfoManager()
    
    // Init Function
    private init() { }
    
    // Published Variable
    
    /// Processing Variable
    @Published var isProcessing: Bool = false
    @Published var isProcessError: Bool = false
    @Published var processErrorMessage: String = ""
    
    /// AuthorizationCode
    @Published var exclusiveAuthorizationCode: String = ""
}
