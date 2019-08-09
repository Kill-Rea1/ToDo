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
    
    let taskTextView: UITextField = {
        let tf = UITextField()
        tf.text = "qermwefpo"
        tf.font = UIFont(name: CustomFont.regular.rawValue, size: 20)
        tf.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        tf.autocorrectionType = .no
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        setupView()
    }
    
    fileprivate func setupView() {
        let stackView = UIStackView(arrangedSubviews: [checkBoxButton, taskTextView])
        stackView.alignment = .top
        stackView.autoresizingMask = .flexibleHeight
        stackView.spacing = 8
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
    
    fileprivate func createToolBar() {
        let accessoryView = CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 115))
        taskTextView.inputAccessoryView = accessoryView
    }
}
