//
//  ListController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ListControllerDelegate: class {
    func didSelectList(at position: CGRect, selectedList: List)
    func didDeleteList()
}

class ListController: BaseCollectionController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "listCell"
    public var lists = [List]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var startingFrame: CGRect!
    weak var delegate: ListControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = false
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longGesture)
    }
    
    @objc fileprivate func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let pressLocation = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: pressLocation) else { return }
        let alertController = UIAlertController(title: "Remove List?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let selectedList = self.lists[indexPath.item]
            CoreDataManager.shared.deleteList(selectedList, completion: { [weak self] (err) in
                if err != nil {
                    return
                }
                self?.lists.remove(at: indexPath.item)
                self?.delegate?.didDeleteList()
            })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListCell
        cell.list = lists[indexPath.item]
        return cell
    }
    
    fileprivate func startingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        startingCellFrame(indexPath)
        let selectedList = lists[indexPath.item]
        delegate?.didSelectList(at: startingFrame, selectedList: selectedList)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
}
