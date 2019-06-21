//
//  UdacityAPI.swift
//  MyProject
//
//  Created by Hailah on 20/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation



class API {
    static func postSession(with email: String, password: String, completion: @escaping ([String: Any]?, Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(nil ,error)
                return
            }
            
            let newData = data?[5..<data!.count]
            
            let result = try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any?]
            completion(result,nil)
        }
        task.resume()
    }
    
    static func deleteSession(completion: @escaping (Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(error)
                return
            }
            
            let newData = data?[5..<data!.count]
            print(String(data: newData!, encoding: .utf8)!)
            
            completion(nil)
        }
        task.resume()
    }
    
    
}
