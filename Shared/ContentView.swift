//
//  ContentView.swift
//  Shared
//
//  Created by Kevin Evans on 02/01/2021.
//

import SwiftUI
import Combine


struct Dog: Decodable, Hashable {
    var id: Int
    var name: String
    var breed: String
    
    static let `default` = Dog(id:0, name:"fido", breed:"mutt")
}
typealias Dogs = [Dog]


struct ContentView: View {
    @State private var requests = Set<AnyCancellable>()
    @State private var dogs = [Dog]()
    
    var body: some View {
        VStack {
            List(dogs, id:\.self) { dog in
                Text(dog.name)
            }
            Button("Fetch data"){
                let url = URL(string: "http://localhost/api/dogs")
                self.fetch(url!)
            }
        }
    }

    func fetch(_ url: URL){
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: Dogs.self, decoder:decoder)
            .replaceError(with: [Dog.default])
            .sink(receiveValue: {dogs = $0})
            .store(in: &requests)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
