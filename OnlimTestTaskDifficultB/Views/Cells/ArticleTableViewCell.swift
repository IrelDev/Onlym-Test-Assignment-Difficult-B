//
//  ArticleTableViewCell.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 16.10.2020.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    private var title: String = "" {
        didSet {
            titlelabel.text = title
        }
    }
    private var descriptionText: String = "" {
        didSet {
            descriptionTextlabel.text = descriptionText
        }
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        
        return stackView
    }()
    private let titlelabel: UILabel = {
        let titlelabel = UILabel()
        titlelabel.font = titlelabel.font.withSize(25)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        return titlelabel
    }()
    private let descriptionTextlabel: UILabel = {
        let descriptionTextlabel = UILabel()
        descriptionTextlabel.numberOfLines = 0
        descriptionTextlabel.font = descriptionTextlabel.font.withSize(20)
        descriptionTextlabel.textColor = .secondaryLabel
        descriptionTextlabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionTextlabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    private func setupCell() {        
        stackView.addArrangedSubview(titlelabel)
        stackView.addArrangedSubview(descriptionTextlabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 0.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 0.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 0.0),
        ])
    }
    func setupCellData(article: ArticleModel) {
        self.title = "Статья \(article.title)"
        self.descriptionText = article.text
    }
    
}
