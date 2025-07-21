//
//  AppRunManager.swift
//  Runner
//
//  Created by Bolo on 2025/7/4.
//

import Foundation

class AppRunManager: NSObject {
    static let shared = AppRunManager()
    
    var petsList: [PetsCodable] = []
    
    func initData() {
        guard let url = Bundle.main.url(forResource: "Recommend", withExtension: "geojson"),
              let data = try? Data(contentsOf: url),
              let jsonDic = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return
        }
        
        petsList = [PetsCodable].deserialize(from: jsonDic) ?? []
    }
}
