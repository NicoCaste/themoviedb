//
//  WebServicesProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

protocol WebService {
    func get(from request: URLRequest, completion: @escaping (Result<Data, Error>)  -> Void)
}
