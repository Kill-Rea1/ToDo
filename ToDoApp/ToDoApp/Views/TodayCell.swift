//
//  TodayCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class TodayCell: BaseCollectionCell {
    
    public var task: Task! {
        didSet {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.task ?? "")
            taskLabel.text = task.task
            listIndicator.backgroundColor = task.color
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeLabel.text = "At \(dateFormatter.string(from: task.date ?? Date()))"
            checkBoxButton.tintColor = task.color
            if task.isDone {
                checkBoxButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            }
            taskLabel.attributedText = attributeString
        }
    }
    
    public let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        button.addSize(size: .init(width: 48, height: 48))
        return button
    }()
    
    public let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "TASK TEXT"
        label.numberOfLines = 0
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 18)
        return label
    }()
    
    fileprivate let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Montserrat.regular.rawValue, size: 16)
        return label
    }()
    
    fileprivate let listIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        view.addSize(size: .init(width: 15, height: 15))
        view.layer.cornerRadius = 7.5
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        let taskInfoStackView = UIStackView(arrangedSubviews: [taskLabel, timeLabel])
        taskInfoStackView.spacing = 4
        taskInfoStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [
            checkBoxButton, taskInfoStackView, listIndicator
            ])
        stackView.alignment = .center
        addSubview(stackView)
        stackView.spacing = 8
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 12, left: 8, bottom: 12, right: 16))
        separatorView()
    }
    
    override func prepareForReuse() {
        checkBoxButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
    }
    
    fileprivate func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addContstraints(leading: leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 64, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
}
