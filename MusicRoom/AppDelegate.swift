//
//  AppDelegate.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 20.02.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	private let factories: [AssemblyProtocol] = [
		ApplicationLayerAssembly(),
		ServiceLayerAssembly(),
		DataLayerAssembly(),
		DomainLayerAssembly(),
		PresentationLayerAssembly()
	]

	func application(_ application: UIApplication, didFinishLaunchingWithOptions
					 launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let container = Container()
		window = UIWindow(frame: UIScreen.main.bounds)

		factories.forEach { $0.configure(container) }
		window?.rootViewController = try? container.resolve(type: MainTabBarController.self)
		window?.makeKeyAndVisible()
		return true
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "MusicRoom")
		container.loadPersistentStores(completionHandler: { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}
