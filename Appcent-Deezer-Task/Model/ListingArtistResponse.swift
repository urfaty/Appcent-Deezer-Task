//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import Foundation

struct Artist: Codable {
    let id: Int
    let name: String
    let picture_medium: String
}

struct ArtistsResponse: Codable {
    let data: [Artist]
}
