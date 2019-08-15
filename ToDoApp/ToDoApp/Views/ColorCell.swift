//
//  ColorCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 12/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ColorCell: BaseCollectionCell {
    var color: UIColor! {
        didSet {
            backgroundColor = color
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.borderColor = UIColor.blue.cgColor
            } else {
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = frame.height / 2
    }
}
