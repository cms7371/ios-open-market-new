//
//  HTTPManager.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation
import UIKit

class HTTPManager {
    private init() { }

    static func getData(url: String, path: [String]?, query: [String: Any]?,
                        completionHandler: @escaping (Data) -> Void) {
        var assembledURL = url
        path?.forEach { assembledURL += "/\($0)" }
        if let query = query {
            let queryStrings = query.map { (key, value) in
                return "\(key)=\(value)"
            }
            assembledURL += "?" + queryStrings.joined(separator: "&")
        }
        guard let url = URL(string: assembledURL) else {
            print("HTTPManager: URL initializing failed")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let getTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("HTTPManager: error - \(error.localizedDescription)")
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("HTTPManager: bad response - \(response.debugDescription)")
                return
            }
            completionHandler(data)
        }
        getTask.resume()
    }
}
