//
//  ListFullscreenController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ListFullscreenControllerDelegate {
    func didSizeToMini()
}

class ListFullscreenController: UIViewController {
    
    fileprivate let listCellId = "listCell"
    fileprivate let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    var delegate: ListFullscreenControllerDelegate?
    fileprivate let headerView = HeaderView()
    
    @objc fileprivate func handleClose(sender: UIButton) {
        sender.isHidden = true
        headerView.headerLabel.font = UIFont(name: CustomFont.semibold.rawValue, size: 20)
        headerView.descriptionLabel.font = UIFont(name: CustomFont.regular.rawValue, size: 16)
        
        delegate?.didSizeToMini()
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.addContstraints(leading: view.leadingAnchor, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        tableView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        tableView.register(ListFullscreenCell.self, forCellReuseIdentifier: listCellId)
        tableView.delaysContentTouches = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    fileprivate func setupButtons() {
        view.addSubview(closeButton)
        closeButton.addContstraints(leading: nil, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 58, height: 58))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        setupTableView()
        setupButtons()
    }
}

extension ListFullscreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellId, for: indexPath) as! ListFullscreenCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

class HeaderView: UIView {
    
    fileprivate let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 28)
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1 task"
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 21)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel, descriptionLabel
            ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
