//
//  CharacterDetailView.swift
//  RickAndMortyExplorer
//
//  Created by Алексей on 17.03.2025.
//


import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let character: Character
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                KFImage(URL(string: character.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(character.name)
                    .foregroundStyle(.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(character.statusWithEmoji)
                    .font(.title2)
                    .foregroundStyle(.gray)
                
                Text("\(character.species) | \(character.gender)")
                    .font(.title3)
                    .foregroundStyle(.gray)
                
                VStack(alignment: .center, spacing: 8) {
                    Text("Location:")
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    Text(character.location.name)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            
        }
    }
}

#Preview {
    CharacterDetailView(character: Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: OriginModel(name: "", url: ""), location: LocationModel(name: "", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episode: [""], url: "", created: ""))
}
