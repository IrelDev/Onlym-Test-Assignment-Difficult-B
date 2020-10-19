//
//  NewBannerViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 17.10.2020.
//

import UIKit

class NewBannerViewController: UIViewController {
    var onSaveClosure: ((BannerModel, Int) -> Void)?
    var banner = BannerModel(name: "", color: "#ffffff", active: true)
    
    private let newBannerLabel: UILabel = {
        let newBannerLabel = UILabel()
        newBannerLabel.font = newBannerLabel.font.withSize(30)
        newBannerLabel.text = "Новый Баннер"
        newBannerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return newBannerLabel
    }()
    private let textFieldStackView: UIStackView = {
        let textFieldStackView = UIStackView()
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 10
        
        return textFieldStackView
    }()
    private let textFieldLabel: UILabel = {
        let textFieldLabel = UILabel()
        textFieldLabel.text = "Название Баннера"
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldLabel
    }()
    
    let bottomLine = CALayer()
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let colorStackView: UIStackView = {
        let colorStackView = UIStackView()
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.axis = .vertical
        colorStackView.spacing = 10
        
        return colorStackView
    }()
    let colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = "Цвет Баннера"
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    let colorSegmentedControl: UISegmentedControl = {
        let items = ["Белый", "Синий", "Зеленый"]
        
        let colorSegmentedControl = UISegmentedControl(items: items)
        colorSegmentedControl.selectedSegmentIndex = 0
        
        colorSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        colorSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return colorSegmentedControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        
        textField.delegate = self
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
        
        bottomLine.frame = CGRect(x: 0.0, y: textField.bounds.height - 1, width: textFieldStackView.bounds.width, height: 1.0)
    }
    func setupViews() {
        view.addSubview(newBannerLabel)
        
        bottomLine.backgroundColor = UIColor.label.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
        
        textFieldStackView.addArrangedSubview(textFieldLabel)
        textFieldStackView.addArrangedSubview(textField)
        
        view.addSubview(textFieldStackView)
        
        colorStackView.addArrangedSubview(colorLabel)
        colorStackView.addArrangedSubview(colorSegmentedControl)
        
        view.addSubview(colorStackView)
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            newBannerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newBannerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newBannerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: newBannerLabel.bottomAnchor, constant: 10),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            colorStackView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 10),
            colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        banner.name = text
    }
    @objc func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            banner.color = "#ffffff"
        case 1:
            banner.color = "#0000ff"
        case 2:
            banner.color = "#00ff00"
        default:
            break
        }
    }
    @objc func doneButtonTapped() {
        guard let onSaveClosure = onSaveClosure, banner.name != "" else { dismiss(animated: true); return; }
        onSaveClosure(banner, 0)
        dismiss(animated: true)
    }
}
extension NewBannerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
