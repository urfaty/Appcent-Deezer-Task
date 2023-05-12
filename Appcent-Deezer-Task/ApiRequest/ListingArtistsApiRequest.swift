//
//  ListingArtistsApiRequest.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import Foundation

struct ArtistsApiRequest {
    
    static let baseURL = "https://api.deezer.com"
    
    static func fetchArtists(forGenreId genreId: Int, completion: @escaping (Result<[Artist], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/genre/\(genreId)/artists") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let artistsResponse = try decoder.decode(ArtistsResponse.self, from: data)
                completion(.success(artistsResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
