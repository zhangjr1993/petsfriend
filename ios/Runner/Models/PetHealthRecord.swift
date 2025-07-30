import Foundation

// MARK: - 宠物健康档案
struct PetHealthRecord: Codable {
    let id: String
    let petName: String
    let petType: String
    let birthDate: String
    let age: String?
    let weight: Double?
    let vaccinations: [String]
    let allergies: [String]
    let notes: String
    let createDate: Date
    let updateDate: Date
    
    init(id: String = UUID().uuidString,
         petName: String,
         petType: String,
         birthDate: String,
         age: String? = nil,
         weight: Double? = nil,
         vaccinations: [String] = [],
         allergies: [String] = [],
         notes: String = "",
         createDate: Date = Date(),
         updateDate: Date = Date()) {
        self.id = id
        self.petName = petName
        self.petType = petType
        self.birthDate = birthDate
        self.age = age
        self.weight = weight
        self.vaccinations = vaccinations
        self.allergies = allergies
        self.notes = notes
        self.createDate = createDate
        self.updateDate = updateDate
    }
} 
