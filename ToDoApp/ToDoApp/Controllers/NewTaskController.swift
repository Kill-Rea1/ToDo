//
//  NewTaskController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class NewTaskController: UIViewController {
    
    let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addSize(size: .init(width: 48, height: 48))
        return button
    }()
    
    let taskTextView: UITextView = {
        let tv = UITextView()
        tv.text = "qermwefpo"
        tv.font = UIFont(name: CustomFont.regular.rawValue, size: 20)
        tv.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        taskTextView.becomeFirstResponder()
        
        let stackView = UIStackView(arrangedSubviews: [checkBoxButton, taskTextView])
        stackView.alignment = .top
        stackView.autoresizingMask = .flexibleHeight
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.addContstraints(leading: view.leadingAnchor, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleDone() {
        dismiss(animated: true)
    }
}
