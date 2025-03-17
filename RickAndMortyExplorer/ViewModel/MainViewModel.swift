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
    
    init(characters: [Character]) {
        self.characters = characters
    }
}
