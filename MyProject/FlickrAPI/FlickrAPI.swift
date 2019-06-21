//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Hailah on 15/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import Foundation
import MapKit

struct FlickrAPI {
    
    static func getImagesURLs(with coordinates : CLLocationCoordinate2D , pageNumber : Int , completion : @escaping ([URL]? , Error? ,String?) ->()){
        let methodParameters = [
            Constants.FlickrParametersKeys.method : Constants.FlickrParametersValues.searchMethod,
            Constants.FlickrParametersKeys.APIKey : Constants.FlickrParametersValues.APIKey,
            Constants.FlickrParametersKeys.boundingBox : boundingBoxString(for: coordinates),
            Constants.FlickrParametersKeys.safeSearch : Constants.FlickrParametersValues.useSafeSearch,
            Constants.FlickrParametersKeys.extras : Constants.FlickrParametersValues.mediumURL,
            Constants.FlickrParametersKeys.format : Constants.FlickrParametersValues.responseFormat,
            Constants.FlickrParametersKeys.NoJSONCallBack : Constants.FlickrParametersValues.disableJSONCallBack,
            Constants.FlickrParametersKeys.page : pageNumber, Constants.FlickrParametersKeys.perPage : 9] as [String : Any]
        
        
        let request = URLRequest(url: getURL(from : methodParameters))
        let task = URLSession.shared.dataTask(with: request) { (data , response, error) in
            guard (error == nil) else {
                completion(nil, error , nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil , nil ,"expired the limit")
                return
            }
            
            guard let data = data else {
                completion(nil , nil ,"no data")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] else {
                completion(nil, nil , "could get data")
                return
            }
            
            guard let stat = result["stat"] as? String, stat == "ok" else {
                completion(nil , nil , "\(result)")
                return
            }
            
            guard let imagesDictionary = result["photos"] as? [String:Any] else {
                completion(nil , nil , "\(result)" )
                return
            }
            
            guard let imagesArray = imagesDictionary["photo"] as? [[String:Any]] else {
                completion(nil , nil , "cant find image in \(imagesDictionary)" )
                return
            }
            
            var imageURLs = [URL]()
            for imagesDictionary in imagesArray {
            guard let urlString = imagesDictionary["url_m"] as? String else { return }
            let url = URL(string : urlString)
             imageURLs.append(url!)
            }
            completion(imageURLs, nil , nil)
        }
        
        task.resume()
        
    }
    
    static func boundingBoxString(for coordinate : CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let searchBBoxHalfLength = 0.6
        
        let minLon = max(longitude - searchBBoxHalfLength, -180)
        let minLat = max(latitude - searchBBoxHalfLength, -90)
        let maxLon = min(longitude + searchBBoxHalfLength, 180)
        let maxLat = min(latitude + searchBBoxHalfLength, 90)
        
        return "\(minLon),\(minLat),\(maxLon),\(maxLat)"
    }
        
    
    
     static func getURL(from parameters: [String : Any]) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key , value) in parameters {
            let qurey = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(qurey)
        }
        return components.url!
    }
    
    
}


struct Constants {
    
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
    }
    
    struct FlickrParametersKeys {
        static let method = "method"
        static let APIKey = "api_key"
        static let extras = "extras"
        static let format = "format"
        static let NoJSONCallBack = "nojsoncallback"
        static let safeSearch = "safe_search"
        static let text = "text"
        static let boundingBox = "bbox"
        static let page = "page"
        static let perPage = "per_page"
    }
    
    struct FlickrParametersValues {
        static let searchMethod = "flickr.photos.search"
        static let APIKey = "1e5cb27bfbaea87df9516459ac4e535a"
        static let responseFormat = "json"
        static let disableJSONCallBack = "1"
        static let galleryPhotosMethod = "flickr.photos.search"
        static let mediumURL = "url_m"
        static let useSafeSearch = "1"
    }
}
