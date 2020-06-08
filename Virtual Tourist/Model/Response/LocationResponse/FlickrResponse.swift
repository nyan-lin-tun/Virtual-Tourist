//
//  FlickrResponse.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 08/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation

struct FlickrResponse: Codable {
    
    let stat: String
    let photos: PhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case stat = "stat"
        case photos = "photos"
    }
}
