//
//  ViewController.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 11/05/24.
//

import UIKit
import CoreData

class ViewController: BaseViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dataListTableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    
    var viewModel = MainViewModel()
    var usersBasicData: [UsersBasicData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        addButton.layer.cornerRadius = 15
        locationBtn.layer.cornerRadius = 15
        
        viewModel.registerTableView(tableView: dataListTableView) {
            self.dataListTableView.delegate = self
            self.dataListTableView.dataSource = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        apiCallGetData()
    }
    
    func fetchCoreDataObject() {
        fetch { complete in
            if complete {
                DispatchQueue.main.async {
                    if self.usersBasicData.count >= 1 {
                        self.dataListTableView.isHidden = false
                        self.noDataLbl.isHidden = true
                        self.dataListTableView.reloadData()
                    } else {
                        self.dataListTableView.isHidden = true
                        self.noDataLbl.isHidden = false
                        self.dataListTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //MARK: - API Calls
    
    func apiCallGetData() {
        DispatchQueue.main.async {
            self.view.showLoader()
        }
        viewModel.getDataFromAPI { result in
            DispatchQueue.main.async {
                self.view.hideLoader()
            }
            switch result {
            case .success(let data):
                self.clearData() {
                    DispatchQueue.main.async {
                        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
                        
                        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
                        
                        for item in data {
                            let info = UsersBasicData(context: managedContext)
                            info.name = item.name
                            info.id = item._id
                            info.gender = item.gender
                            info.mobile = item.mobile
                            info.email = item.email
                        }
                        do {
                            try managedContext.save()
                            DispatchQueue.main.async {
                                self.fetchCoreDataObject()
                            }
                        } catch {
                            debugPrint("Catch the output \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                self.showToast(message: error.localizedDescription)
            }
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func actionAddUsers(_ sender: UIButton) {
        if let ctrl = K.Storyboard.main.instantiateViewController(withIdentifier: K.Screen.UserDetailsVC) as? UserDetailsViewController {
            ctrl.isEditAction = false
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
    }
    
    
    @IBAction func actionLocation(_ sender: UIButton) {
        if let ctrl = K.Storyboard.main.instantiateViewController(withIdentifier: K.Screen.LocationVC) as? LocationViewController {
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
    }
}



//MARK: -  TableView Delegate and Data Source

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersBasicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.XIBCell.userDetailsInfoCell, for: indexPath) as? UserDetailsInfoCell else {
            return UITableViewCell()
        }
        cell.cellConfig(userdata: usersBasicData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            DispatchQueue.main.async {
                self.view.showLoader()
            }
            self.viewModel.deleteDataInAPI(id: self.usersBasicData[indexPath.row].id ?? "") { result in
                
                DispatchQueue.main.async {
                    self.view.hideLoader()
                }
                switch result {
                case .success(_):
                    self.apiCallGetData()
                case .failure(let error):
                    self.showToast(message: error.localizedDescription)
                }
                completionHandler(true)
            }
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Eidt") { (action, view, completionHandler) in
            
            if let ctrl = K.Storyboard.main.instantiateViewController(withIdentifier: K.Screen.UserDetailsVC) as? UserDetailsViewController {
                ctrl.isEditAction = true
                ctrl.editedIndexPathRow = indexPath.row
                ctrl.usersBasicData = self.usersBasicData
                self.navigationController?.pushViewController(ctrl, animated: true)
            }
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        editAction.backgroundColor = UIColor.gray
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
}

//MARK: - Core Data operation

extension ViewController {
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<UsersBasicData>(entityName: "UsersBasicData")
        
        do {
            self.usersBasicData = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            completion(false)
        }
        
    }
    
    func clearData(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UsersBasicData")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
                completion()
            } catch {
                debugPrint("Not able to delete the data's, due to : \(error)")
            }
        }
    }
}
