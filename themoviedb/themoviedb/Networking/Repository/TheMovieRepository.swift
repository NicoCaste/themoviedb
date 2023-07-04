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
    
//    func getComponents() -> URLComponents {
//        var components = URLComponents()
//        components.queryItems = [
//            URLQueryItem(name: "redirect_uri", value: Constant.redirectUri)
//        ]
//
//        return components
//    }
}

extension TheMovieRepository {
    enum PathForMovies {
        case discover
        case search(forText: String)
        
        var stringValue: String {
            switch self {
            case .discover: return "discover/movie?"
            case .search(forText: let query): return "search/movie?query=\(query)&"
            }
        }
    }
    
    func getMovies(for path: PathForMovies, page: Int, includeVideo: Bool, includeAdult: Bool) async throws -> Result<Data, Error> {
        let path = getDiscoverMoviesPath(for: path, page: page, includeVideo: includeVideo, includeAdult: includeAdult)
        let url = ApiUrlHelper.makeURL(for: .theMovieApi, url: path)
        guard let url =  NSURL(string: url) as? URL else { throw NetWorkingError.badURL }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        return try await getFromWebServices(request: request)
    }
    
    private func getDiscoverMoviesPath(for path: PathForMovies, page: Int, includeVideo: Bool, includeAdult: Bool) -> String {
        "\(path.stringValue)discover/movie?include_adult=\(includeAdult)&include_video=\(includeVideo)&language=en-US&page=\(page)&sort_by=popularity.desc"
    }
    
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
}
