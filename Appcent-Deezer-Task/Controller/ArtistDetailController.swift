//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import UIKit
import SDWebImage

class ArtistDetailController: UIViewController {
    
    var artistId: Int?
    var artistImageUrl: String?
    private var albums: [AlbumsOfSelectedArtist] = []
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemPink
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        loadArtistImage()
        fetchAlbums()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func loadArtistImage() {
        if let artistImageUrl = artistImageUrl {
            let url = URL(string: artistImageUrl)
            artistImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
        }
    }
    
    func fetchAlbums() {
        if let artistId = artistId {
            fetchAlbums(artistId: artistId)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        artistImageView.frame = headerView.bounds
        headerView.addSubview(artistImageView)
        
        tableView.tableHeaderView = headerView
        tableView.frame = view.bounds
    }
    
    
    func fetchAlbums(artistId: Int) {
        ArtistDetailApiRequest.fetchAlbumsOfArtist(artistId: artistId) { [weak self] result in
            switch result {
            case .success(let albums):
                self?.albums = albums
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
    }
}

extension ArtistDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        cell.configure(with: album)
        return cell
    }
}

extension ArtistDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailViewController = AlbumDetailViewController()
        let selectedAlbum = albums[indexPath.row]
        albumDetailViewController.albumId = selectedAlbum.id
        navigationController?.pushViewController(albumDetailViewController, animated: true)
    }
}
