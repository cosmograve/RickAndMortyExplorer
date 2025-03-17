//
//  StartViewModel.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 16.03.2025.
//

import Foundation
import Combine

class StartViewModel: ObservableObject {
    @Published var characterImage: String?
    @Published var errorMsg: String?
    @Published var characters: [Character] = []
    @Published var mainViewModel: MainViewModel?
    
    private var cancellables: Set<AnyCancellable> = []
    private let api = RickAndMoryAPI()
    
    func checkFirstCharacter() {
        errorMsg = nil
        api.fetchFirstCharacter()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMsg = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] character in
                    print("\(character.name)")
                    self?.characterImage = character.image
                    self?.loadAllCharacters()
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadAllCharacters() {
        api.fetchAllCharacters()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMsg = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] characters in
                    self?.characters = characters
                    self?.mainViewModel = MainViewModel(characters: characters)
                    
                }
            )
            .store(in: &cancellables)
    }
}
