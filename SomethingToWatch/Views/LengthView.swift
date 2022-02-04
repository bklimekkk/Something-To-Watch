//
//  LengthView.swift
//  SomethingToWatch
//
//  Created by Bartosz Klimek on 02/02/2022.
//

import SwiftUI

struct Length: Identifiable {
    let id: Int
    let length: Int
}
struct LengthView: View {
    var films: [Films]
    var lengthsList: [Length] = [
        Length(id: 1, length: 200),
        Length(id: 2, length: 180),
        Length(id: 3, length: 160),
        Length(id: 4, length: 140),
        Length(id: 5, length: 120),
        Length(id: 6, length: 140)
    ]
    @State var filmsFromTimeSlot: [Films] = []
    var minYear: Int
    var maxYear: Int
    
    var body: some View {
        List(lengthsList) { length in
            NavigationLink(destination: ResultView(films: getShuffledFilmsFromTimeSlot(films: films, minYear: minYear, maxYear: maxYear))) {
                Text("\(length.length/60) \(returnHours(filmDuration:length.length))\(returnMinutes(filmDuration: length.length))")
                    .font(.system(size:20))
                    .frame(height: 50)
                   
            }
          
        }
        .navigationTitle("Maximal duration")
    }
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

func returnMinutes(filmDuration: Int) -> String {
    let numberOfMinutes = filmDuration%60
    return numberOfMinutes != 0 ? " and \(numberOfMinutes) minutes" : ""
}

func returnHours(filmDuration: Int) -> String {
    let numberOfHours = filmDuration/60
    return numberOfHours == 1 ? "hour" : "hours"
}
struct LengthView_Previews: PreviewProvider {
    static var previews: some View {
        LengthView(films: [], minYear: 2000, maxYear: 2010)
    }
}
