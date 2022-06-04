//
//  MainTabBarController.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 21.02.2022.
//

import UIKit

final class CustomNavigationController: UINavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}

/// Таб бар приложения
final class MainTabBarController: UITabBarController {

	// MARK: - View Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		viewControllers = [ createMainController(), createSearchController(), createLibraryController() ]
		UITabBar.appearance().barTintColor = .black
	}

	// MARK: - Private functions

	private func createMainController() -> UIViewController {
		let viewController = MainViewController()
		let navController = CustomNavigationController(rootViewController: viewController)
		navController.tabBarItem.title = "Главная"
		navController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12)], for: .normal)
		navController.tabBarItem.image = UIImage(named: "home")
		navController.tabBarItem.selectedImage = UIImage(named: "home_filled")
		navController.navigationBar.isTranslucent = false
		return navController
	}

	private func createSearchController() -> UIViewController {
		let viewController = SearchViewController()
		let navController = CustomNavigationController(rootViewController: viewController)
		navController.tabBarItem.title = "Поиск"
		navController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12)], for: .normal)
		navController.tabBarItem.image = UIImage(named: "search")
		navController.tabBarItem.selectedImage = UIImage(named: "search")
		navController.navigationBar.backgroundColor = .black
		navController.navigationBar.isTranslucent = false
		return navController
	}

	private func createLibraryController() -> UIViewController {
		let viewController = LibraryViewController()
		let navController = CustomNavigationController(rootViewController: viewController)
		navController.tabBarItem.title = "Моя медиатека"
		navController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12)], for: .normal)
		navController.tabBarItem.image = UIImage(named: "library")
		navController.tabBarItem.selectedImage = UIImage(named: "library_filled")
		navController.navigationBar.backgroundColor = .black
		navController.navigationBar.isTranslucent = false
		return navController
	}
}
