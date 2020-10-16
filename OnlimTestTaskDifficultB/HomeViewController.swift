//
//  HomeViewController.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 16.10.2020.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsNavigationBarTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavigationBarButtonTapped))
    }
    @objc func settingsNavigationBarTapped() {
        
    }
    @objc func addNavigationBarButtonTapped() {
        
    }
}

