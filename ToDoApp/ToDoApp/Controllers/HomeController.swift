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
    fileprivate let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    fileprivate var anchoredConstraints: AnchoredConstraints!
    fileprivate let items = 5
    
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
        view.addSubview(addButton)
        addButton.addContstraints(leading: nil, top: nil, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 0, bottom: padding, right: padding), size: .init(width: 76, height: 76))
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TodaysCell.self, forCellWithReuseIdentifier: todaysCellId)
        collectionView.register(ListsCell.self, forCellWithReuseIdentifier: listsCellId)
        collectionView.delaysContentTouches = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = padding * 5
    }
    
    @objc fileprivate func handleAdd(sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            if sender.transform == .identity {
                let angle: CGFloat = 45 * CGFloat.pi / 180
                sender.transform = CGAffineTransform(rotationAngle: angle)
            } else {
                sender.transform = .identity
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todaysCellId, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listsCellId, for: indexPath) as! ListsCell
        cell.listController.items = items
        cell.listController.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - padding * 2
        var size: CGSize
        if indexPath.item == 0 {
            let dummyCell = TodaysCell(frame: .init(x: 0, y: 0, width: width, height: 1000))
            size = dummyCell.todayController.collectionViewLayout.collectionViewContentSize
        } else {
            let dummyCell = ListsCell(frame: .init(x: 0, y: 0, width: width, height: 1500))
            dummyCell.listController.items = items
            size = dummyCell.listController.collectionViewLayout.collectionViewContentSize
            size.height += padding * 1.5 + 30
        }
        
        return .init(width: width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding, left: padding, bottom: padding, right: padding)
    }
    var listFullscreen: ListFullscreenController!
    var startingPosition: CGRect!
}

extension HomeController: ListControllerDelegate, ListFullscreenControllerDelegate, UIGestureRecognizerDelegate {
    func didSelectList(at position: CGRect) {
        startingPosition = position
        let listFullscreenView = setupListFullscreen()
        createFullscreen(listFullscreenView: listFullscreenView, position: position)
    }
    
    fileprivate func setupListFullscreen() -> UIView {
        listFullscreen = ListFullscreenController()
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
        view.bringSubviewToFront(addButton)
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
            if translationY > 100 {
                gesture.state = .ended
            }
        } else if gesture.state == .ended {
            if translationY > 100 {
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
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        })
    }
    
    func didSizeToMini() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.collectionView.isUserInteractionEnabled = false
            self.listFullscreen.tableView.contentOffset = .zero
            self.listFullscreen.view.transform = .identity
            self.anchoredConstraints?.top?.constant = self.startingPosition.origin.y
            self.anchoredConstraints?.leading?.constant = self.startingPosition.origin.x
            self.anchoredConstraints?.width?.constant = self.startingPosition.width
            self.anchoredConstraints?.height?.constant = self.startingPosition.height
            self.view.layoutIfNeeded()
            self.listFullscreen.closeButton.alpha = 0
            self.listFullscreen.headerView.headerLabel.font = UIFont(name: CustomFont.semibold.rawValue, size: 20)
            self.listFullscreen.headerView.descriptionLabel.font = UIFont(name: CustomFont.regular.rawValue, size: 16)
        }) { (_) in
            self.listFullscreen.view.removeFromSuperview()
            self.listFullscreen.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}

