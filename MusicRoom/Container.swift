//
//  Container.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 29.12.2021.
//

import Foundation

/// Протокол контейнера зависимостей
protocol ContainerProtocol {

	/// Регистрирует зависимость
	/// - Parameters:
	///   - type: Тип зависимости
	///   - factory: Фабрика порождающая зависимость
	func register<T>(type: T.Type, factory: @escaping (ContainerProtocol) throws -> T)

	/// Регистрирует зависимость
	/// - Parameters:
	///   - type: Тип зависимости
	///   - objectScope: Сущность, описывающий время жизни зарегистрированной зависимости
	///   - name: Имя регистрируемой зависимости
	///   - factory: Фабрика порождающая зависимость
	func register<T>(type: T.Type,
					 objectScope: ObjectScope,
					 name: String?,
					 factory: @escaping (ContainerProtocol) throws -> T)

	/// Регистрирует зависимость
	/// - Parameters:
	///   - type: Тип зависимости
	///   - objectScope: Сущность, описывающий время жизни зарегистрированной зависимости
	///   - factory: Фабрика порождающая зависимость
	func register<T>(type: T.Type, objectScope: ObjectScope, factory: @escaping (ContainerProtocol) throws -> T)

	/// Возвращает зависимость без явного указания типа
	func resolve<T>() throws -> T

	/// Возвращает зависимость
	/// - Parameter type: Тип зависимости
	func resolve<T>(type: T.Type) throws -> T

	/// Возвращает зависимость
	/// - Parameters:
	///   - type: Тип зависимости
	///   - name: Имя возвращаемой зависимости
	func resolve<T>(type: T.Type, name: String?) throws -> T
}

extension ContainerProtocol {

	func register<T>(type: T.Type, factory: @escaping (ContainerProtocol) throws -> T) {
		register(type: type, objectScope: .unique, name: nil, factory: factory)
	}

	func register<T>(type: T.Type, objectScope: ObjectScope, factory: @escaping (ContainerProtocol) throws -> T) {
		register(type: type, objectScope: objectScope, name: nil, factory: factory)
	}

	func resolve<T>() throws -> T {
		try resolve(type: T.self, name: nil)
	}

	func resolve<T>(type: T.Type) throws -> T {
		try resolve(type: type, name: nil)
	}
}

/// Container класс, позволяющий управлять зависимостями.
/// Note:
///  - Резолв зависимостей не синхронизирован
///
/// Пример регистрации зависимости:
///
/// let container = Container()
/// container.register(type: House.self) { _ in
/// 	House()
/// }
/// container.register(type: City.self) { r in
/// 	City(house: r.resolve(House.self)
/// }
///
/// Пример резолва зависимости:
///
/// try? container.resolve(type: City.self)
///
final class Container: ContainerProtocol {

	// MARK: - Properties

	/// Зарегистрированные зависимости
	private(set) var dependencies: [Key: DependencyProtocol] = [:]

	// MARK: - ContainerProtocol

	func register<T>(type: T.Type,
					 objectScope: ObjectScope = .unique,
					 name: String?,
					 factory: @escaping (ContainerProtocol) throws -> T) {
		let key = Key(type: type, name: name)
		let dependency = createDependency(type: type, objectScope: objectScope, factory: factory)
		dependencies[key] = dependency
	}

	func resolve<T>(type: T.Type, name: String?) throws -> T {
		let key = Key(type: type, name: name)
		return try getDependency(key: key)
	}

	// MARK: - Private methods

	private func createDependency<T>(type: T.Type,
									 objectScope: ObjectScope,
									 factory: @escaping (ContainerProtocol) throws -> T) -> DependencyProtocol {
		let storage = StorageFactory.makeStorage(for: objectScope)
		return Dependency(type: type, objectScope: objectScope, factory: factory, instanceStorage: storage)
	}

	private func getDependency<T>(key: Key) throws -> T {
		guard var dependency = dependencies[key] else {
			throw Container.Error.registration(message: "Не найдена регистрация для: \(key.type)!")
		}

		if let instance = dependency.instance as? T {
			return instance
		}

		guard let resolvedInstance = try dependency.factory(self) as? T else {
			throw Container.Error.typeCasting
		}

		dependency.instance = resolvedInstance

		return resolvedInstance
	}
}

extension Container {

	/// Ключ по которому хранится зависимость в контейнере
	struct Key: Hashable {

		/// Тип зависимости
		let type: Any.Type

		/// Название зависимости
		let name: String?

		// MARK: - Hashable

		func hash(into hasher: inout Hasher) {
			ObjectIdentifier(type).hash(into: &hasher)
			name?.hash(into: &hasher)
		}

		// MARK: Equatable

		static func == (lhs: Container.Key, rhs: Container.Key) -> Bool {
			return lhs.type == rhs.type &&
				   lhs.name == rhs.name
		}
	}

	/// Ошибка контейнера
	enum Error: LocalizedError {

		/// Не найдена регистрация
		case registration(message: String)

		/// Не удалось распознать тип
		case typeCasting
	}
}
