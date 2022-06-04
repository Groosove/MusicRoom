//
//  MainHeaderView.swift
//  MusicRoom
//
//  Created by Артур Лутфуллин on 15.03.2022.
//

import UIKit

/// Заголовк главного экрана
final class MainHeaderView: UIView {

	// MARK: - Private properties

	private let headerLabel: UILabel = {
		let label = UILabel()
		label.text = "Добрый вечер"
		label.font = UIFont.boldSystemFont(ofSize: 24 )
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let settingsButton: UIButton = {
		let settingsButton = UIButton(type: .custom)
		settingsButton.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
		settingsButton.tintColor = .white
		settingsButton.frame = CGRect(origin: .zero, size: CGSize(width: 48, height: 48))
		settingsButton.translatesAutoresizingMaskIntoConstraints = false
		return settingsButton
	}()

	private let historyButton: UIButton = {
		let historyButton = UIButton(type: .custom)
		historyButton.setImage(UIImage(named: "history")?.withRenderingMode(.alwaysTemplate), for: .normal)
		historyButton.tintColor = .white
		historyButton.frame = CGRect(origin: .zero, size: CGSize(width: 48, height: 48))
		historyButton.translatesAutoresizingMaskIntoConstraints = false
		return historyButton
	}()

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 10
		stackView.axis = .horizontal
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	// MARK: - Init

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("MusicRoom.MainHeaderView")
	}

	// MARK: - Private functions

	private func setupUI() {
		[historyButton, settingsButton].forEach { stackView.addArrangedSubview($0) }
		[headerLabel, stackView].forEach { addSubview($0) }

		NSLayoutConstraint.activate([
			headerLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 12),
			headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			headerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),

			stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -6),
			stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
			stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			stackView.leftAnchor.constraint(equalTo: headerLabel.rightAnchor, constant: 15)
		])
	}
}
