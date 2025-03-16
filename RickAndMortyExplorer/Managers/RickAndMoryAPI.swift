//
//  RickAndMoryAPI.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 16.03.2025.
//

import Foundation
import Combine

class RickAndMoryAPI {
    private let base = "https://rickandmortyapi.com/api"
    
    func fetchFirstCharacter() -> AnyPublisher<Character, Error> {
        guard let url = URL(string: "\(base)/character/1") else {
            return Fail(error: NSError(domain: "Invalid URL", code: 400, userInfo: nil))
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: "Invalid HTTP response", code: 500, userInfo: nil)
                }
                return output.data
            }
            .decode(type: Character.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
