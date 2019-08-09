//
//  CustomAccessoryView.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 10/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CustomAccessoryView: UIView {
    
    let dateView = UIView()
    
    let timeView = UIView()
    var anchored: AnchoredConstraints!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        dateView.backgroundColor = .yellow
        timeView.backgroundColor = .blue
        addSubview(dateView)
        addSubview(timeView)
        anchored = dateView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        timeView.addContstraints(leading: dateView.trailingAnchor, top: dateView.topAnchor, trailing: nil, bottom: dateView.bottomAnchor, size: .init(width: frame.width, height: 0))
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let x = gesture.location(in: self).x
        
        if x > self.frame.width / 2 {
            UIView.animate(withDuration: 0.5) {
                self.anchored.leading?.constant = -self.frame.width
                self.anchored.trailing?.constant = -self.frame.width
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 14.0)
    }
}
