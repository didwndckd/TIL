//
//  Model.swift
//  AlamofirePractice
//
//  Created by 양중창 on 2020/02/21.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import Foundation

//let jsonData =
//"""
//{
//  "name": "Alina",
//  "surname": "Grecescu",
//  "gender": "female",
//  "region": "Romania",
//  "age": 34,
//  "title": "ms",
//  "phone": "(748) 937 8858",
//  "birthday": {
//    "dmy": "07/09/1986",
//    "mdy": "09/07/1986",
//    "raw": 526451656
//  },
//  "email": "alina_86@example.com",
//  "password": "Grecescu86&^",
//  "credit_card": {
//    "expiration": "3/25",
//    "number": "5745-8712-3746-6978",
//    "pin": 4405,
//    "security": 183
//  },
//  "photo": "https://uinames.com/api/photos/female/16.jpg"
//}
//""".data(using: .utf8)!

struct CraditCard: Decodable {
    let expiration: String
    let number: String
    let pin: Int
    let security: Int
}

struct User: Decodable {
    let fullName: String
    let phone: String
    let birthDay: Date
    let email: String
    let craditCard: CraditCard
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case name, surname, phone, birthday, email, photo
        case craditCard = "credit_card"
    }
    
    enum BirthDayKey: String, CodingKey {
        case raw
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let surname = try container.decode(String.self, forKey: .surname)
        self.fullName = name + " " + surname
        
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        self.craditCard = try container.decode(CraditCard.self, forKey: .craditCard)
        self.photo = try container.decode(String.self, forKey: .photo)
        
        let nested = try container.nestedContainer(keyedBy: BirthDayKey.self, forKey: .birthday)
        let timeLag = try nested.decode(Double.self, forKey: .raw)
        
        self.birthDay = Date(timeIntervalSince1970: timeLag)
        
    }
}


