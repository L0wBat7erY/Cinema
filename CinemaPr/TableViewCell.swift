//
//  TableViewCell.swift
//  CinemaPr
//
//  Created by macOS Sierra on 9/22/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var coverPhim: UIImageView!
    @IBOutlet weak var idPhim: UILabel!
    @IBOutlet weak var ngay: UILabel!
    @IBOutlet weak var theLoaiPhim: UILabel!
    @IBOutlet weak var labelNgay: UIImageView!
    @IBOutlet weak var labelTheLoai: UIImageView!
    @IBOutlet weak var labelIDPhim: UIImageView!
    @IBOutlet weak var tenPhim: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(text: String){
        
    }

}
