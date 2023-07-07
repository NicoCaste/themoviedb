//
//  ViewModelHandleTextFieldProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation

protocol ViewModelHandleTextFieldProtocol: BasicViewModel {
    func getPathForUserInput(text: String) -> ApiUrlHelper.PathForMovies
}
