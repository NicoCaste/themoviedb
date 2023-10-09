//
//  Extension+NotificationName.swift
//  themoviedb
//
//  Created by nicolas castello on 08/10/2023.
//

import Foundation

extension NSNotification.Name {
    static var movieSubscribedSelected: NSNotification.Name {
        return .init(rawValue: "movieSubscribedSelected")
    }
    
    static var showErrorView: NSNotification.Name {
        return .init(rawValue: "showErrorView")
    }
}
