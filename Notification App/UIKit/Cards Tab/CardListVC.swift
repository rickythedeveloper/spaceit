//
//  CardListVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class CardListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let segments = ["Upcoming", "Alphabetical", "Creation Date"]
    private var segControl = UISegmentedControl()
    
    private let cellId = "cardListTableViewCell"
    private var cardListTV = UITableView()
    
    private var managedObjectContext: NSManagedObjectContext!
    private var tasks = [TaskSaved]()
    
    private var upcomingTasks = [TaskSaved]()
    private var alphabeticalTasks = [TaskSaved]()
    private var creationDateTasks = [TaskSaved]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
}

// Views
extension CardListVC {
    private func setup() {
        self.title = "Cards"
        
        segControl = UISegmentedControl(items: segments)
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.selectedSegmentIndex = 0
        segControl.addTarget(nil, action: #selector(segControlValueChanged), for: .valueChanged)
        
        cardListTV.translatesAutoresizingMaskIntoConstraints = false
        cardListTV.delegate = self
        cardListTV.dataSource = self
        cardListTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func layoutViews() {
        view.addSubview(segControl)
        view.addSubview(cardListTV)
        
        let padding: CGFloat = 10.0
        
        segControl.constrainToTopSafeAreaOf(view, padding: padding)
        segControl.constrainToSideSafeAreasOf(view, padding: padding)
        segControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        segControl.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        cardListTV.isBelow(segControl, padding: padding)
        cardListTV.constrainToSideSafeAreasOf(view, padding: padding)
        cardListTV.constrainToBottomSafeAreaOf(view, padding: padding)
    }
    
    @objc private func segControlValueChanged() {
        UIView.transition(with: cardListTV, duration: 0.5, options: .transitionCrossDissolve, animations: {self.cardListTV.reloadData()}, completion: nil)
    }
    
    private func update() {
        managedObjectContext = defaultManagedObjectContext()
        tasks = tasksFetched()
        upcomingTasks = tasks.activeTasks()
        alphabeticalTasks = tasks.sortedByName()
        creationDateTasks = tasks.sortedByCreationDate(oldFirst: false)
    }

}

// Table View
extension CardListVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            return tasks.activeTasks().count
        } else {
            return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) {
            if segControl.selectedSegmentIndex == 0 {
                cell.textLabel?.text = tasks.activeTasks()[indexPath.row].question
            } else if segControl.selectedSegmentIndex == 1{
                cell.textLabel?.text = tasks.sortedByName()[indexPath.row].question
            } else {
                cell.textLabel?.text = tasks.sortedByCreationDate(oldFirst: false)[indexPath.row].question
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Error."
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(CardEditVC(task: tasks[indexPath.row], managedObjectContext: managedObjectContext, onDismiss: {
            self.cardListTV.reloadData()
        }), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
