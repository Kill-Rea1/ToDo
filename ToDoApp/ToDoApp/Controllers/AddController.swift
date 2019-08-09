//
//  AddController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol AddControllerDelegate {
    func dismiss()
}

class AddController: UIViewController {
    
    fileprivate let cellId = "cell"
    fileprivate let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    fileprivate let actionsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    var delegate: AddControllerDelegate?
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(blurVisualEffect)
        blurVisualEffect.addContstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        setupTableView()
        setupViews()
        setupTapGesture()
    }
    
    fileprivate func setupViews() {
        actionsView.addSubview(tableView)
        tableView.addContstraints(leading: actionsView.leadingAnchor, top: actionsView.topAnchor, trailing: actionsView.trailingAnchor, bottom: actionsView.bottomAnchor)
        view.addSubview(actionsView)
        actionsView.addContstraints(leading: nil, top: nil, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 108, right: 16), size: .init(width: 250, height: 139))
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = 70
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
    }
    
    fileprivate func setupTapGesture() {
        blurVisualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        delegate?.dismiss()
    }
}

extension AddController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Task"
            cell.imageView?.image = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        } else {
            cell.textLabel?.text = "List"
            cell.imageView?.image = #imageLiteral(resourceName: "Image").withRenderingMode(.alwaysTemplate)
        }
        cell.textLabel?.font = UIFont(name: CustomFont.semibold.rawValue, size: 20)
        cell.textLabel?.textColor = #colorLiteral(red: 0.0002782579104, green: 0.4252260029, blue: 0.9999930263, alpha: 1)
        cell.imageView?.tintColor = #colorLiteral(red: 0.0002782579104, green: 0.4252260029, blue: 0.9999930263, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let navController = UINavigationController(rootViewController: NewTaskController())
            delegate?.dismiss()
            present(navController, animated: true)
        } else {
            return
        }
    }
}
