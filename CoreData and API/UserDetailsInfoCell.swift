//
//  UserDetailsInfoCell.swift
//  CoreData and API
//
//  Created by DB-MBP-012 on 11/05/24.
//

import UIKit

class UserDetailsInfoCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func cellConfig(userdata: UsersBasicData?) {
        nameLbl.text = userdata?.name
        mailLbl.text = userdata?.email
        mobileLbl.text = userdata?.mobile
        genderLbl.text = userdata?.gender
    }
    
}
