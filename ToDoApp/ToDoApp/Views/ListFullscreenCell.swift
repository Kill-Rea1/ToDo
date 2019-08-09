//
//  ListFullscreenCell.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ListFullscreenCell: UITableViewCell {
    
    fileprivate let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addSize(size: .init(width: 48, height: 48))
        return button
    }()
    
    public let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "REALLY LONG TASK WHICH WOULD BREAK MY AUTO SIZING MAY BE I BELIVE IT WON'T HAPPEN"
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let stackView = UIStackView(arrangedSubviews: [
            checkBoxButton, taskLabel
            ])
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        separatorView()
    }
    
    fileprivate func separatorView() {
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        separatorView.addContstraints(leading: leadingAnchor, top: nil, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 60, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
