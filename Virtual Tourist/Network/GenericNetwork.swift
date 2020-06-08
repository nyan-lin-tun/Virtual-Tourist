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
        static let numberOfPhotos = 25
    }
    
    enum Endpoints {
        
        case imageInfoWithLocation(Double, Double)
        
        var stringValue: String {
            switch self {
            case .imageInfoWithLocation(let latitude, let longtitude):
                return "\(Constants.base)?api_key=\(getFlickrApiKey())&method=\(Constants.searchMethod)&per_page=\(Constants.numberOfPhotos)&format=json&nojsoncallback=?&accuracy=\(Constants.accuracy)&lat=\(latitude)&lon=\(longtitude)&page=\((1...10).randomElement() ?? 1)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getPhotos(latitude: Double,
                         longtitude: Double,
                         completion: @escaping ([PhotoResponse], Error?) -> Void) {

        let url = Endpoints.imageInfoWithLocation(latitude, longtitude).url
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(FlickrResponse.self, from: data)
                let images = responseObject.photos.photo
                completion(images, nil)
                
                var photosUrl:[String] = []
                for image in images {
                    let imageUrl = "https://farm\(image.farm).staticflickr.com/\(image.server)/\(image.id)_\(image.secret).jpg"
                    photosUrl.append(imageUrl)
                }
                for i in photosUrl {
                    print(i)
                }
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    class func getPhotoData(imageInfo: PhotoResponse,
                            completion: @escaping (Data?, Error?) -> Void) {
        let imageUrl = "https://farm\(imageInfo.farm).staticflickr.com/\(imageInfo.server)/\(imageInfo.id)_\(imageInfo.secret).jpg" + "&api_key=\(self.getFlickrApiKey())"
        let url = URL(string: imageUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
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
