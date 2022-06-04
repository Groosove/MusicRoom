//
//  Dependency.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 29.12.2021.
//

/// Протокол зависимости создаваемой в контейнере
protocol DependencyProtocol {

	/// Экземпляр зависимости
	var instance: Any? { get set }

	/// Фабрика порождающая зависимость
	var factory: Factory { get }
}

/// Фабрика порождающая зависимость
typealias Factory = (ContainerProtocol) throws -> Any

/// Класс зависимости создаваемой в контейнере
final class Dependency: DependencyProtocol {

	// MARK: - DependencyProtocol

	var instance: Any? {
		get { return instanceStorage.instance }
		set { instanceStorage.instance = newValue }
	}
	private(set) var factory: Factory

	// MARK: - Private properties

	private let type: Any.Type
	private let objectScope: ObjectScope
	private var instanceStorage: InstanceStorageProtocol

	// MARK: - Init

	/// Инициализация
	/// - Parameters:
	///   - type: Тип зависимости
	///   - objectScope: Сущность, описывающий время жизни зарегистрированной зависимости
	///   - factory: Фабрика порождающая зависимость
	///   - instanceStorage: Хранилище экземпляра зависимости
	init(type: Any.Type, objectScope: ObjectScope, factory: @escaping Factory, instanceStorage: InstanceStorageProtocol) {
		self.type = type
		self.objectScope = objectScope
		self.factory = factory
		self.instanceStorage = instanceStorage
	}
}
