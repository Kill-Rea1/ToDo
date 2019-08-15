//
//  ListCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListCell: BaseCollectionCell {
    
    public var list: List! {
        didSet {
            titleLabel.text = list.name
            backgroundColor = list.color
            let count = list.tasks?.count ?? 0
            descrtiptionLabel.text = count == 1 ? "\(count) Task" : "\(count) Tasks"
        }
    }
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 20)
        return label
    }()
    
    fileprivate let descrtiptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1 task"
        label.font = UIFont(name: Montserrat.regular.rawValue, size: 16)
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
