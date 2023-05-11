
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
  func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {
  
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var dobLabel: UILabel!
  @IBOutlet var employeeTypeLabel: UILabel!
  @IBOutlet var saveBarButtonItem: UIBarButtonItem!
  
  @IBOutlet var dobDatePicker: UIDatePicker!
  
  var employeeType: EmployeeType?
  
  private var isEditingBirthday = false {
    didSet{
      dobDatePicker.isHidden = !isEditingBirthday
    }
  }
  private let dobLabelIndexPath = IndexPath(row: 1, section: 0)
  private let dobDatePickerIndexPath = IndexPath(row: 2, section: 0)
  
  weak var delegate: EmployeeDetailTableViewControllerDelegate?
  var employee: Employee?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateView()
    updateSaveButtonState()
  }
  
  func employeeTypeTableViewController(_ didSelect: EmployeeType) {
    employeeType = didSelect
    employeeTypeLabel.text = didSelect.description
  }
  
  func updateView() {
    if let employee = employee {
      navigationItem.title = employee.name
      nameTextField.text = employee.name
      
      dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
      dobLabel.textColor = .label
      employeeTypeLabel.text = employee.employeeType.description
      employeeTypeLabel.textColor = .label
    } else {
      navigationItem.title = "New Employee"
    }
  }
  
  private func updateSaveButtonState() {
    let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
    saveBarButtonItem.isEnabled = shouldEnableSaveButton
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    guard let name = nameTextField.text else {
      return
    }
    
    let employee = Employee(name: name, dateOfBirth: Date(), employeeType: .exempt)
    delegate?.employeeDetailTableViewController(self, didSave: employee)
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    employee = nil
  }
  
  @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
    updateSaveButtonState()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath == dobLabelIndexPath {
      isEditingBirthday.toggle()
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath {
    case dobDatePickerIndexPath where !isEditingBirthday:
      return 0
    default:
      return UITableView.automaticDimension
    }
  }
  
  @IBAction func dobValueChanged(_ sender: UIDatePicker) {
    dobLabel.text = dobDatePicker.date.formatted(.dateTime)
  }
  
  @IBSegueAction func showEmployeeType(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
    
    let nextTCV = EmployeeTypeTableViewController(coder: coder)
    nextTCV?.delegate = self
    nextTCV?.employeeType = employeeType
    return nextTCV
  }
}
