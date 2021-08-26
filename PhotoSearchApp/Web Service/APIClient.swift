//
//  APIClient.swift
//  PhotoSearchApp
//
//  Created by Evgenii Kolgin on 07.07.2021.
//

import UIKit
import Combine

class APIClient {
    
    public func searchPhotos(for query: String) -> AnyPublisher<[Photo], Error> {
        let perPage = 200
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? "paris"
        let endpoint = "https://pixabay.com/api/?key=\(APICredentials.API_KEY)&q=\(query)&per_page=\(perPage)&safesearch=true"
        
        let url = URL(string: endpoint)!
        
        // using Combine for networking
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PhotoResultsWrapper.self, decoder: JSONDecoder())
            .map { $0.hits }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
