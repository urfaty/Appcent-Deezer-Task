//
//  ViewController.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import UIKit

class MusicCategoriesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var categories: [MusicCategory] = []
    private let padding: CGFloat = 10
    private let columns: CGFloat = 2
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MusicCategoryCell.self, forCellWithReuseIdentifier: MusicCategoryCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Müzik Kategorileri"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        fetchMusicCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCategoryCell.identifier, for: indexPath) as! MusicCategoryCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
}

extension MusicCategoriesController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let vc = ListingArtistsController()
        vc.genreId = category.id
        vc.title = category.name
        vc.hidesBottomBarWhenPushed = true // Add this line to hide the TabBarController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MusicCategoriesController {
    func fetchMusicCategories() {
        MusicCategoriesApiRequest.fetchMusicCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        }
    }
}

