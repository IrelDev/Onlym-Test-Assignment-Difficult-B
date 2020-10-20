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
    private let plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.label, for: .normal)
        plusButton.titleLabel?.font = plusButton.titleLabel?.font.withSize(40)
        plusButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        return plusButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    func setupViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(plusButton)
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(editButtonAction))
    }
    @objc func addButtonTapped() {
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
    @objc func editButtonAction() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.isEditing.toggle()
            if self.tableView.isEditing {
                self.navigationItem.rightBarButtonItem?.title = "Закончить"
            } else {
                self.navigationItem.rightBarButtonItem?.title = "Изменить"
            }
        }
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let movedObject = banners?[sourceIndexPath.row] else { return }
        
        self.banners?.remove(at: sourceIndexPath.row)
        self.banners?.insert(movedObject, at: destinationIndexPath.row)
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
