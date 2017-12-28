//
//  UsersListViewCell.swift
//  Assignment5
//
//  Created by Admin on 11/10/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

class UsersListViewCell: UITableViewCell {
    
    @IBOutlet weak var nickNameInList: UILabel!
    @IBOutlet weak var countryStateCityYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateCell(users:Users) {
        let year = String(users.year)
        nickNameInList.text = users.nickname
        countryStateCityYear.text = users.country + " | " + users.state + " | " + users.city + " | " + year
    }

}
