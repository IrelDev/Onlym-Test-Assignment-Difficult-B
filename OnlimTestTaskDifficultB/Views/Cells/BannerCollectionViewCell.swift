//
//  BannerCollectionViewCell.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 16.10.2020.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    private var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    private var color: String = "" {
        didSet {
            backgroundColor = UIColor(color)
        }
    }
    var active: Bool = true
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = nameLabel.font.withSize(30)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.backgroundColor = .clear
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupCellData(name: String, color: String, active: Bool) {
        self.name = name
        self.color = color
        self.active = active
    }
    private func setupCell() {
        layer.cornerRadius = 25
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
