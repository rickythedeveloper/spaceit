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
    
    private var searchTimer: Timer?
    
    private var coredataUpdateTimer: Timer?

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
    
    /// This function is called when core data objects have been changed. This function reloads the table view data.
    @objc private func coreDataObjectsDidChange() {
        coredataUpdateTimer?.invalidate()
        coredataUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
            self.update()
        })
    }
}

// Views
extension CardListVC {
    private func setup() {
        self.title = "Cards"
        self.view.backgroundColor = UIColor.myBackGroundColor()
        self.managedObjectContext = NSManagedObjectContext.defaultContext()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCardPressed))
        
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        segControl = UISegmentedControl(items: segments)
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.selectedSegmentIndex = 0
        segControl.addTarget(nil, action: #selector(segControlValueChanged), for: .valueChanged)
        
        searchTextField.delegate = self
        cardListTV.translatesAutoresizingMaskIntoConstraints = false
        cardListTV.delegate = self
        cardListTV.dataSource = self
        cardListTV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        cardListTV.backgroundColor = .clear
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
        cardListTV.constrainToSideSafeAreasOf(view)
        cardListTV.constrainToBottomSafeAreaOf(view)
    }
    
    private func update() {
        tasks = Array.tasksFetched(managedObjectContext: self.managedObjectContext)
        updateCustomTaskArrays()
    }
    
    private func updateCustomTaskArrays() {
        if let text = searchTextField.text, text.hasContent() {
            upcomingTasks = tasks.activeTasks().sortedByDueDate().filterByWord(searchPhrase: text)
            alphabeticalTasks = tasks.sortedByName().filterByWord(searchPhrase: text)
            creationDateTasks = tasks.sortedByCreationDate(oldFirst: false).filterByWord(searchPhrase: text)
        } else {
            upcomingTasks = tasks.activeTasks().sortedByDueDate()
            alphabeticalTasks = tasks.sortedByName()
            creationDateTasks = tasks.sortedByCreationDate(oldFirst: false)
        }
        
        DispatchQueue.main.async {
            self.cardListTV.reloadData()
        }
    }
    
    @objc private func segControlValueChanged() {
        UIView.transition(with: cardListTV, duration: 0.5, options: .transitionCrossDissolve, animations: {self.cardListTV.reloadData()}, completion: nil)
    }
    
    @objc private func tfInputChanged() {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { (timer) in
            print("searched")
            self.updateCustomTaskArrays()
        })
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
        case 2:
            return CreationDateCardListCell(style: .default, reuseIdentifier: cellId, task: creationDateTasks[indexPath.row], isFirst: indexPath.row == 0)
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

// MARK: Keyboard Shortcuts
extension CardListVC {
    override var keyCommands: [UIKeyCommand]? {
        return [
//            UIKeyCommand(title: "Select page", action: #selector(selectPage), input: "p", modifierFlags: [.command], discoverabilityTitle: "Select page"),
//            UIKeyCommand(title: "Delete", action: #selector(deletePressed), input: "d", modifierFlags: [.command], discoverabilityTitle: "Delete"),
//            UIKeyCommand(title: "Archive", action: #selector(archivePressed), input: "a", modifierFlags: [.command], discoverabilityTitle: "Archive"),
            UIKeyCommand(title: "New Card", action: #selector(addCardPressed), input: "n", modifierFlags: [.command], discoverabilityTitle: "New Card"),
            UIKeyCommand(title: "Creation Date", action: #selector(switchToCreationDate), input: "3", modifierFlags: [.command], discoverabilityTitle: "Creation Date"),
            UIKeyCommand(title: "Alphabetical", action: #selector(switchToAlphabetical), input: "2", modifierFlags: [.command], discoverabilityTitle: "Alphabetical"),
            UIKeyCommand(title: "Upcoming", action: #selector(switchToUpcoming), input: "1", modifierFlags: [.command], discoverabilityTitle: "Upcoming"),
            UIKeyCommand(title: "Scroll to Top", action: #selector(scrollToTop), input: UIKeyCommand.inputUpArrow, modifierFlags: [.command], discoverabilityTitle: "Scroll to Top"),
            UIKeyCommand(title: "Search", action: #selector(search), input: "f", modifierFlags: [.command], discoverabilityTitle: "Search")
        ]
    }
    
    @objc private func switchToUpcoming() {
        self.segControl.selectedSegmentIndex = 0
        segControlValueChanged()
    }
    
    @objc private func switchToAlphabetical() {
        self.segControl.selectedSegmentIndex = 1
        segControlValueChanged()
    }
    
    @objc private func switchToCreationDate() {
        self.segControl.selectedSegmentIndex = 2
        segControlValueChanged()
    }
    
    @objc private func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -self.cardListTV.contentInset.top)
        self.cardListTV.setContentOffset(desiredOffset, animated: true)
    }
    
    @objc private func search() {
        self.searchTextField.becomeFirstResponder()
    }
}
