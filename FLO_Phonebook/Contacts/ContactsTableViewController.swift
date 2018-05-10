//
//  ContactsTableViewController.swift
//  FLO_Phonebook
//
//  Created by Timothy Santiago on 10/05/2018.
//  Copyright © 2018 santiagotimothy. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactsTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var contents:[JSON]?
    var contacts:JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = FileHelper.loadContactsToJSON()
        contents = contacts?.arrayValue
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showContactDetails":
            if let detailViewController = segue.destination as? ContactDetailsViewController{
                detailViewController.contactDetails = contents?[sender as! Int]
            }
            break
        default:
            break
        }
    }
    
    //MARK: - tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactsTableViewCell{
            if let contactName = contents?.map({$0["name"].stringValue})[indexPath.row]{
                cell.name.text = contactName
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showContactDetails", sender: indexPath.row)
    }
}

extension ContactsTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        defer { self.tableView.reloadData() }
        contents = contacts?.arrayValue
        
        guard let contacts = contacts else { return }
        guard searchText.count > 0 else { return }
        contents = contacts.arrayValue.filter({ (element) -> Bool in
            return element["name"].stringValue.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        
    }
    
}

