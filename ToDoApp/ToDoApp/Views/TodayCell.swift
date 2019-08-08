//
//  TodayCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class TodayCell: BaseCollectionCell {
    
    fileprivate let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-ok-50 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        button.widthConstraint(to: 48)
        return button
    }()
    
    fileprivate let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "TASK TEXT"
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 20)
        return label
    }()
    
    fileprivate let listIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        view.layer.cornerRadius = 32
        view.widthConstraint(to: 64)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        let stackView = UIStackView(arrangedSubviews: [
            checkBoxButton, taskLabel, listIndicator
            ])
        stackView.alignment = .center
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        separatorView()
    }
    
    fileprivate func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addContstraints(leading: leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 48, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
}
