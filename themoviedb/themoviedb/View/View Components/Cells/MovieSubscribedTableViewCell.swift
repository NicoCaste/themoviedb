//
//  MovieSubscribedTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 13/09/2023.
//

import UIKit

class MovieSubscribedTableViewCell: UITableViewCell {
    lazy var title: UILabel = UILabel()
    var collectionView: UICollectionView?
    var movies: [MovieDetail]?
    var firstLoad = true
    
    func populate(movies: [MovieDetail]) {
        self.movies = movies
        self.backgroundColor = UIColor.clear
        configCollectionView()
    }
    
    private func configCollectionView() {
        if collectionView == nil {
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        }
        guard let collectionView = collectionView else { return }
        collectionView.register(MovieSubscribedCollectionViewCell.self, forCellWithReuseIdentifier: "MovieSubscribedCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.estimatedItemSize = CGSize(width: 100, height: 150)
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = true
        
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}
