//
//  ExtensionViewController+KeyboardHandler.swift
//  themoviedb
//
//  Created by nicolas castello on 09/07/2023.
//

import Foundation
import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    // MARK: - ConfigDismissBoard
    // It recognizes the swipe up or down and hides the keyboard
    func configDismissBoard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToUp(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToDown(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToLeftSwipe(_:)))

        upSwipe.direction = .up
        downSwipe.direction = .down
        leftSwipe.direction = .left
        
        upSwipe.delegate = self
        downSwipe.delegate = self
        leftSwipe.delegate = self
        
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(leftSwipe)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           true
       }

    @objc func moveToUp(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }

    }
    @objc func moveToDown(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
    }
    @objc func moveToLeftSwipe(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
    }
    
    @objc func dismissKeyboard() {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            self.view.endEditing(true)
        }
    }
    
}
