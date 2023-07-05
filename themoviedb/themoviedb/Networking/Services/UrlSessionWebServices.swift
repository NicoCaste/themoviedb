//
//  UrlSessionWebServices.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

enum NetWorkingError: Error {
    case badURL
    case serverError
    case unknowError
    case needRefreshToken
    case decodingError
}

struct UrlSessionWebService: WebService {
    func get(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        var newRequest: URLRequest = request
        newRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: newRequest) { data, result, error in
            guard let data = data,
                  let result = result as? HTTPURLResponse,
                  error == nil
            else {
                completion(.failure(error!))
                return
            }
            
            data.printAsJSON()
            switch result.statusCode {
            case 200..<300:
                data.printAsJSON()
                completion(.success(data))
            case 401:
                completion(.failure(NetWorkingError.needRefreshToken))
            case 500..<600:
                completion(.failure(NetWorkingError.serverError))
            default:
                completion(.failure(NetWorkingError.unknowError))
            }
        }
        
        task.resume()
    }
}
