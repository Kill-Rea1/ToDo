//
//  ListCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListsCell: UICollectionViewCell {
    
    fileprivate let listsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 20)
        label.text = "Lists"
        label.textColor = .lightGray
        return label
    }()
    
    fileprivate let listController = ListController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(listsLabel)
        listsLabel.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: .init(width: 0, height: 30))
        addSubview(listController.view)
        listController.view.addContstraints(leading: leadingAnchor, top: listsLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
