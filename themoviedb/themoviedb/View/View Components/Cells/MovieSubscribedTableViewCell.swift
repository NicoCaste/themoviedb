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
    var movies: [Movie]?
    var firstLoad = true
    
    func populate(movies: [Movie]) {
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
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.estimatedItemSize = CGSize(width: 100, height: 150)
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = true
        
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}

extension MovieSubscribedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Number Of Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()
        return movies?.count ?? 0
    }
    
    // MARK: - Cell For Item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSubscribedCollectionViewCell", for: indexPath) as? MovieSubscribedCollectionViewCell
        let path = movies?[indexPath.row].posterPath
        let imageSetting = ImageSetting(imagePath: path, width: 100, height: 150, corner: 10)
        cell?.populate(image: imageSetting)
        return cell ?? UICollectionViewCell()
    }
    
    // MARK: - did Select Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie: Movie = movies?[indexPath.row] else { return }
        NotificationCenter.default.post(name: NSNotification.Name.movieSubscribedSelected, object: nil,userInfo: ["movie": movie])
    }
}
