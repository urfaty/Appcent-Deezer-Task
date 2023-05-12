//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import UIKit

class ListingArtistsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var genreId: Int?
    private var artists: [Artist] = []
    private let padding: CGFloat = 10
    private let columns: CGFloat = 2
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ListingArtistsCell.self, forCellWithReuseIdentifier: ListingArtistsCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .systemPink
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchArtistsFromApi() 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingArtistsCell.identifier, for: indexPath) as! ListingArtistsCell
        cell.configure(with: artists[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        let vc = ArtistDetailController()
        vc.artistId = artist.id
        vc.artistImageUrl = artist.picture_medium
        vc.title = artist.name
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListingArtistsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (columns + 1) * padding) / columns
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

extension ListingArtistsController {
    private func fetchArtistsFromApi() {
        guard let genreId = genreId else { return }
        ArtistsApiRequest.fetchArtists(forGenreId: genreId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let artists):
                    self?.artists = artists
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        }
    }
}


