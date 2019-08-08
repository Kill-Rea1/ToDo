//
//  ListCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 20)
        return label
    }()
    
    fileprivate let descrtiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1 task"
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 14)
        label.textColor = .darkGray
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.cornerRadius = 14
        setupViews()
    }
    
    fileprivate func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, descrtiptionLabel
            ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
