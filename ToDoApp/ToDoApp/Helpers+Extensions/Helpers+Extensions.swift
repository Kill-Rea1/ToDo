//
//  Helpers+Extensions.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
    @discardableResult
    func addContstraints(leading: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        var anchoredConstraints = AnchoredConstraints()
        translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.leading, anchoredConstraints.trailing, anchoredConstraints.top, anchoredConstraints.bottom, anchoredConstraints.width, anchoredConstraints.height].forEach({$0?.isActive = true})
        return anchoredConstraints
    }
    
    func addSize(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func widthConstraint(to constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func heightConstraint(to constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Notification.Name {
    static let datePicker = NSNotification.Name("datePicker")
    static let timePicker = NSNotification.Name("timePicker")
}

class BaseCollectionController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {}
}
