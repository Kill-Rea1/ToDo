//
//  ListFullscreenController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 09/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

protocol ListFullscreenControllerDelegate: class {
    func didSizeToMini()
}

class ListFullscreenController: UIViewController {
    
    public var list: List! {
        didSet {
            guard let list = list else { return }
            headerView.headerLabel.text = list.name
            headerView.backgroundColor = list.color
            view.backgroundColor = list.color
            tableView.backgroundColor = list.color
        }
    }
    
    fileprivate var tasks = [Task]() {
        didSet {
            let count = list.tasks?.count ?? 0
            headerView.descriptionLabel.text = count == 1 ? "\(count) Task" : "\(count) Tasks"
        }
    }
    fileprivate let listCellId = "listCell"
    public let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    weak var delegate: ListFullscreenControllerDelegate?
    public let headerView = HeaderView()
    fileprivate lazy var cav = CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 115))
    fileprivate var selectedDate: String!
    fileprivate var selectedTime: String!
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButtons()
        setupDefaultTime()
        setupNotifications()
        fetchTasks()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func fetchTasks() {
        tasks = []
        guard var tasks = list.tasks?.allObjects as? [Task] else { return }
        tasks.sort { (task1, task2) -> Bool in
            guard let date1 = task1.date, let date2 = task2.date else { return true }
            return date1 < date2
        }
        self.tasks = tasks
    }
    
    fileprivate func setupDefaultTime() {
        let currentDate = Date()
        turnDateToString(date: currentDate, format: "MMMM dd yyyy")
        turnDateToString(date: currentDate, format: "HH:mm")
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDatePicked), name: .datePicker, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimePicked), name: .timePicker, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc fileprivate func handleDatePicked(notification: Notification) {
        guard let date = notification.object as? Date else { return }
        turnDateToString(date: date, format: "MMMM dd yyyy")
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
        dateFormatter.dateFormat = "MMMM dd yyyy, HH:mm"
        let string = date + ", " + time
        guard let date = dateFormatter.date(from: string) else { return Date() }
        return date
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.addContstraints(leading: view.leadingAnchor, top: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
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
        tableView.keyboardDismissMode = .interactive
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
            cell.backgroundColor = list.color
        } else {
            let task = tasks[indexPath.row]
            cell.isTaskCell = true
            cell.task = task
        }
        cell.checkBoxButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc fileprivate func handleButtonTapped(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        if indexPath.row == tasks.count {
            didAddNewTask()
        } else {
            didCheckedTask(indexPath: indexPath)
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
        let indexPath = IndexPath(row: (tasks.count), section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListFullscreenCell else { return }
        
        guard let taskText = textField.text else { return }
        if taskText.isEmpty {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        } else {
            let date = getDate(date: selectedDate, time: selectedTime)
            cell.isTaskCell = true
            saveTask(taskText: taskText, date: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, HH:mm"
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        cell.taskTextField.isEnabled = false
    }
    
    fileprivate func saveTask(taskText: String, date: Date) {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: CoreDataManager.shared.persistentContainer.viewContext)
        task.setValue(taskText, forKey: "task")
        task.setValue(date, forKey: "date")
        task.setValue(list, forKey: "list")
        task.setValue(list.colorAsHex, forKey: "colorAsHex")
        task.setValue(false, forKey: "isDone")
        CoreDataManager.shared.saveTask(task as! Task) { [weak self] (err) in
            if err != nil {
                return
            }
            self?.addNewCell(newTask: task as! Task)
        }
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
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
    }
    
    func didCheckedTask(indexPath: IndexPath) {
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
        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
        let task = tasks[indexPath.row]
        task.isDone = !task.isDone
        CoreDataManager.shared.saveChanges()
    }
}
