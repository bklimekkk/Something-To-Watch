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
struct Films: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let year: Int
}

var randomNumber: Int = 0

struct YearsView: View {
    var genre: String
    @State private var filmData: FilmsData!
    @State private var films: [Films] = []
    @State private var timeSlot: [String:Int] = [:]
    
    
    var body: some View {
        VStack {
            NavigationLink(destination: SearchView(genre:genre)) {
                SearchMoviesButton()
            }
            List{
                ForEach(timeSlot.sorted(by:>), id: \.key) {key, value in
                    NavigationLink(destination: ResultView(initialTitle: films[randomNumber].title, films: getShuffledFilmsFromTimeSlot(films: films, minYear: value, maxYear: value + 9))) {
                        Text(key)
                            .font(.system(size:20))
                            .frame(height: 50)
                    }
                }
            }
            .navigationTitle("Choose time slot")
            .task{
                await loadFilmsFromGenre(genre: genre)
                randomNumber = Int.random(in: 0...films.count - 1)
            }
            
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
                timeSlot = getTimeSlots(films: films)
            }
        }
    }
}

func getTimeSlots(films: [Films]) -> [String:Int] {
    var timeSlotsArray: [String:Int] = [:]
    var timeSlotInt = films[0].year - films[0].year%10
    while(timeSlotInt <= 2010) {
        timeSlotsArray["\(timeSlotInt)s"] = timeSlotInt
        timeSlotInt = timeSlotInt + 10
    }
    if(films[films.count - 1].year >= 2020) {
        timeSlotsArray["2020s"] = 2020
    }
    return timeSlotsArray
}

func getShuffledFilmsFromTimeSlot(films: [Films], minYear: Int, maxYear: Int) -> [Films] {
    var filmsFromTimeSlot: [Films] = []
    for film in films {
        if(film.year >= minYear && film.year <= maxYear) {
            filmsFromTimeSlot.append(film)
        }
    }
    return filmsFromTimeSlot.shuffled()
}

struct SearchMoviesButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .padding()
                .frame(height: 100)
                .foregroundColor(Color.blue)
            Text("Search movies")
                .foregroundColor(Color.white)
        }
    }
}


struct YearsView_Previews: PreviewProvider {
    static var previews: some View {
        YearsView(genre: "fantasy")
    }
}
