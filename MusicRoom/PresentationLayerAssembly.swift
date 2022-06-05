//
//  PresentationLayerAssembly.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 05.06.2022.
//

/// Презентационный слой приложения
final class PresentationLayerAssembly: AssemblyProtocol {

	func configure(_ container: ContainerProtocol) {
		container.register(type: MainTabBarController.self, factory: { _ in
			MainTabBarController()
		})
	}
}
