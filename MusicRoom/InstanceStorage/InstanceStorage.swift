//
//  InstanceStorage.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 29.12.2021.
//

/// Протокол хранилища экземпляра зависимости
protocol InstanceStorageProtocol {

	/// Хранимый экземпляр
	var instance: Any? { get set }
}

/// Класс не хранящий экземпляр, чтобы каждый раз при резолве создавался новый.
final class UniqueStorage: InstanceStorageProtocol {
	var instance: Any? {
		get { nil }
		set {} // swiftlint:disable:this unused_setter_value
	}
}

/// Класс хранит единственный экземпляр.
final class SharedStorage: InstanceStorageProtocol {
	var instance: Any?
}

/// Класс хранит экземпляр до тех пор, пока на него есть хотя бы одна сильная ссылка.
final class WeakStorage: InstanceStorageProtocol {
	weak var value: AnyObject?
	var instance: Any? {
		get { return value }
		set { value = newValue as AnyObject? }
	}
}
