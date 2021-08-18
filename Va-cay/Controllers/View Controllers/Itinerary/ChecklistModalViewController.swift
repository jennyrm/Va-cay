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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkListTableView.delegate = self
        checkListTableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func exitModalButtonTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - FNs
    
}//End of class

extension ChecklistModalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as? CheckListItemTableViewCell
        
        
        return UITableViewCell()
    }
    
    
}//End of extension
