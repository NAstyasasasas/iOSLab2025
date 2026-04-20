//
//  User.swift
//  MyProject
//
//  Created by Анастасия
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let username: String
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, username
        case avatarURL = "avatar_url"
    }
}
