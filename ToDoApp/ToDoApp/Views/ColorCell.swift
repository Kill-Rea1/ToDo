//
//  ColorCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 12/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    var color: UIColor! {
        didSet {
            backgroundColor = color
        }
    }
    
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted {
//                layer.borderWidth = 2
//                layer.borderColor = UIColor.blue.cgColor
//            } else {
//                layer.borderWidth = 0
//                layer.borderColor = UIColor.clear.cgColor
//            }
//        }
//    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.height / 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
