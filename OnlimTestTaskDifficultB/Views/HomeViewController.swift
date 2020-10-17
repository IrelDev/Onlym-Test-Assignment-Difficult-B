//
//  HomeViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 16.10.2020.
//

import UIKit

class HomeViewController: UIViewController {
    var homeModel: HomeModel?
    
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
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLaunchHandler()
        
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bannersCollectionView.collectionViewLayout.invalidateLayout()
    }
    func firstLaunchHandler() {
        let flag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: flag)
        
        let coreDataService = CoreDataService()
        if isFirstLaunch {
            guard let url = URL(string: "https://onlym.ru/api_test/test.json") else { return }
            let dataFetcherService = DataFetcherService()
            
            dataFetcherService.fetchDataFromURl(url: url) { [self] (response: HomeModel?, data: Data?) in
                if let response = response {
                    homeModel = response
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        coreDataService.saveHomeModelData(data: data as NSData)
                    }
                    
                    UserDefaults.standard.set(true, forKey: flag)
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        bannersCollectionView.reloadData()
                        articleTableView.reloadData()
                    }
                } else {
                    let alert = UIAlertController(title: "Что-то сломалось", message: "Произошла ошибка. Проверьте, есть ли подключение к интернету", preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Попробовать еще раз", style: .default) { _ in
                        firstLaunchHandler()
                    }
                    let cancelAction = UIAlertAction(title: "Выйти", style: .destructive) { _ in
                        exit(0);
                    }
                    
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                let data = coreDataService.fetchHomeModelData()
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                
                let coreDataHomeModel = try? jsonDecoder.decode(HomeModel.self, from: data! as Data)
                guard coreDataHomeModel != nil else { return }
                self.homeModel = coreDataHomeModel
                
                self.bannersCollectionView.reloadData()
                self.articleTableView.reloadData()
            }
        }
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
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    @objc func addNavigationBarButtonTapped() {
        let newBannerViewController = NewBannerViewController()
        navigationController?.pushViewController(newBannerViewController, animated: true)
        newBannerViewController.onSaveClosure = {
            self.bannersCollectionView.reloadData()
            self.articleTableView.reloadData()
        }
    }
}
// MARK: - UITableViewExtensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeModel = homeModel else { return 0 }
        return homeModel.articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlesTableViewCell", for: indexPath as IndexPath) as! ArticleTableViewCell
        guard let article = homeModel?.articles[indexPath.row] else { return UITableViewCell() }
        cell.setupCellData(article: article)
        
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
// MARK: - UICollectionViewExtensions
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let homeModel = homeModel else { return 0 }
        return homeModel.banners.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannersCollectionViewCell", for: indexPath as IndexPath) as! BannerCollectionViewCell
        guard let banner = homeModel?.banners[indexPath.row] else { return UICollectionViewCell() }
        cell.setupCellData(banner: banner)
        return cell
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: bannersCollectionView.bounds.width - 10, height: bannersCollectionView.bounds.height - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
