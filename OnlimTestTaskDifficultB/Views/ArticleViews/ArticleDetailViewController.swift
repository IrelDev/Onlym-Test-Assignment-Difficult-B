//
//  ArticleDetailViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 17.10.2020.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    var articles: [ArticleModel]?
    var indexPath: IndexPath?
    
    private let stackView: UIStackView = {
        let uiStackView = UIStackView()
        uiStackView.axis = .vertical
        
        uiStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return uiStackView
    }()
    private let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        let image = UIImage(systemName: "heart.fill")
        photoImageView.image = image
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return photoImageView
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    private let scrollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    private let tableView: IntrinsicTableView = {
        let tableView = IntrinsicTableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .secondarySystemGroupedBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupViews()
        setupAutoLayout()
    }
    override func viewDidLayoutSubviews() {
        let contentRect: CGRect = scrollStackView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: contentRect.size.width, height: contentRect.size.height + tableView.contentSize.height)
    }
    func setupViews() {
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(scrollView)
        
        scrollStackView.addArrangedSubview(titlelabel)
        scrollStackView.addArrangedSubview(descriptionTextlabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articlesTableViewCell")
        
        scrollView.addSubview(scrollStackView)
        scrollView.addSubview(tableView)
        
        view.addSubview(stackView)
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        photoImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.3).isActive = true
        
        NSLayoutConstraint.activate([
            scrollStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            scrollStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: scrollStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollStackView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: descriptionTextlabel.bottomAnchor)
        ])
    }
    func setData(article: ArticleModel, articles: [ArticleModel], indexPath: IndexPath) {
        titlelabel.text = "Статья \(article.title)"
        descriptionTextlabel.text = article.text
        var remainedArticles = articles
        remainedArticles.remove(at: indexPath.row)
        
        self.articles = remainedArticles
        title = "Статья \(articles[indexPath.row].title)"
    }
}
extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let otherArticles = articles else { return 0 }
        return otherArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlesTableViewCell", for: indexPath as IndexPath) as! ArticleTableViewCell
        guard let article = articles?[indexPath.row] else { return UITableViewCell() }
        cell.setupCellData(article: article)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailViewController = ArticleDetailViewController()
        guard let article = articles?[indexPath.row] else { return }
        
        articleDetailViewController.setData(article: article, articles: articles!, indexPath: indexPath)
        
        navigationController?.pushViewController(articleDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard articles != nil && !articles!.isEmpty else { return UIView() }
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.font = label.font.withSize(25)
        
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "Рекомендуемые статьи"
        headerView.addSubview(label)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard articles != nil && !articles!.isEmpty else { return 0 }
        return 50
    }
}
