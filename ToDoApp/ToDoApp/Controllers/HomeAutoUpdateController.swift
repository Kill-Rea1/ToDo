//
//  HomeAutoUpdateController.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 13/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

class HomeAutoUpdateController: BaseCollectionController {
    fileprivate let todaysCellId = "todaysCell"
    fileprivate let listsCellId = "listsCell"
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<List> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<List> = List.fetchRequest()
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let fetchError {
            print("Failed to fecth:", fetchError)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ListsCell.self, forCellWithReuseIdentifier: listsCellId)
//        collectionView.insertItems(at: <#T##[IndexPath]#>)
    }
}

extension HomeAutoUpdateController: NSFetchedResultsControllerDelegate {
    
}
