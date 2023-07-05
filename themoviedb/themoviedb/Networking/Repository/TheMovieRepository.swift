//
//  TheMovieRepository.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation

final class TheMovieRepository {
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
        let url = ApiUrlHelper.makeURL(for: .theMovieApi, url: path)
        let queryItems = getQueryItemsForMovies(page: page, includeVideo: includeVideo, includeAdult: includeAdult)
        var nsurl = NSURL(string: url) as? URL
        nsurl?.append(queryItems: queryItems)
        guard let url =  nsurl else { throw NetWorkingError.badURL }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        return try await getFromWebServices(request: request)
    }
    
    private func getQueryItemsForMovies(page: Int?, includeVideo: Bool?, includeAdult: Bool?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        if let page, let includeAdult, let includeVideo {
            let includeAdult = URLQueryItem(name: "include_adult", value: "\(includeAdult)")
            let includeVideo = URLQueryItem(name: "include_video", value: "\(includeVideo)")
            let page = URLQueryItem(name: "page", value: "\(page)")
            let sortBy = URLQueryItem(name: "sort_by", value: "popularity.desc")
            queryItems.append(sortBy)
            queryItems.append(includeAdult)
            queryItems.append(includeVideo)
            queryItems.append(page)
        }

        let language =  URLQueryItem(name: "language", value: "en-US)")
        queryItems.append(language)


        return queryItems
    }
}
