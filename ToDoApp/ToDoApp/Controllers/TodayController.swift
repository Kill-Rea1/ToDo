//
//  TodayController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

//protocol TodayControllerDelegate: AnyObject {
//    func didChecked()
//}

class TodayController: BaseCollectionController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let todayCellId = "todayCell"
    public var tasks = [Task]() {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: todayCellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayCellId, for: indexPath) as! TodayCell
        cell.task = tasks[indexPath.item]
        cell.checkBoxButton.addTarget(self, action: #selector(handleCellButton), for: .touchUpInside)
        return cell
    }
    
    @objc fileprivate func handleCellButton(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        didSelectTaskAt(indexPath)
    }
    
    fileprivate func didSelectTaskAt(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TodayCell else { return }
        let task = tasks[indexPath.item]
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.taskLabel.text ?? "")
        var newImage = #imageLiteral(resourceName: "unchecked")
        if !task.isDone {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            newImage = #imageLiteral(resourceName: "checked")
        }
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.duration = 0.3
        cell.taskLabel.attributedText = attributeString
        cell.taskLabel.layer.add(transition, forKey: kCATransition)
        cell.checkBoxButton.setImage(newImage, for: .normal)
        task.isDone = !task.isDone
        CoreDataManager.shared.saveChanges()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = TodayCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        dummyCell.task = tasks[indexPath.row]
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        let height = estimatedSize.height
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
