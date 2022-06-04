//
//  MainView.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 13.03.2022.
//

import UIKit

/// Вью-модель главного экрана
struct MainViewModel {
	weak var collectionDelegate: UICollectionViewDelegate?
	let colletionDataSource: UICollectionViewDataSource
}

final class Item: Hashable {

	// MARK: - Private properties

	let identifier = UUID()
	let title: String
	let subtitle: String
	let albumImage: UIImage

	// MARK: - Init

	init(title: String, subtitle: String, albumImage: UIImage) {
		self.title = title
		self.subtitle = subtitle
		self.albumImage = albumImage
	}

	// MARK: - Hashable

	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}

	static func == (lhs: Item, rhs: Item) -> Bool {
		lhs.identifier == rhs.identifier
	}
}

final class PopularCollectionViewCell: UICollectionViewCell {
	static let id = "PopularCollectionViewCellIdentifier"
}

final class SharedAlbumsCollectionViewCell: UICollectionViewCell {
	static let id = "SharedAlbumsCollectionViewCellIdentifier"
}

/// Изображение главного экрана
final class MainView: UIView {

	static let sectionHeaderElementKind = "section-header-element-kind"

	enum Section: String, CaseIterable {
		case popularNewRe = "Featured Albums"
		case sharedAlbums = "Shared Albums"
		case myAlbums = "My Albums"
	}

	// MARK: - Private properties

	private let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

	private let headerView: MainHeaderView = {
		let view = MainHeaderView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private lazy var collectionView: UICollectionView = {
		let layout = createLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .orange
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.id)
		collectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.id)
		collectionView.register(SharedAlbumsCollectionViewCell.self, forCellWithReuseIdentifier: SharedAlbumsCollectionViewCell.id)
		collectionView.register(HeaderView.self,
								forSupplementaryViewOfKind: MainView.sectionHeaderElementKind,
								withReuseIdentifier: HeaderView.reuseIdentifier)
		return collectionView
	}()

	// MARK: - Init

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setupUI()
		configureDataSource()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with model: MainViewModel) {
		collectionView.delegate = model.collectionDelegate
		collectionView.dataSource = model.colletionDataSource
	}

	// MARK: - Private functions

	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
			collectionView, indexPath, item -> UICollectionViewCell? in

			let sectionType = Section.allCases[indexPath.section]
			switch sectionType {
			case .myAlbums:
				guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.id,
																		for: indexPath) as? AlbumCollectionViewCell else {
					fatalError("Could not create new cell")
				}
				mainCell.configure(item: item)
				return mainCell

			case .popularNewRe:
					guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.id,
																			for: indexPath) as? PopularCollectionViewCell else {
						fatalError("Could not create new cell")
					}
//					mainCell.configure(item: item)
					return mainCell

			case .sharedAlbums:
					guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: SharedAlbumsCollectionViewCell.id,
																			for: indexPath) as? SharedAlbumsCollectionViewCell else {
						fatalError("Could not create new cell")
					}
//					mainCell.configure(item: item)
					return mainCell
			}
		}

		dataSource?.supplementaryViewProvider = {
			collectionView, kind, indexPath -> UICollectionReusableView? in
			guard let sumplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																						  withReuseIdentifier: HeaderView.reuseIdentifier,
																						  for: indexPath) as? HeaderView
			else { fatalError("Cannot Create HeaderView") }
			sumplementaryView.configure(labelText: Section.allCases[indexPath.section].rawValue)
			return sumplementaryView
		}
		let snapshot = snapshotForCurrentState()
		dataSource?.apply(snapshot, animatingDifferences: true)
	}

//	private func configureCell(cell: UICollectionViewCell.Type, item: Item, id: String, indexPath: IndexPath) -> UICollectionViewCell {
//		let mainCell =
//
//	}

	private func setupUI() {
		addSubview(containerView)
		[headerView, collectionView].forEach { containerView.addSubview($0) }

		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			containerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
			containerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
			containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

			headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
			headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
			headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
			headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),

			collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
			collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		])
	}

	private func createLayout() -> UICollectionViewLayout {
		UICollectionViewCompositionalLayout { sectionNumber, layoutEnvironment -> NSCollectionLayoutSection? in
			let sectionType = Section.allCases[sectionNumber]
			let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500

			switch sectionType {
			case .sharedAlbums:
				return self.albumLayout(isWide: isWideView)

			case .popularNewRe:
				return self.albumLayout(isWide: isWideView)

			case .myAlbums:
				return self.albumLayout(isWide: isWideView)
			}
		}
	}

	private func albumLayout(isWide: Bool) -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											  heightDimension: .fractionalWidth(2 / 3))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)

		// Show one item plus peek on narrow screens, two items plus peek on wider screens
		let groupFractionalWidth = isWide ? 0.475 : 0.95
		let groupFractionalHeight: Float = isWide ? 1 / 3 : 2 / 3
		let groupSize = NSCollectionLayoutSize(
		  widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
		  heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

		let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												heightDimension: .estimated(44))
		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
																		elementKind: MainView.sectionHeaderElementKind,
																		alignment: .top)

		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [sectionHeader]
		section.orthogonalScrollingBehavior = .groupPaging

		return section
	}

	private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
		let image = UIImage(named: "moon")!
		let item = Item(title: "Teta", subtitle: "Subtitle", albumImage: image)
		let secontItem = Item(title: "Secont", subtitle: "sub", albumImage: image)
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([Section.popularNewRe])
		snapshot.appendSections([Section.sharedAlbums])
		snapshot.appendSections([Section.myAlbums])
		snapshot.appendItems([item, secontItem])
		return snapshot
	}
}
