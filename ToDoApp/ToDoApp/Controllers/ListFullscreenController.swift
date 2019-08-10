//
//  ListFullscreenController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ListFullscreenControllerDelegate {
    func didSizeToMini()
}

class ListFullscreenController: UIViewController {
    
    fileprivate let listCellId = "listCell"
    public let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    var delegate: ListFullscreenControllerDelegate?
    var items = 3
    public let headerView = HeaderView()
    fileprivate lazy var cav = CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 115))
    
    @objc fileprivate func handleClose(sender: UIButton) {
        sender.isHidden = true
        headerView.headerLabel.font = UIFont(name: CustomFont.semibold.rawValue, size: 20)
        headerView.descriptionLabel.font = UIFont(name: CustomFont.regular.rawValue, size: 16)
        delegate?.didSizeToMini()
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        setupTableView()
        setupButtons()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.addContstraints(leading: view.leadingAnchor, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        tableView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        tableView.register(ListFullscreenCell.self, forCellReuseIdentifier: listCellId)
        tableView.delaysContentTouches = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    fileprivate func setupButtons() {
        view.addSubview(closeButton)
        closeButton.addContstraints(leading: nil, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 58, height: 58))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
}

extension ListFullscreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellId, for: indexPath) as! ListFullscreenCell
        if indexPath.row == items - 1 {
            cell.isTaskCell = false
        }
        cell.checkBoxButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85
    }
}

extension ListFullscreenController: ListFullscreenCellDelegate,  UITextFieldDelegate {
    func didAddNewTask() {
        let indexPath = IndexPath(row: items - 1, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListFullscreenCell else { return }
        
        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        cell.taskTextField.isEnabled = true
        cell.taskTextField.inputAccessoryView = cav
        cell.taskTextField.becomeFirstResponder()
        cell.taskTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let isEmty = textField.text?.isEmpty else { return }
        let indexPath = IndexPath(row: items - 1, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListFullscreenCell else { return }
        if isEmty {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        } else {
            cell.isTaskCell = true
            addNewCell()
        }
        cell.taskTextField.isEnabled = false
    }
    
    func addNewCell() {
        let indexPath = IndexPath(row: items, section: 0)
        items += 1
        tableView.insertRows(at: [indexPath], with: .middle)
    }
    
    func didCheckedTask(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListFullscreenCell else { return }
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.taskTextField.text ?? "")
        cell.taskTextField.text = ""
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.duration = 0.3
        cell.taskTextField.attributedText = attributeString
        cell.taskTextField.layer.add(transition, forKey: kCATransition)
        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        cell.taskTextField.attributedText = attributeString
        cell.taskTextField.layer.add(transition, forKey: kCATransition)
        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeCellFrom(indexPath)
        }
    }
    
    func removeCellFrom(_ indexPath: IndexPath) {
        items -= 1
        tableView.deleteRows(at: [indexPath], with: .top)
        (0..<items).forEach { (i) in
            guard let cell = tableView.cellForRow(at: [i, 0]) as? ListFullscreenCell else { return }
            cell.checkBoxButton.tag = i
        }
    }
}
