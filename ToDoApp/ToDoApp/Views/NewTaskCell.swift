//
//  NewTaskCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class NewTaskCell: BaseCollectionCell, UITextViewDelegate {
    
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
        tv.autoresizingMask = .flexibleHeight
        return tv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        autoresizingMask = .flexibleHeight
        let stackView = UIStackView(arrangedSubviews: [checkBoxButton, taskTextView])
        stackView.alignment = .center
        stackView.spacing = 16
        contentView.addSubview(stackView)
        stackView.addContstraints(leading: contentView.leadingAnchor, top: contentView.topAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, padding: .init(top: 16, left: 0, bottom: 16, right: 16))
        
//        separatorView()
    }
    
    fileprivate func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addContstraints(leading: leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 60, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
}
