//
//  TheMovieRepository.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

protocol TheMovieRepositoryProtocol {
    var webService: WebService {get}
    func getBasicRequest(url: URL, components: URLComponents) -> URLRequest
    func getDataFromMoviesApi(for path: ApiUrlHelper.PathForMovies, page: Int?, includeVideo: Bool?, includeAdult: Bool?) async throws -> Result<Data, Error>
}

final class TheMovieRepository: TheMovieRepositoryProtocol {
    var webService: WebService
    static private var apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZDc2ZTE0NWExMDYwYzMwOTBjYzUyYTM5ZjI1ZjE0MCIsInN1YiI6IjY0YTNjNDljZTlkYTY5MDEwMTQ3NmQwZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KbijbMuTqucX0s2AKlNQtbcFNoE2oqWTbY8CntkMWus"
    private var headers =  [ "accept": "application/json", "Authorization": apiKey ]
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func getBasicRequest(url: URL, components: URLComponents) -> URLRequest {
        let request = URLRequest(url: url)
        return request
    }
}

extension TheMovieRepository {

    //MARK: - Get From Web Services
    private func getFromWebServices(request: URLRequest) async throws -> Result<Data, Error> {
        try await withCheckedThrowingContinuation({ continuation in
            webService.get(from: request, completion: { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: .success(data))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        })
    }
    
    func getDataFromMoviesApi(for path: ApiUrlHelper.PathForMovies, page: Int? = nil, includeVideo: Bool? = nil, includeAdult: Bool? = nil) async throws -> Result<Data, Error> {
        
        //enviroment for UITesting
        if ProcessInfo.processInfo.environment["ui_test_variable"] == "verbose" {
            return Result<Data,Error>(catching: jsonForTest)
        }
        
        let url = ApiUrlHelper.makeURL(for: .theMovieApi, url: path)
        let queryItems = getQueryItemsForMovies(page: page, includeVideo: includeVideo, includeAdult: includeAdult)
        var nsurl = NSURL(string: url) as? URL
        nsurl?.append(queryItems: queryItems)
        guard let url =  nsurl else { throw NetWorkingError.badURL }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        return try await getFromWebServices(request: request)
    }
    
    private func jsonForTest() throws -> Data {
        guard let path = Bundle.main.path(forResource: "MoviesResult", ofType: "json") else { throw NetWorkingError.unknowError }

        let url = URL(fileURLWithPath: path)

        let data = try Data(contentsOf: url)
        return data
    }
    
    
    private func getQueryItemsForMovies(page: Int?, includeVideo: Bool?, includeAdult: Bool?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        if let page {
            let page = URLQueryItem(name: "page", value: "\(page)")
            queryItems.append(page)
        }
        
        if let includeAdult {
            let includeAdult = URLQueryItem(name: "include_adult", value: "\(includeAdult)")
            queryItems.append(includeAdult)
        }
        
        if let includeVideo {
            let includeVideo = URLQueryItem(name: "include_video", value: "\(includeVideo)")
            queryItems.append(includeVideo)
          
        }

        let language =  URLQueryItem(name: "language", value: "en-US)")
        queryItems.append(language)


        return queryItems
    }
}
