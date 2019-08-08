//
//  ViewController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 08/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let todaysCellId = "todaysCell"
    fileprivate let listsCellId = "listsCell"
    fileprivate let padding: CGFloat = 16
    
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.font = UIFont(name: CustomFont.semibold.rawValue, size: 34)
        label.text = "Today"
        label.backgroundColor = .white
        view.addSubview(label)
        label.addContstraints(leading: view.leadingAnchor, top: nil, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: padding * 4, bottom: padding, right: 0))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
    }
    
    fileprivate func setupViews() {
        view.addSubview(topView)
        topView.addContstraints(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, padding: .init(top: 0, left: 0, bottom: -(padding * 5), right: 0))
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TodaysCell.self, forCellWithReuseIdentifier: todaysCellId)
        collectionView.register(ListsCell.self, forCellWithReuseIdentifier: listsCellId)
        collectionView.delaysContentTouches = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: padding * 5, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todaysCellId, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listsCellId, for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - padding * 2
        let height: CGFloat = indexPath.item == 0 ? 250 : 500
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding, left: padding, bottom: padding, right: padding)
    }
}

