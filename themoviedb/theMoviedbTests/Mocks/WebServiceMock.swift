//
//  WebServiceMock.swift
//  themoviedbTests
//
//  Created by nicolas castello on 09/10/2023.
//

import Foundation
@testable import themoviedb

class WebServiceMock: WebService {
    var data: Data?
    var error: Error?

    func get(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {

        let result = Result<Data, Error>(catching: emptyResponse)
        completion(result)
    }

    func emptyResponse() throws -> Data {
        return Data()
    }
}
