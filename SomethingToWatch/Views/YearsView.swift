//
//  YearsView.swift
//  SomethingToWatch
//
//  Created by Bartosz Klimek on 30/01/2022.
//

import SwiftUI

struct FilmsData: Codable {
    var films: [Films]
}
struct Films: Codable {
    let id: Int
    let title: String
    let year: Int
}

struct YearsView: View {
    var genre: String
    @State private var filmData: FilmsData!
    @State private var films: [Films] = []
   
    var body: some View {
        VStack {
            List(films, id: \.id) { film in
                Text(film.title)
            }
            .task{await loadFilmsFromGenre(genre: genre)}
        }
    }
    
    func loadFilmsFromGenre(genre: String) async {
        guard let url = Bundle.main.url(forResource: genre, withExtension: "json") else {
            print("Invalid path")
            return
        }
        
        if let filmsData = try? Data(contentsOf: url) {
            let filmsDecoder = JSONDecoder()
            if let loadedFilms = try? filmsDecoder.decode(FilmsData.self, from: filmsData) {
                filmData = loadedFilms
                films = filmData.films
                print(films[0].year)
//                print(films[films.capacity - 1].year)
            }
        }
    }
}



struct YearsView_Previews: PreviewProvider {
    static var previews: some View {
        YearsView(genre: "fantasy")
    }
}
