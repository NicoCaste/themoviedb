//
//  GenericSearchTextField.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation
import UIKit

protocol GenericSearchTextFieldDelegate: AnyObject {
    func userInput(text: String)
}

class GenericSearchTextField: UIView {
    lazy var textField: UITextField? = UITextField()
    
    private var searchTimer: Timer?
    private var timeInterval = 0.8
    private var delegate: GenericSearchTextFieldDelegate
    private var placeholderText: String
    required init(delegate: GenericSearchTextFieldDelegate, placeholderText: String) {
        self.placeholderText = placeholderText
        self.delegate = delegate
        super.init(frame: .zero)
        setCharactersTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetNewArtistsTextField
    private func setCharactersTextField() {
        guard let textField = textField else { return }
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.font = UIFont(name: "Noto Sans Myanmar Bold", size: 18)
        let str = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.attributedPlaceholder = str
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        setSearchCharacterIcon()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        setTextFieldLayout()
        textField.layer.cornerRadius = 8
    }
    
    @objc func textFieldDidChange(_ textField: UITextField ) {
        guard let textFieldtext = textField.text else {return}
        findMovie(from: textFieldtext)
    }
    
    // This function wait 1 second without typing and made de search.
    private func findMovie(from inputText: String) {
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }

        searchTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(searchForKeyword(_:)), userInfo: inputText, repeats: false)
    }

    @objc private func searchForKeyword(_ timer: Timer) {
        guard let text: String = timer.userInfo as? String else { return }
        delegate.userInput(text: text)
    }
    
    private func setSearchCharacterIcon() {
        guard let textField = textField else { return }
        let magnifyInGlass: UIImageView = UIImageView()
        magnifyInGlass.image = UIImage(systemName: "magnifyingglass")
        textField.leftView = magnifyInGlass
        textField.leftViewMode = .always
        magnifyInGlass.tintColor = .darkGray
        magnifyInGlass.heightAnchor.constraint(equalToConstant: 27).isActive = true
        magnifyInGlass.widthAnchor.constraint(equalToConstant: 27).isActive = true
    }
}

extension GenericSearchTextField {
    private func setTextFieldLayout() {
        guard let textField else { return }
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
