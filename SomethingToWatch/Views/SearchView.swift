//
//  SearchView.swift
//  SomethingToWatch
//
//  Created by Bartosz Klimek on 05/02/2022.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State private var filmData: FilmsData!
    @State private var films: [Films] = []
    @State var genre: String
    
    var searchFilms: [Films] {
        if searchText.isEmpty {
            return films
        } else {
            return films.filter{$0.title.contains(searchText)}
        }
    }
    
    var body: some View {
        VStack {
            
            List {
                ForEach(searchFilms, id: \.self) { film in
                    NavigationLink(destination: ResultView(initialTitle: removeSpaces(title: film.title), films: films)) {
                        Text(film.title)
                    }
                }
            }
            .searchable(text: $searchText)
            .task {
                await getGenreFilms(genre: genre)
            }
        }
        .navigationTitle("Search movies")
    }
    
    
    func getGenreFilms(genre: String) async {
        guard let url = Bundle.main.url(forResource: genre, withExtension: "json") else {
            print("Invalid path")
            return
        }
        
        if let filmsData = try? Data(contentsOf: url) {
            let filmsDecoder = JSONDecoder()
            if let loadedFilms = try? filmsDecoder.decode(FilmsData.self, from: filmsData) {
                filmData = loadedFilms
                films = filmData.films
            }
        }
    }
    
    func removeSpaces(title: String) -> String{
        return title.replacingOccurrences(of: " ", with: "%20")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(genre: "comedy")
    }
}
