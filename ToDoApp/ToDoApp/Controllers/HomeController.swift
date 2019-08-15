//
//  ViewController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var isAdding = false
    fileprivate var listFullscreen: ListFullscreenController!
    fileprivate var startingPosition: CGRect!
    fileprivate let todaysCellId = "todaysCell"
    fileprivate let listsCellId = "listsCell"
    fileprivate let padding: CGFloat = 16
    fileprivate var anchoredConstraints: AnchoredConstraints!
    fileprivate var addListController: AddListController!
    fileprivate var lists = [List]()
    fileprivate var todayTasks = [Task]()
    fileprivate let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.font = UIFont(name: Montserrat.semibold.rawValue, size: 34)
        label.text = "Today"
        label.backgroundColor = .white
        view.addSubview(label)
        label.addContstraints(leading: view.leadingAnchor, top: nil, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: padding * 4, bottom: 0, right: 0))
        return view
    }()
    
    fileprivate let addListButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-add-96"), for: .normal)
        button.addTarget(self, action: #selector(handleAddList), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.0002782579104, green: 0.4252260029, blue: 0.9999930263, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        fetchLists()
    }
    
    fileprivate func fetchLists() {
        DispatchQueue.global(qos: .background).async {
            self.lists = CoreDataManager.shared.fetchCompanies()
            self.fetchTodayTasks()
        }
    }
    
    fileprivate func fetchTodayTasks() {
        todayTasks = []
        DispatchQueue.global(qos: .background).async {
            let locale = Locale.current
            self.lists.forEach { (list) in
                if let tasks = list.tasks?.allObjects as? [Task] {
                    tasks.forEach({ (task) in
                        if let taskDate = task.date {
                            let relativeFormatter = self.buildFormatter(locale: locale, hasRelativeDate: true)
                            let relativeDateString = self.dateFormatterToString(relativeFormatter, taskDate)
                            if relativeDateString == "Today" {
                                self.todayTasks.append(task)
                            }
                        }
                    })
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func buildFormatter(locale: Locale, hasRelativeDate: Bool = false, dateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
        formatter.doesRelativeDateFormatting = hasRelativeDate
        formatter.locale = locale
        return formatter
    }
    
    func dateFormatterToString(_ formatter: DateFormatter, _ date: Date) -> String {
        return formatter.string(from: date)
    }
    
    @objc fileprivate func handleAddList(sender: UIButton) {
        if isAdding {
            hideAddController()
        } else {
            showAddController()
        }
    }
    
    fileprivate func showAddController() {
        isAdding = true
        addListController = AddListController()
        addListController.delegate = self
        addListController.view.alpha = 0
        view.addSubview(addListController.view)
        addChild(addListController)
        addListController.view.frame = view.frame
        UIView.animate(withDuration: 0.3, animations: {
            let angle = 45 * CGFloat.pi / 180
            self.addListButton.transform = CGAffineTransform(rotationAngle: angle)
            self.view.bringSubviewToFront(self.addListButton)
            self.addListController.view.alpha = 1
        })
    }
    
    fileprivate func hideAddController() {
        isAdding = false
        UIView.animate(withDuration: 0.3, animations: {
            self.addListController.view.alpha = 0
            self.addListButton.transform = .identity
        }) { (_) in
            self.addListController.view.removeFromSuperview()
            self.addListController.removeFromParent()
        }
    }
    
    fileprivate func setupViews() {
        view.addSubview(topView)
        topView.addContstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, padding: .init(top: 0, left: padding, bottom: -(padding * 5), right: 0))
        view.addSubview(addListButton)
        addListButton.addContstraints(leading: view.leadingAnchor, top: nil, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 8, bottom: 16, right: 0), size: .init(width: 68, height: 68))
        view.addSubview(blurVisualEffect)
        blurVisualEffect.addContstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        blurVisualEffect.alpha = 0
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TodaysCell.self, forCellWithReuseIdentifier: todaysCellId)
        collectionView.register(ListsCell.self, forCellWithReuseIdentifier: listsCellId)
        collectionView.delaysContentTouches = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = padding * 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todaysCellId, for: indexPath) as! TodaysCell
            cell.todayController.tasks = todayTasks
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listsCellId, for: indexPath) as! ListsCell
        cell.listController.lists = lists
        cell.listController.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - padding * 2
        var size: CGSize
        if indexPath.item == 0 {
            let dummyCell = TodaysCell(frame: .init(x: 0, y: 0, width: width, height: 1000))
            dummyCell.todayController.tasks = todayTasks
            size = dummyCell.todayController.collectionViewLayout.collectionViewContentSize
        } else {
            let dummyCell = ListsCell(frame: .init(x: 0, y: 0, width: width, height: 1500))
            dummyCell.listController.lists = lists
            size = dummyCell.listController.collectionViewLayout.collectionViewContentSize
            size.height += padding * 1.5 + 30
        }
        
        return .init(width: width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding, left: padding, bottom: padding, right: padding)
    }
}

extension HomeController: ListControllerDelegate, ListFullscreenControllerDelegate, UIGestureRecognizerDelegate {
    
    func didDeleteList() {
        fetchLists()
    }
    
    func didSelectList(at position: CGRect, selectedList: List) {
        startingPosition = position
        let listFullscreenView = setupListFullscreen(selectedList: selectedList)
        createFullscreen(listFullscreenView: listFullscreenView, position: position)
    }
    
    fileprivate func setupListFullscreen(selectedList: List) -> UIView {
        listFullscreen = ListFullscreenController()
        listFullscreen.list = selectedList
        listFullscreen.delegate = self
        guard let listFullscreenView = listFullscreen.view else { return UIView() }
        listFullscreenView.clipsToBounds = true
        listFullscreenView.layer.cornerRadius = 14
        view.addSubview(listFullscreenView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        listFullscreen.view.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        addChild(listFullscreen)
        return listFullscreenView
    }
    
    fileprivate func createFullscreen(listFullscreenView: UIView, position: CGRect) {
        anchoredConstraints = listFullscreenView.addContstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: nil, bottom: nil, padding: .init(top: position.origin.y, left: position.origin.x, bottom: 0, right: 0), size: .init(width: position.width, height: position.height))
        self.view.layoutIfNeeded()
        animate()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        var listFullscreenBeginOffset: CGFloat = 0
        if gesture.state == .began {
            listFullscreenBeginOffset = listFullscreen.tableView.contentOffset.y
        }
        if listFullscreen.tableView.contentOffset.y > 0 {
            return
        }
        let translationY = gesture.translation(in: listFullscreen.view).y
        if gesture.state == .changed {
            let trueOffset = translationY - listFullscreenBeginOffset
            var scale = min(1, 1 - trueOffset / 1000)
            listFullscreen.closeButton.alpha = scale * 0.9
            scale = max(0.6, scale)
            let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
            listFullscreen.view.transform = transform
            if translationY > 150 {
                gesture.state = .ended
            }
        } else if gesture.state == .ended {
            if translationY > 150 {
                didSizeToMini()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.listFullscreen.view.transform = .identity
                }
            }
        }
    }
    
    fileprivate func animate() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.listFullscreen.view.layer.cornerRadius = 0
            self.blurVisualEffect.alpha = 1
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        })
    }
    
    func didSizeToMini() {
        listFullscreen.view.endEditing(true)
        listFullscreen.view.layer.cornerRadius = 14
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.collectionView.isUserInteractionEnabled = false
            self.blurVisualEffect.alpha = 0
            self.listFullscreen.tableView.contentOffset = .zero
            self.listFullscreen.view.transform = .identity
            self.anchoredConstraints?.top?.constant = self.startingPosition.origin.y
            self.anchoredConstraints?.leading?.constant = self.startingPosition.origin.x
            self.anchoredConstraints?.width?.constant = self.startingPosition.width
            self.anchoredConstraints?.height?.constant = self.startingPosition.height
            self.view.layoutIfNeeded()
            self.listFullscreen.closeButton.alpha = 0
            self.listFullscreen.headerView.headerLabel.font = UIFont(name: Montserrat.semibold.rawValue, size: 20)
            self.listFullscreen.headerView.descriptionLabel.font = UIFont(name: Montserrat.regular.rawValue, size: 16)
        }) { (_) in
            self.listFullscreen.view.removeFromSuperview()
            self.listFullscreen.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
            self.collectionView.reloadData()
            self.fetchTodayTasks()
        }
    }
}

extension HomeController: AddListControllerDelegate {
    func didAddList(newList: List) {
        hideAddController()
        lists.append(newList)
        collectionView.reloadData()
        collectionView.scrollToItem(at: [0, 1], at: .bottom, animated: true)
    }
    
    func didDismiss() {
        hideAddController()
    }
}
