//
//  ListFullscreenCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListFullscreenCell: UITableViewCell {
    
    public let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        button.tintColor = .white
        button.addSize(size: .init(width: 48, height: 48))
        return button
    }()
    
    public var cav: CustomAccessoryView!
    
    public let taskTextField: UITextField = {
        let tf = UITextField()
        tf.text = "REALLY LONG TASK WHICH WOULD BREAK MY AUTO SIZING MAY BE I BELIVE IT WON'T HAPPEN"
        tf.font = UIFont(name: CustomFont.semibold.rawValue, size: 12)
        tf.isEnabled = false
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        return tf
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular.rawValue, size: 10)
        return label
    }()
    
    var isTaskCell: Bool = true {
        didSet {
            if !isTaskCell {
                checkBoxButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
                taskTextField.text = ""
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let taskDateStackView = UIStackView(arrangedSubviews: [taskTextField, dateLabel])
        taskDateStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [
            checkBoxButton, taskDateStackView
            ])
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
