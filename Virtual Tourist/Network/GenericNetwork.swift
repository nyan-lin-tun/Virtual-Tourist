//
//  GenericNetwork.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 08/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation

class GenericNetwork {
    
    struct Constants {
        static let searchMethod = "flickr.photos.search"
        static let base = "https://api.flickr.com/services/rest"
        static let accuracy = 11
        static let numberOfPhotos = 20
    }
    
    enum Endpoints {
        
        
    }
    
    class func getPhotos(latitude: Double, longtitude: Double) {
        print("------------------")
        print(self.getFlickrApiKey())
        let url = "\(Constants.base)?api_key=\(self.getFlickrApiKey())&method=\(Constants.searchMethod)&per_page=\(Constants.numberOfPhotos)&format=json&nojsoncallback=?&lat=\(latitude)&lon=\(longtitude)&page=\((1...10).randomElement() ?? 1)"
        print(url)
    }
    
}

extension GenericNetwork {
    
    
    private static func getFlickrApiKey() -> String {
        if let apiKey = Bundle.main.infoDictionary?["Api Key"] as? String {
            return apiKey
        }else {
            return ""
        }
    }
    
    private static func getFlickerSecretKey() -> String {
        if let apiKey = Bundle.main.infoDictionary?["Api Secret Key"] as? String {
            return apiKey
        }else {
            return ""
        }
    }
    
}
