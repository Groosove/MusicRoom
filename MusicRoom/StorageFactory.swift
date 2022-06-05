//
//  StorageFactory.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 29.12.2021.
//

/// Класс создающий хранилище экземпляра зависимости
enum StorageFactory {

	/// Создает хранилище экземпляра зависимости
	/// - Parameter objectScope: Сущность, описывающий время жизни зарегистрированной зависимости
	/// - Returns: Хранилище экземпляра зависимости
	static func makeStorage(for objectScope: ObjectScope) -> InstanceStorageProtocol {
		switch objectScope {
		case .unique:
			return UniqueStorage()

		case .shared:
			return SharedStorage()

		case .weak:
			return WeakStorage()
		}
	}
}
