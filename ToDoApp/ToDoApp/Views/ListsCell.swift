//
//  ListCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListsCell: BaseCollectionCell {
    
    fileprivate let padding: CGFloat = 16
    public var items = 0
    fileprivate let listsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 22)
        label.text = "Lists"
        label.textColor = .lightGray
        return label
    }()
    
    public let listController = ListController()
    
    override func setupViews() {
        super.setupViews()
        addSubview(listsLabel)
        listsLabel.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: nil, padding: .init(top: padding / 2, left: padding * 4, bottom: 0, right: padding), size: .init(width: 0, height: 30))
        addSubview(listController.view)
        listController.view.addContstraints(leading: leadingAnchor, top: listsLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: padding, left: padding * 4, bottom: 0, right: 0))
    }
}
