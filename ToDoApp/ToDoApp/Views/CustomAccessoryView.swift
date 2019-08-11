//
//  CustomAccessoryView.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 10/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CustomAccessoryView: UIView {
    
    fileprivate let currentDate = Date()
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = currentDate
        picker.minimumDate = currentDate
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var dateView: UIView = {
        let v = UIView()
        
        let label = UILabel()
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 24)
        label.text = "When?"
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-forward-50 (1)").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        v.addSubview(button)
        v.addSubview(label)
        v.addSubview(datePicker)
        
        button.addSize(size: .init(width: 50, height: 50))
        button.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
        label.addContstraints(leading: v.leadingAnchor, top: v.topAnchor, trailing: button.leadingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 40))
        datePicker.addContstraints(leading: v.leadingAnchor, top: label.bottomAnchor, trailing: button.leadingAnchor, bottom: v.bottomAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        v.clipsToBounds = true
        
        return v
    }()
    
    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = currentDate
        picker.minimumDate = currentDate
        picker.datePickerMode = .time
        return picker
    }()
    
    lazy var timeView: UIView = {
        let v = UIView()
        
        let label = UILabel()
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 24)
        label.text = "What time?"
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.tag = 1
        
        v.addSubview(button)
        v.addSubview(label)
        v.addSubview(timePicker)
        button.addSize(size: .init(width: 50, height: 50))
        button.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        label.addContstraints(leading: button.trailingAnchor, top: v.topAnchor, trailing: v.trailingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 40))
        timePicker.addContstraints(leading: button.trailingAnchor, top: label.bottomAnchor, trailing: v.trailingAnchor, bottom: v.bottomAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        v.clipsToBounds = true
        
        return v
    }()
    
    var anchored: AnchoredConstraints!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        dateView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        timeView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
        addSubview(dateView)
        addSubview(timeView)
        anchored = dateView.addContstraints(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        timeView.addContstraints(leading: dateView.trailingAnchor, top: dateView.topAnchor, trailing: nil, bottom: dateView.bottomAnchor, size: .init(width: frame.width, height: 0))
        datePicker.addTarget(self, action: #selector(handleDate), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(handleTime), for: .valueChanged)
    }
    
    @objc fileprivate func handleTime(sender: UIDatePicker) {
        NotificationCenter.default.post(name: .timePicker, object: sender.date)
    }
    
    @objc fileprivate func handleDate(sender: UIDatePicker) {
        timePicker.minimumDate = sender.date
        NotificationCenter.default.post(name: .datePicker, object: sender.date)
    }
    
    @objc func handleTap(sender: UIButton) {
        if sender.tag == 0 {
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
