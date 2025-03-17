//
//  MainViewModel.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 17.03.2025.
//

import Foundation
import Combine

class MainViewModel {
    @Published var characters: [Character] = []
    @Published var filteredCharacters: [Character] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(characters: [Character]) {
        self.characters = characters
        self.filteredCharacters = characters
        
        $searchText
            .receive(on: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterCharacters(by: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterCharacters(by searchText: String) {
        if searchText.isEmpty {
            filteredCharacters = characters
        } else {
            filteredCharacters = characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
