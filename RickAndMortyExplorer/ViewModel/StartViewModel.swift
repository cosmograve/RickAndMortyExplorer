//
//  StartViewModel.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 16.03.2025.
//

import Foundation
import Combine

class StartViewModel {
    @Published var isLoading: Bool = false
    @Published var characterImage: String?
    @Published var errorMsg: String?
    
    private var cancellables: Set<AnyCancellable> = []
    private let api = RickAndMoryAPI()
    
    func checkFirstCharacter() {
        isLoading.toggle()
        errorMsg = nil
        
        api.fetchFirstCharacter()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("ok")
                    case .failure(let error):
                        print("err: \(error.localizedDescription)")
                    }
                },
                receiveValue: { character in
                    print("loaded: \(character.name)")
                    self.characterImage = character.image
                }
            )
            .store(in: &cancellables)
    }
}
