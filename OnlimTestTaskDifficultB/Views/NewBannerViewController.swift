//
//  NewBannerViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 17.10.2020.
//

import UIKit

class NewBannerViewController: UIViewController {
    var onSaveClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupNavigationBar()
    
    }
    func setupViews() {
    
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
    }
    @objc func doneButtonTapped() {
        
    }
}
