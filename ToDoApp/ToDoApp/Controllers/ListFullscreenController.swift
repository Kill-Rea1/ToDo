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
    
    struct Task {
        var task: String
        var date: Date
    }
    
    fileprivate let listCellId = "listCell"
    public let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    var delegate: ListFullscreenControllerDelegate?
    var tasks = [
        Task(task: "Task 1", date: Date()),
        Task(task: "Task 2", date: Date())
    ]
    public let headerView = HeaderView()
    fileprivate lazy var cav = CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 115))
    fileprivate var selectedDate: String!
    fileprivate var selectedTime: String!
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        setupTableView()
        setupButtons()
        setupDefaultTime()
        setupNotifications()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupDefaultTime() {
        let currentDate = Date()
        turnDateToString(date: currentDate, format: "dd MMMM")
        turnDateToString(date: currentDate, format: "HH:mm")
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDatePicked), name: .datePicker, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimePicked), name: .timePicker, object: nil)
    }
    
    @objc fileprivate func handleDatePicked(notification: Notification) {
        guard let date = notification.object as? Date else { return }
        turnDateToString(date: date, format: "dd MMMM")
    }
    
    @objc fileprivate func handleTimePicked(notification: Notification) {
        guard let time = notification.object as? Date else { return }
        turnDateToString(date: time, format: "HH:mm")
    }
    
    fileprivate func turnDateToString(date: Date, format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if format == "HH:mm" {
            selectedTime = dateFormatter.string(from: date)
        } else {
            selectedDate = dateFormatter.string(from: date)
        }
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func getDate(date: String, time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, HH:mm"
        let string = date + ", " + time
        guard let date = dateFormatter.date(from: string) else { return Date() }
        return date
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
    
    @objc fileprivate func handleClose(sender: UIButton) {
        sender.isHidden = true
        headerView.headerLabel.font = UIFont(name: Montserrat.semibold.rawValue, size: 20)
        headerView.descriptionLabel.font = UIFont(name: Montserrat.regular.rawValue, size: 16)
        delegate?.didSizeToMini()
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
        return tasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellId, for: indexPath) as! ListFullscreenCell
        if indexPath.row == tasks.count {
            cell.isTaskCell = false
        } else {
            cell.isTaskCell = true
            cell.taskTextField.text = tasks[indexPath.row].task
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, HH:mm"
            cell.dateLabel.text = dateFormatter.string(from: tasks[indexPath.row].date)
        }
        cell.checkBoxButton.tag = indexPath.row
        cell.checkBoxButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc fileprivate func handleButtonTapped(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        if indexPath.row == tasks.count {
            didAddNewTask()
        } else {
            didCheckedTask(row: indexPath.row)
            sender.isUserInteractionEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

extension ListFullscreenController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: tasks.count, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListFullscreenCell else { return }
        
        guard let taskText = textField.text else { return }
        if taskText.isEmpty {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        } else {
            let date = getDate(date: selectedDate, time: selectedTime)
            cell.isTaskCell = true
            let newTask = Task(task: taskText, date: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, HH:mm"
            cell.dateLabel.text = dateFormatter.string(from: newTask.date)
            addNewCell(newTask: newTask)
        }
        cell.taskTextField.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func didAddNewTask() {
        let indexPath = IndexPath(row: tasks.count, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListFullscreenCell else { return }
        
        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        cell.taskTextField.isEnabled = true
        cell.taskTextField.inputAccessoryView = cav
        cell.taskTextField.becomeFirstResponder()
        cell.taskTextField.delegate = self
    }
    
    func addNewCell(newTask: Task) {
        tasks.append(newTask)
        let indexPath = IndexPath(row: tasks.count, section: 0)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeCellFrom(indexPath)
        }
    }
    
    func removeCellFrom(_ indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
    }
}
