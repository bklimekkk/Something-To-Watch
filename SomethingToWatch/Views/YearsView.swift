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
struct Films: Codable, Identifiable {
    let id: Int
    let title: String
    let year: Int
}

struct YearsView: View {
    var genre: String
    @State private var filmData: FilmsData!
    @State private var films: [Films] = []
    @State private var timeSlot: [String:Int] = [:]
   
    var body: some View {
        VStack {
            List{
                ForEach(timeSlot.sorted(by:>), id: \.key) { key, value in
                    NavigationLink(destination: LengthView(films: films, minYear: value, maxYear: value + 9)) {
                        Text(key)
                            .frame(height: 40)
                    }
                }
            }
            .navigationTitle("Choose time slot")
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
               timeSlot = getTimeSlots(firstFilmYear: films[0].year)
            }
        }
    }
}

func getTimeSlots(firstFilmYear: Int) -> [String:Int] {
    var timeSlotsArray: [String:Int] = [:]
    var timeSlotInt = firstFilmYear - firstFilmYear%10
    while(timeSlotInt <= 2020) {
        timeSlotsArray["\(timeSlotInt)s"] = timeSlotInt
        timeSlotInt = timeSlotInt + 10
    }
    return timeSlotsArray
}


struct YearsView_Previews: PreviewProvider {
    static var previews: some View {
        YearsView(genre: "fantasy")
    }
}
