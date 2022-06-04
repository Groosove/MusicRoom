//
//  HeaderView.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 17.04.2022.
//

import UIKit

final class HeaderView: UICollectionReusableView {

	// MARK: - Private properties

	private enum Constants {
		static let insets: CGFloat = 10
	}

	static let reuseIdentifier = "header-reuse-identifier"

	private let label: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .title3)
		label.adjustsFontForContentSizeCategory = true
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .systemBackground
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("MusicRoom.HeaderView")
	}

	// MARK: - Public functions

	func configure(labelText: String) {
		label.text = labelText
	}

	// MARK: - Private functions

	private func setupUI() {
		addSubview(label)

		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets),
			label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.insets),
			label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets),
			label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.insets)
		])
	}
}
