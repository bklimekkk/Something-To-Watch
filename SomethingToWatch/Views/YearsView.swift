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
    @State private var films = [Films]()
   
    var body: some View {
        VStack {
            Text(String(films.capacity))
            List(films, id: \.id) { film in
                Text(film.title)
            }
            .task{await loadFilmsFromGenre()}
        }
    }
    
    func loadFilmsFromGenre() async {
        guard let url = Bundle.main.url(forResource: "comedy", withExtension: "json") else {
            print("Invalid path")
            return
        }
         
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(FilmsData.self, from: data) {
                films = decodedData.films
            }
        } catch {
            print("Invalid data")
        }
    }
}



struct YearsView_Previews: PreviewProvider {
    static var previews: some View {
        YearsView()
    }
}
