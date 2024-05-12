//
//  UserDetailsViewController.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 11/05/24.
//

import UIKit
import CoreData

class UserDetailsViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailIdField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    
    var isEditAction = false
    var usersBasicData: [UsersBasicData] = []
    var editedIndexPathRow = 0
    var viewModel = UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    func initialSetup() {
        
        nameField.delegate = self
        mobileField.delegate = self
        mailIdField.delegate = self
        genderField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        titleLbl.text = isEditAction ? "Edit UserDetails" : "User Details"
        if isEditAction {
            editUserDetails()
        }
        updateButton.layer.cornerRadius = 15
    }
    
    //MARK: - Button Action
    
    @IBAction func actionUpadate(_ sender: UIButton) {
        
        if nameField.text != "" && mobileField.text != "" && mailIdField.text != "" && genderField.text != "" {
            if isEditAction {
                apiCallPutData() {
                    self.navigateBack()
                }
            } else {
                apiCallPostData() {
                    self.navigateBack()
                }
            }
        } else {
            self.showToast(message: "Please provide all the required datas...")
        }
    }
    
    func editUserDetails() {
        nameField.text = usersBasicData[editedIndexPathRow].name
        mobileField.text = usersBasicData[editedIndexPathRow].mobile
        mailIdField.text = usersBasicData[editedIndexPathRow].email
        genderField.text = usersBasicData[editedIndexPathRow].gender
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        navigateBack()
    }
    
    func navigateBack() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func apiCallPostData(completion: @escaping(() -> Void)) {
        DispatchQueue.main.async {
            self.view.showLoader()
        }
        
        let dictionary = ["name": nameField.text, "email": mailIdField.text, "gender": genderField.text, "mobile": mobileField.text]
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let jsonData = jsonData {
            viewModel.postDataToAPI(data: jsonData) { result in
                
                DispatchQueue.main.async {
                    self.view.hideLoader()
                }
                switch result {
                case .success(_):
                    completion()
                case .failure(let error):
                    self.showToast(message: error.localizedDescription)
                }
            }
        }
    }
    
    func apiCallPutData(completion: @escaping(() -> Void)) {
        DispatchQueue.main.async {
            self.view.showLoader()
        }
        
        let dictionary = ["name": nameField.text, "email": mailIdField.text, "gender": genderField.text, "mobile": mobileField.text]
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let jsonData = jsonData {
            viewModel.putDataToAPI(id: usersBasicData[editedIndexPathRow].id ?? "", data: jsonData) { result in
                
                DispatchQueue.main.async {
                    self.view.hideLoader()
                }
                switch result {
                case .success(_):
                    completion()
                case .failure(let error):
                    self.showToast(message: error.localizedDescription)
                }
            }
        }
    }
}
