//
//  HeaderView.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    public let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Inbox"
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 26)
        return label
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "1 task"
        label.font = UIFont(name: Montserrat.regular.rawValue, size: 20)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel, descriptionLabel
            ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        addSubview(stackView)
        stackView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
