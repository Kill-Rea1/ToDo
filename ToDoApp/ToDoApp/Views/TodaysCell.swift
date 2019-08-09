//
//  TodaysCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class TodaysCell: BaseCollectionCell {
    
    public let todayController = TodayController()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .red
        addSubview(todayController.view)
        todayController.view.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
}
