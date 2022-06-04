//
//  AlbumCollectionViewCell.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 19.03.2022.
//

import UIKit

/// Ячейка альбома
final class AlbumCollectionViewCell: UICollectionViewCell {

	static let id = "MainTableViewCellIdentifier"

	// MARK: - Private properties

	private enum Constants {
		static let spacing: CGFloat = 10
	}

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		label.adjustsFontForContentSizeCategory = true
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let imageCountLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		label.adjustsFontForContentSizeCategory = true
		label.textColor = .placeholderText
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let featuredPhotoView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 4
		imageView.clipsToBounds = true
		return imageView
	}()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public functions

	func configure(item: Item) {
		titleLabel.text = item.title
		imageCountLabel.text = item.subtitle
		featuredPhotoView.image = item.albumImage
	}

	// MARK: - Private functions

	private func setupUI() {
		[titleLabel, featuredPhotoView, imageCountLabel].forEach { contentView.addSubview($0) }

		NSLayoutConstraint.activate([
			featuredPhotoView.topAnchor.constraint(equalTo: contentView.topAnchor),
			featuredPhotoView.heightAnchor.constraint(equalToConstant: 128),
			featuredPhotoView.widthAnchor.constraint(equalToConstant: 256),

			titleLabel.topAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: Constants.spacing),
			titleLabel.leadingAnchor.constraint(equalTo: featuredPhotoView.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: featuredPhotoView.trailingAnchor),

			imageCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			imageCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
