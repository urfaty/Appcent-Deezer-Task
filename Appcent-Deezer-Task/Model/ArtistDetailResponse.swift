//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

struct ArtistDetail: Codable {
    let id: Int
    let name: String
    let link: String
    let share: String
    let picture: String
    let picture_small: String
    let picture_medium: String
    let picture_big: String
    let picture_xl: String
    let nb_album: Int
    let nb_fan: Int
    let radio: Bool
    let tracklist: String
    let type: String
}

struct ArtistDetailResponse: Codable {
    let data: [ArtistDetail]
}

