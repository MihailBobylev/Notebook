//
//  SaveUserModel.swift
//  Notebook
//
//  Created by Mikhail on 27.06.2022.
//

import Foundation

struct SaveUserModel {
    var image: Data
    var name: String
    var dob: Date
    var email: String
    var gender: String
    var time: String
    var age: Int
    
    init(image: Data, dob: Date, email: String, gender: String, time: String, age: Int, name: String) {
        self.image = image
        self.dob = dob
        self.email = email
        self.gender = gender
        self.time = time
        self.age = age
        self.name = name
    }
}
