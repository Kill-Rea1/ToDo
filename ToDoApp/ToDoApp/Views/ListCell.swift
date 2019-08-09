//
//  ListCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListCell: BaseCollectionCell {
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 20)
        return label
    }()
    
    fileprivate let descrtiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1 task"
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        clipsToBounds = true
        layer.cornerRadius = 14
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, descrtiptionLabel
            ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
    }
}
