//
//  CardListVC.swift
//  Notification App
//
//  Created by Rintaro Kawagishi on 08/01/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import UIKit
import CoreData

class CardListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private let segments = ["Upcoming", "Alphabetical", "Creation Date"]
    private var segControl = UISegmentedControl()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Search"
        tf.addTarget(nil, action: #selector(tfInputChanged), for: .editingChanged)
        tf.addTarget(nil, action: #selector(tfEndedEditing), for: .editingDidEnd)
        tf.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        let padding: CGFloat = 10
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 1))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = padding
        tf.layer.masksToBounds = true
        return tf
    }()
    
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

// Action
extension CardListVC {
    @objc private func addCardPressed() {
        self.navigationController?.pushViewController(NewCardVC(), animated: true)
    }
    
    @objc private func clearPressed() {
        searchTextField.text = ""
        view.endEditing(true)
        updateCustomTaskArrays()
    }
}

// Views
extension CardListVC {
    private func setup() {
        self.title = "Cards"
        self.view.backgroundColor = UIColor.myBackGroundColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCardPressed))
        
        segControl = UISegmentedControl(items: segments)
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.selectedSegmentIndex = 0
        segControl.addTarget(nil, action: #selector(segControlValueChanged), for: .valueChanged)
        
        searchTextField.delegate = self
        cardListTV.translatesAutoresizingMaskIntoConstraints = false
        cardListTV.delegate = self
        cardListTV.dataSource = self
        cardListTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func layoutViews() {
        view.addSubview(segControl)
        view.addSubview(cardListTV)
        view.addSubview(searchTextField)
        
        let clearButton = UIButton()
        clearButton.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        clearButton.tintColor = (UIColor.white).withAlphaComponent(0.5)
        clearButton.addTarget(nil, action: #selector(clearPressed), for: .touchUpInside)
        searchTextField.rightView = clearButton
        searchTextField.rightViewMode = .whileEditing
        
        let padding: CGFloat = 10.0
        
        segControl.constrainToTopSafeAreaOf(view, padding: padding)
        segControl.constrainToSideSafeAreasOf(view, padding: padding)
        segControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        segControl.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        
        searchTextField.isBelow(segControl, padding: padding)
        searchTextField.constrainToSideSafeAreasOf(view, padding: padding)
        searchTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        searchTextField.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        
        cardListTV.isBelow(searchTextField, padding: padding)
        cardListTV.constrainToSideSafeAreasOf(view, padding: padding)
        cardListTV.constrainToBottomSafeAreaOf(view, padding: padding)
    }
    
    private func update() {
        managedObjectContext = defaultManagedObjectContext()
        tasks = tasksFetched()
        updateCustomTaskArrays()
    }
    
    private func updateCustomTaskArrays() {
        if let text = searchTextField.text, text.hasContent() {
            upcomingTasks = tasks.activeTasks().filterByWord(searchPhrase: text)
            alphabeticalTasks = tasks.sortedByName().filterByWord(searchPhrase: text)
            creationDateTasks = tasks.sortedByCreationDate(oldFirst: false).filterByWord(searchPhrase: text)
        } else {
            upcomingTasks = tasks.activeTasks()
            alphabeticalTasks = tasks.sortedByName()
            creationDateTasks = tasks.sortedByCreationDate(oldFirst: false)
        }
        cardListTV.reloadData()
    }
    
    @objc private func segControlValueChanged() {
        UIView.transition(with: cardListTV, duration: 0.5, options: .transitionCrossDissolve, animations: {self.cardListTV.reloadData()}, completion: nil)
    }
    
    @objc private func tfInputChanged() {
        updateCustomTaskArrays()
    }
    
    @objc private func tfEndedEditing() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// Table View
extension CardListVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            return upcomingTasks.count
        } else if segControl.selectedSegmentIndex == 1 {
            return alphabeticalTasks.count
        } else {
            return creationDateTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segControl.selectedSegmentIndex {
        case 0:
            return UpcomingCardListCell(style: .default, reuseIdentifier: cellId, task: upcomingTasks[indexPath.row], isFirst: indexPath.row == 0)
        case 1:
            return AlphabeticalCardListCell(style: .default, reuseIdentifier: cellId, task: alphabeticalTasks[indexPath.row])
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
            cell.textLabel?.text = "Test"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTask: TaskSaved
        let segment = segControl.selectedSegmentIndex
        if segment == 0 {
            selectedTask = upcomingTasks[indexPath.row]
        } else if segment == 1 {
            selectedTask = alphabeticalTasks[indexPath.row]
        } else {
            selectedTask = creationDateTasks[indexPath.row]
        }
        
        self.navigationController?.pushViewController(CardEditVC(task: selectedTask, managedObjectContext: managedObjectContext, onDismiss: {
            self.update()
        }), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
