//
//  AddListController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 12/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

class CustomTextField: UITextField {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

protocol AddListControllerDelegate: class {
    func didAddList(newList: List)
    func didDismiss()
}

class AddListController: UIViewController {
    
    fileprivate let colorCellId = "colorCell"
    fileprivate var selectedColorIndex = 0
    fileprivate let colorSet: [UIColor] = [#colorLiteral(red: 0.7131453753, green: 0.4719424248, blue: 0.998932898, alpha: 1), #colorLiteral(red: 1, green: 0.9040154815, blue: 0.3817251325, alpha: 1), #colorLiteral(red: 0.9550090432, green: 0.3695322275, blue: 0.4263010621, alpha: 1), #colorLiteral(red: 0.3783579469, green: 0.8703571558, blue: 0.6418835521, alpha: 1), #colorLiteral(red: 0.05490196078, green: 0.6039215686, blue: 0.6549019608, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.5411764706, blue: 0.4431372549, alpha: 1), #colorLiteral(red: 0.5215686275, green: 0.1176470588, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.6705882353, blue: 0.7137254902, alpha: 1), #colorLiteral(red: 0.2941176471, green: 0.5254901961, blue: 0.7058823529, alpha: 1)]
    weak var delegate: AddListControllerDelegate?
    
    fileprivate let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.addSubview(titleLabel)
        titleLabel.addContstraints(leading: v.leadingAnchor, top: v.topAnchor, trailing: v.trailingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 30))
        v.addSubview(listNameTextField)
        listNameTextField.addContstraints(leading: v.leadingAnchor, top: titleLabel.bottomAnchor, trailing: v.trailingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        v.addSubview(selectColorLabel)
        selectColorLabel.addContstraints(leading: v.leadingAnchor, top: listNameTextField.bottomAnchor, trailing: v.trailingAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 30))
        v.addSubview(colorCollectionView)
        colorCollectionView.addContstraints(leading: v.leadingAnchor, top: selectColorLabel.bottomAnchor, trailing: v.trailingAnchor, bottom: v.bottomAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 120))
        v.layer.cornerRadius = 14
        return v
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New List"
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 24)
        return label
    }()
    
    let selectColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the List Color"
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 20)
        return label
    }()
    
    let listNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.font = UIFont(name: Montserrat.regular.rawValue, size: 16)
        tf.placeholder = "Enter List Name"
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 25
        tf.returnKeyType = .done
        return tf
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-ok-100"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.0002782579104, green: 0.4252260029, blue: 0.9999930263, alpha: 1)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupNotifications()
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleShowKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - contentView.frame.origin.y - contentView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        if difference > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        }
    }
    
    @objc fileprivate func handleHideKeyboard() {
        view.transform = .identity
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(blurVisualEffect)
        blurVisualEffect.addContstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        view.addSubview(contentView)
        contentView.addContstraints(leading: view.leadingAnchor, top: nil, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 0))
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(saveButton)
        saveButton.addContstraints(leading: nil, top: nil, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 8), size: .init(width: 68, height: 68))
        blurVisualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        listNameTextField.delegate = self
    }
    
    fileprivate func setupCollectionView() {
        colorCollectionView.backgroundColor = .white
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: colorCellId)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        colorCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
    
    @objc fileprivate func handleDismiss() {
        view.endEditing(true)
    }
    
    @objc fileprivate func handleTap() {
        delegate?.didDismiss()
    }
    
    @objc fileprivate func handleSave() {
        guard let listName = listNameTextField.text, listName != "" else { return }
        let selectedColor = colorSet[selectedColorIndex]
        let list = NSEntityDescription.insertNewObject(forEntityName: "List", into: CoreDataManager.shared.persistentContainer.viewContext)
        list.setValue(listName, forKey: "name")
        list.setValue(selectedColor.toHex, forKey: "colorAsHex")
        CoreDataManager.shared.saveList(list as! List) { [weak self] (err) in
            if err != nil {
                return
            }
            self?.delegate?.didAddList(newList: list as! List)
        }
    }
}

extension AddListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellId, for: indexPath) as! ColorCell
        cell.color = colorSet[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColorIndex = indexPath.item
    }
}

extension AddListController: UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
        }
        return true
    }
}
