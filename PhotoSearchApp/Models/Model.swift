//
//  Model.swift
//  PhotoSearchApp
//
//  Created by Evgenii Kolgin on 11.07.2021.
//

import Foundation

struct PhotoResultsWrapper: Decodable {
    let hits: [Photo]
}

struct Photo: Decodable, Hashable {
    let id: Int
    let webformatURL: String
}
