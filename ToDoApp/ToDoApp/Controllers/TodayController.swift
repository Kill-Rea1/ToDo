//
//  TodayController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class TodayController: BaseCollectionController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let todayCellId = "todayCell"
    fileprivate let longTask = "REALLY LONG TASK WHICH WOULD BREAK MY AUTO SIZING MAY BE I BELIVE IT WON'T HAPPEN"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: todayCellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayCellId, for: indexPath) as! TodayCell
        if indexPath.item == 1 {
            cell.taskLabel.text = longTask
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = TodayCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        if indexPath.item == 1 {
            dummyCell.taskLabel.text = longTask
        }
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        let height = estimatedSize.height
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
