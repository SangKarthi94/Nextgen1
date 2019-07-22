//
//  ObservableViewController.swift
//  Nextgen1
//
//  Created by SangaviKarthik on 20/07/19.
//  Copyright © 2019 Cruzze. All rights reserved.
//

import UIKit

class ObservableViewController: UIViewController {
    
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var txtProductName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Notification key 2
    @IBAction func notificationKey2(_ sender: Any) {
        
        let notifyName = Notification.Name(rawValue: notifyKey2)
        NotificationCenter.default.post(name: notifyName, object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //Notification key 1
    @IBAction func clickSubmitBtn(_ sender: Any) {
        print("Clicked")
        
        let notifyName = Notification.Name(rawValue: notifyKey1)
        NotificationCenter.default.post(name: notifyName, object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    deinit {
        print("NotificationViewController Got Dismissed")
    }
    

}
