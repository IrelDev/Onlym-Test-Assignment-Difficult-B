//
//  HomeViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 16.10.2020.
//

import UIKit

class HomeViewController: UIViewController {
    private let bannersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        
        let bannersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bannersCollectionView.isPagingEnabled = true
        bannersCollectionView.backgroundColor = .clear
        bannersCollectionView.showsHorizontalScrollIndicator = false
        
        return bannersCollectionView
    }()
    
    let articleTableView: UITableView = {
        let articleTableView = UITableView(frame: .zero, style: .insetGrouped)
        articleTableView.backgroundColor = .secondarySystemGroupedBackground
        
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        return articleTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsNavigationBarTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavigationBarButtonTapped))
    }
    func setupViews() {
        view.addSubview(bannersCollectionView)
        
        bannersCollectionView.delegate = self
        bannersCollectionView.dataSource = self
        bannersCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "bannersCollectionViewCell")
        
        view.addSubview(articleTableView)
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        articleTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articlesTableViewCell")
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            bannersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            bannersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bannersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bannersCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
        NSLayoutConstraint.activate([
            articleTableView.topAnchor.constraint(equalTo: bannersCollectionView.bottomAnchor, constant: 10),
            articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            articleTableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    @objc func settingsNavigationBarTapped() {
        
    }
    @objc func addNavigationBarButtonTapped() {
        
    }
}
// MARK: - UITableViewExtensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlesTableViewCell", for: indexPath as IndexPath) as! ArticleTableViewCell
        if indexPath.row == 2 {
            cell.setupCellData(title: "Title + \(indexPath.row)", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce fringilla arcu a ipsum iaculis placerat. Vestibulum quis interdum neque. Nullam diam dui, fermentum ut tempus venenatis, volutpat vitae leo. Nulla facilisi. Aliquam convallis id urna sed vestibulum. Nunc nec mauris eleifend, feugiat lacus vitae, consequat nisi. Suspendisse gravida, metus sed tincidunt fringilla, odio velit ornare augue, id dapibus neque odio in enim. Phasellus id felis purus. Proin porttitor eros eu arcu hendrerit venenatis. Nullam feugiat egestas tortor, vel sollicitudin ante ultricies eget. Nunc malesuada et nibh vel sollicitudin. \n Morbi dapibus, elit eget rhoncus consectetur, arcu dui dignissim turpis, ac convallis ante metus ut tortor. Nunc et hendrerit nibh, quis ornare sapien. Maecenas imperdiet eget tortor sagittis maximus. Duis augue sapien, commodo ac maximus vitae, gravida eget odio. Suspendisse iaculis leo et mi mollis vehicula. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam fringilla malesuada maximus. Etiam ultricies, neque ac tristique rhoncus, urna enim lobortis elit, porttitor dictum mauris enim ut libero. Sed augue velit, interdum faucibus lectus non, auctor mattis dolor. Fusce pellentesque ornare est sed ultrices. Suspendisse finibus mi fermentum turpis scelerisque, et mattis erat lacinia. Aenean augue urna, blandit eget aliquet ut, hendrerit nec quam.\n Phasellus aliquet porttitor eros, eu ullamcorper odio ultricies sit amet. Praesent placerat nibh quis nulla iaculis, eu maximus tortor ultricies. Vivamus et elit sed nulla porta ultricies ut blandit elit. Praesent molestie ac risus nec euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut eget elit quis ipsum accumsan dictum. Cras purus erat, faucibus in nisi non, tempor laoreet sapien.")
        } else {
            cell.setupCellData(title: "Title + \(indexPath.row)", text: "Hi bitch")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.font = label.font.withSize(30)
        
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "Заголовок"
        headerView.addSubview(label)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannersCollectionViewCell", for: indexPath as IndexPath) as! BannerCollectionViewCell
        cell.setupCellData(name: "Баннер", color: "#0000ff", active: true)
        return cell
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: bannersCollectionView.bounds.width - 10, height: bannersCollectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
