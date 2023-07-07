//
//  ViewModelHandleNextStepProtocol.swift
//  themoviedb
//
//  Created by nicolas castello on 07/07/2023.
//

import Foundation

protocol ViewModelHandleNextStepProtocol: BasicViewModel {
    func getDetailInfo(movie index: Int) -> BasicViewController?
}
