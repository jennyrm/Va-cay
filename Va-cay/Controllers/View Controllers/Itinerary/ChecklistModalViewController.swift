//
//  ChecklistModalViewController.swift
//  Va-cay
//
//  Created by James Lea on 8/17/21.
//

import UIKit

class ChecklistModalViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var checkListTableView: UITableView!
    
    // MARK: - Properties
    var checklist: [ [String??: Bool] ]? {
        didSet {
            
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkListTableView.delegate = self
        checkListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkListTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func exitModalButtonTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}//End of class

extension ChecklistModalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as? CheckListItemTableViewCell
        if let checklist = checklist {
            cell?.checklistItem = checklist[indexPath.row]
        }
        cell?.index = indexPath.row
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
    }
    
}//End of extension
