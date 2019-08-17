//
//  ListFullscreenCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListFullscreenCell: UITableViewCell {
    
    public var task: Task! {
        didSet {
            taskTextField.text = task.task
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, HH:mm"
            dateLabel.text = dateFormatter.string(from: task.date ?? Date())
            backgroundColor = task.color
            if task.isDone {
                checkBoxButton.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.task ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                taskTextField.attributedText = attributeString
            }
        }
    }
    
    public let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        button.tintColor = .white
        button.addSize(size: .init(width: 48, height: 48))
        return button
    }()
    
    public let taskTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: Montserrat.semibold.rawValue, size: 14)
        tf.isEnabled = false
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        return tf
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Montserrat.regular.rawValue, size: 12)
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
        
        let taskInfoStackView = UIStackView(arrangedSubviews: [taskTextField, dateLabel])
        taskInfoStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [
            checkBoxButton, taskInfoStackView
            ])
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
        checkBoxButton.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
