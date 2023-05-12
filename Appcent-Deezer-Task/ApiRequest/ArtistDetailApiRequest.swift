//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation

struct ArtistDetailApiRequest {
    
    static func fetchArtistDetails(artistId: Int, completion: @escaping (Result<ArtistDetail, Error>) -> Void) {
        let url = URL(string: "https://api.deezer.com/artist/\(artistId)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                let artistDetail = try JSONDecoder().decode(ArtistDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(artistDetail))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func fetchAlbumsOfArtist(artistId: Int, completion: @escaping (Result<[AlbumsOfSelectedArtist], Error>) -> Void) {
        let url = URL(string: "https://api.deezer.com/artist/\(artistId)/albums")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            do {
                let albumsResponse = try JSONDecoder().decode(AlbumsOfSelectedArtistResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(albumsResponse.data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

