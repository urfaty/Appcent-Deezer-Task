//
//  TabBarController.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = MusicCategoriesController()
        let secondVC = LikedSongsViewController()
        
        firstVC.tabBarItem = UITabBarItem(title: "Müzik Kategoriler", image: UIImage(systemName: "music.quarternote.3"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Beğenilen Şarkılar", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        let controllers = [firstVC, secondVC]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
        tabBar.barTintColor = .white
        tabBar.tintColor = .systemPink
        tabBar.unselectedItemTintColor = .gray
    }
}
