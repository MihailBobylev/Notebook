//
//  UserModel.swift
//  Notebook
//
//  Created by Mikhail on 24.06.2022.
//

import Foundation

struct UserModel: Codable {
    let results: [Users]
}

struct Users: Codable {
    let dob: Dob
    let email: String
    let gender: String
    let location: Location
    let name: Name
    let picture: Picture
}

struct Dob: Codable {
    let age: Int
    let date: String
}

struct Name: Codable {
    let first: String
    let last: String
    let title: String
}

struct Picture: Codable {
    let large: String
}

struct Location: Codable {
    let timezone: Timezone
}

struct Timezone: Codable {
    let description: String
    let offset: String
}

