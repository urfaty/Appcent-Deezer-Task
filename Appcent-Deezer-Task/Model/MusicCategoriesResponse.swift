//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import Foundation

struct MusicCategoriesResponse: Codable {
    let data: [MusicCategory]
}

struct MusicCategory: Codable {
    let id: Int
    let name: String
    let picture: String
    let picture_medium: String
}
