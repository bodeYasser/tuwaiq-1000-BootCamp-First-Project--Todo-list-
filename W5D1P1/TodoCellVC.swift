//
//  TodoCellVC.swift
//  W5D1P1
//
//  Created by Abdallah yasser on 04/05/2022.
//

import UIKit

class TodoCellVC: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoDate: UILabel!
    @IBOutlet weak var todoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
