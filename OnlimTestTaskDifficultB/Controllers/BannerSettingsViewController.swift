//
//  SettingsViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 17.10.2020.
//

import UIKit

class BannerSettingsViewController: UIViewController {
    var banners: [BannerModel]?
    
    var onSaveClosure: (([BannerModel]) -> Void)?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    func setupViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavigationBarButtonTapped))
        title = "Настройки"
    }
    @objc func addNavigationBarButtonTapped() {
        let newBannerViewController = NewBannerViewController()
        newBannerViewController.modalPresentationStyle = .formSheet
        navigationController?.present(UINavigationController(rootViewController: newBannerViewController), animated: true)
        
        newBannerViewController.onSaveClosure = { banner, index in
            self.banners?.insert(banner, at: index)
            self.tableView.reloadData()
        }
    }
    @objc func doneButtonTapped() {
        guard let onSaveClosure = onSaveClosure, let banners = banners else { dismiss(animated: true); return; }
        onSaveClosure(banners)
        dismiss(animated: true)
    }
    func setData(banners: [BannerModel]) {
        self.banners = banners
    }
}
extension BannerSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let banners = banners else { return 0 }
        return banners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let banners = banners else { return UITableViewCell() }
        let banner = banners[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        
        let uiSwitch = UISwitch()
        uiSwitch.isOn = banner.active
        uiSwitch.tag = indexPath.row
        uiSwitch.addTarget(self, action: #selector(switchValueChanged(uiSwitch:)), for: .valueChanged)
        
        cell.accessoryView = uiSwitch
        cell.textLabel?.text = banner.name
        
        return cell
    }
    @objc func switchValueChanged(uiSwitch: UISwitch) {
        banners![uiSwitch.tag].active = uiSwitch.isOn
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.font = label.font.withSize(30)
        
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "Настройки"
        headerView.addSubview(label)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            banners?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
