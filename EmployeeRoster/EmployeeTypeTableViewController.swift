//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by H.Namikawa on 2023/05/10.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate {
  func employeeTypeTableViewController(_ didSelect: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {
  
  var employeeType:EmployeeType?
  var delegate: EmployeeTypeTableViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    let employeeTypes = EmployeeType.allCases
    return employeeTypes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTypeCell", for: indexPath)
    let type = EmployeeType.allCases[indexPath.row]
    
    var content = cell.defaultContentConfiguration()
    content.text = type.description
    cell.contentConfiguration = content
    
    if employeeType == type {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    employeeType = EmployeeType.allCases[indexPath.row]
    tableView.beginUpdates()
    tableView.endUpdates()
    
    if let delegate = self.delegate, let employeeType = employeeType {
      delegate.employeeTypeTableViewController(employeeType)
    }
    
  }
}
