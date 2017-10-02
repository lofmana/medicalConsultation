//
//  TableViewCellFever.swift
//  medicalConsultation
//
//  Created by Adam Tan on 28/9/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit

class TableViewCellFever: UITableViewCell , UIPickerViewDelegate , UIPickerViewDataSource{
    
    @IBOutlet weak var picker1: UIPickerView!
    
    var tenArray = ["35" , "36" , "37" , "38" , "39" , "40" , "40+"]
    var pointArray = ["0" , "1" , "2" ," 3" , "4" , "5" , "6" , "7" , "8" , "9"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0
        {
            return tenArray.count
        }
        else
        {
            return pointArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if component == 0 {
            return String(tenArray[row])
        } else {
            
            return String(pointArray[row])
        }
    }

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
