//
//  MovieRepositoryMock.swift
//  themoviedbTests
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation
@testable import themoviedb

enum MovieResponseMock {
    case gendreList
    case moviesResult
}

class MovieRespositoryMock: TheMovieRepositoryProtocol {
    var webService: themoviedb.WebService
    let responseType: MovieResponseMock

    required init(responseType: MovieResponseMock) {
        self.responseType = responseType
        webService = WebServiceMock()
    }
    
    func getBasicRequest(url: URL, components: URLComponents) -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
    
    func getDataFromMoviesApi(for path: themoviedb.ApiUrlHelper.PathForMovies, page: Int?, includeVideo: Bool?, includeAdult: Bool?) async throws -> Result<Data, Error> {
        return Result<Data, Error>(catching: getData)
    }
    
    func getData() throws -> Data {
        switch responseType {
        case .gendreList:
            return try getGenresData()
        case .moviesResult:
            return try getMoviesResult()
        }
    }
}

extension MovieRespositoryMock {
    func getGenresData() throws -> Data {
        let jsonString = """
        {
            "genres":        [
            {
                "name": "Western",
                "id": 37
            },
            {
                "name": "terror",
                "id": 25
            }
        ]
        }
        """

        let jsonData = Data(jsonString.utf8)
        return jsonData
    }
    
    func getMoviesResult() throws -> Data {
        let jsonString = """
        {
            "page": 1,
            "results": [
            {
                "original_title": "test movie",
                "id": 37,
                "vote_count": 1,
                "vote_average": 1
            }]
        }
        """
        let jsonData = Data(jsonString.utf8)
        return jsonData
    }
}
