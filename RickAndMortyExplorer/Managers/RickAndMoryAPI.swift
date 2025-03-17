import Foundation
import Combine

enum RickAndMortyAPIError: LocalizedError {
    case invalidURL
    case invalidHTTPResponse(statusCode: Int)
    case decodingError
    case networkError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Failed to construct a valid URL."
        case .invalidHTTPResponse(let statusCode):
            return "Invalid HTTP response with status code \(statusCode)."
        case .decodingError:
            return "Decoding error occurred."
        case .networkError(let underlyingError):
            return "Network error: \(underlyingError.localizedDescription)"
        case .unknownError:
            return "An unexpected error occurred."
        }
    }
}

class RickAndMoryAPI {
    private let baseURL = "https://rickandmortyapi.com/api"
    private let firstCharacterPath = "/character/1"
    private let charactersPath = "/character"
    
    func fetchFirstCharacter() -> AnyPublisher<Character, RickAndMortyAPIError> {
        guard let url = URL(string: "\(baseURL)\(firstCharacterPath)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        return fetchData(from: url)
            .decode(type: Character.self, decoder: JSONDecoder())
            .mapError { self.mapDecodingError($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchAllCharacters() -> AnyPublisher<[Character], RickAndMortyAPIError> {
        guard let url = URL(string: "\(baseURL)\(charactersPath)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        return fetchCharactersRecursively(url: url)
    }
    
    private func fetchCharactersRecursively(url: URL) -> AnyPublisher<[Character], RickAndMortyAPIError> {
        fetchData(from: url)
            .decode(type: CharacterResponse.self, decoder: JSONDecoder())
            .mapError { self.mapDecodingError($0) }
            .flatMap { response -> AnyPublisher<[Character], RickAndMortyAPIError> in
                if let nextURL = response.info.next.flatMap(URL.init) {
                    return self.fetchCharactersRecursively(url: nextURL)
                        .map { response.results + $0 }
                        .eraseToAnyPublisher()
                } else {
                    return Just(response.results)
                        .setFailureType(to: RickAndMortyAPIError.self)
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


private extension RickAndMoryAPI {
    func fetchData(from url: URL) -> AnyPublisher<Data, RickAndMortyAPIError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw RickAndMortyAPIError.invalidHTTPResponse(statusCode: 0)
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw RickAndMortyAPIError.invalidHTTPResponse(statusCode: httpResponse.statusCode)
                }
                return output.data
            }
            .mapError { self.mapNetworkError($0) }
            .eraseToAnyPublisher()
    }
    
    func mapNetworkError(_ error: Error) -> RickAndMortyAPIError {
        if let urlError = error as? URLError {
            return .networkError(urlError)
        }
        return .unknownError
    }
    
    func mapDecodingError(_ error: Error) -> RickAndMortyAPIError {
        error is DecodingError ? .decodingError : .unknownError
    }
}
