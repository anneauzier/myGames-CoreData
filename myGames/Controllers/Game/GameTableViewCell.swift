//
//  GameTableViewCell.swift
//  myGames
//
//  Created by Anne Victoria Batista Auzier on 19/12/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
