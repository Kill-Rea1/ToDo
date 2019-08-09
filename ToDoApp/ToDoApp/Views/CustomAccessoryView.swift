//
//  CustomAccessoryView.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 10/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CustomAccessoryView: UIView {
    
    let dateView: UIView = {
        let v = UIView()
        
        let label = UILabel()
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 24)
        label.text = "When?"
        
        let time = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        time.date = Date()
        time.minimumDate = Date()
        time.datePickerMode = .date
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-forward-50 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        v.addSubview(button)
        v.addSubview(label)
        v.addSubview(time)
        
        button.addSize(size: .init(width: 50, height: 50))
        button.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
        label.addContstraints(leading: v.leadingAnchor, top: v.topAnchor, trailing: button.leadingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 40))
        
        time.addContstraints(leading: v.leadingAnchor, top: label.bottomAnchor, trailing: button.leadingAnchor, bottom: v.bottomAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        v.clipsToBounds = true
        
        return v
    }()
    
    let timeView: UIView = {
        let v = UIView()
        
        let label = UILabel()
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 24)
        label.text = "What time?"
        
        let time = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        time.date = Date()
        time.minimumDate = Date()
        time.datePickerMode = .time
        time.locale = Locale(identifier: "ru")
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.tag = 1
        
        v.addSubview(button)
        v.addSubview(label)
        v.addSubview(time)
        button.addSize(size: .init(width: 50, height: 50))
        button.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        label.addContstraints(leading: button.trailingAnchor, top: v.topAnchor, trailing: v.trailingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 40))
        
        time.addContstraints(leading: button.trailingAnchor, top: label.bottomAnchor, trailing: v.trailingAnchor, bottom: v.bottomAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        v.clipsToBounds = true
        
        return v
    }()
    
    var anchored: AnchoredConstraints!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        dateView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        timeView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        addSubview(dateView)
        addSubview(timeView)
        anchored = dateView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        timeView.addContstraints(leading: dateView.trailingAnchor, top: dateView.topAnchor, trailing: nil, bottom: dateView.bottomAnchor, size: .init(width: frame.width, height: 0))
    }
    
    @objc func handleTap(sender: UIButton) {
        let tag = sender.tag
        
        if tag == 0 {
            UIView.animate(withDuration: 0.5) {
                self.anchored.leading?.constant = -self.frame.width
                self.anchored.trailing?.constant = -self.frame.width
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.anchored.leading?.constant = 0
                self.anchored.trailing?.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}
