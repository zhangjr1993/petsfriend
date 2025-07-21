//
//  PetsModel.swift
//  Runner
//
//  Created by Bolo on 2025/7/4.
//

import SmartCodable

struct PetsCodable: SmartCodable {
    var id = 0
    var userName = ""
    var userPic = ""
    var petSex = ""
    var petCategory = ""
    var petAge = ""
    var petName = ""
    var petPic = ""
    var gallery: [String] = []
    var desc = ""
}
