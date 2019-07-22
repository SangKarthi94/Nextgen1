//
//  DelegateViewController.swift
//  Nextgen1
//
//  Created by SangaviKarthik on 20/07/19.
//  Copyright © 2019 Cruzze. All rights reserved.
//

import UIKit

class DelegateViewController: UIViewController {

    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var txtProductName: UITextField!
    
    //Declare Delegate
    var learnDelegate : LearnDelegate!
    var dataValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSubmitBtn(_ sender: Any) {
        print("Clicked")
        
        //This function is for nil check
//        guard let data = dataValue else {
//            print("No Data")
//            return
//        }
        
        if let data = txtProductName.text {
            learnDelegate.sendData(typedText: data)
            self.navigationController?.popViewController(animated: true)
        }else {
            //If nill it will execute
             print("No Data")
        }
        
        
    }
    
    deinit {
        print("DelegateViewController Got Dismissed")
    }

}

protocol LearnDelegate {
    //Here Function Declaration
    func sendData(typedText : String)
}
