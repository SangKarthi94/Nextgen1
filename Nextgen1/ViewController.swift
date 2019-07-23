//
//  ViewController.swift
//  Nextgen1
//
//  Created by SangaviKarthik on 17/07/19.
//  Copyright © 2019 Cruzze. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON

struct CategoryModel: Decodable {
    let data : [CategoryData]!
    let message : String!
    let result : Bool!
}

struct CategoryData: Decodable {
    let categoryID : Int!
    let categoryImage : String!
    let categoryName : String!
    let subCategoryCount : String!
    
}

struct Contact : Decodable{
    let firstName : String!
    let lastName : String!
    let gender : String!
    let age : Int!
    let address: Address?
    let phoneNumbers : [PhoneNumbers]!
}

struct PhoneNumbers : Decodable{
    let type : String!
    let number : String!
}


struct Address : Decodable{
    let streetAddress : String!
    let city : String!
    let state : String!
    let postalCode : String!
}

let notifyKey1 = "com.nexgen.key1"
let notifyKey2 = "com.nexgen.key2"

class ViewController: UIViewController {

    @IBOutlet weak var lblProducts: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        createObservers()
        
//        jsonAlomaFire(path: Constants.Params.CATEGORY) //AlomaFire
//        jsonURLSession(path: Constants.Params.CATEGORY) //URL Session
        
        localJson()
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Fetch Datas from Entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        request.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            print("Count  ",result.count)
            
            for data in result as! [CategoryEntity] {
                print(data.categoryID )
                print(data.categoryName ?? "Subject")
                print(data.subCategoryCount!)
            }
            
        }catch{
            print("Fetch Failed")
        }
        
        
        //Delete CoreData -> to delete data from core data we need to fetch 1st
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do{
            _ = try context.execute(deleteRequest)
        }catch{
            print("Error in delete option")
        }
        
        
        
    }
    
    //Example for Notification/Obsorever
    @IBAction func notificationScreen(_ sender: Any) {
        let observerScreen = storyboard?.instantiateViewController(withIdentifier: "ObservableViewController") as! ObservableViewController
        self.navigationController?.pushViewController(observerScreen, animated: false)
    }
    
    //It Example for delegate
    @IBAction func moveNexasick(_ sender: Any) {
        
        let delegateViewCtrl = storyboard?.instantiateViewController(withIdentifier: "DelegateViewController") as! DelegateViewController
        delegateViewCtrl.learnDelegate = self as LearnDelegate?
        self.navigationController?.pushViewController(delegateViewCtrl, animated: true) //With NavigationViewControll
//        present(delegateViewCtrl, animated: true, completion: nil) //To just present the view
        
    }
    
    func localJson(){
        
        let location = "response"
        let fileType = "json"
        if let path = Bundle.main.path(forResource: location, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                //Decode the data
                let jsonDecoder = JSONDecoder()
                 let jsonData = try jsonDecoder.decode(Contact.self, from: data)
                print("test",data)
                print(jsonData.firstName ?? "String")
                print(jsonData.address?.city)
                print(jsonData.phoneNumbers)

                print("Sangavi Success", jsonData)
            } catch let error {
                print("Sangavi Failure")
                print(error.localizedDescription)
            }}
        
    }
    
    //Api call using Alamofire
    func jsonAlomaFire(path : String)  {
        let header: [String:String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        Alamofire.request(path, method: .post, parameters: nil, encoding:  URLEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonDecoder = JSONDecoder()
                do {
                    let jsonData = try jsonDecoder.decode(CategoryModel.self, from: response.data!)
                    print("JSON String : " , jsonData.data.count)
                    print("name ",jsonData.data[0].categoryName ?? "CategoryName")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "CategoryEntity", in: context)
                    
                    for data in jsonData.data{
                        print(data.categoryName as Any)
                        //For every time we need to add this line
                        let categoryData = NSManagedObject(entity: entity!, insertInto: context)
                        categoryData.setValue(data.categoryID, forKey: Constants.CategoryEntity.categoryID)
                        categoryData.setValue(data.categoryName, forKey: Constants.CategoryEntity.categoryName)
                        categoryData.setValue(data.categoryImage, forKey: Constants.CategoryEntity.categoryImage)
                        categoryData.setValue(data.subCategoryCount, forKey: Constants.CategoryEntity.subCategoryCount)
                        
                    }
                    
                    do{
                        try context.save()
                    }catch{
                        print(error)
                    }
                }
                catch {
                }
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Web API call using URLSession
    func jsonURLSession(path : String)  {
        let jsonUrlString = Constants.Params.CATEGORY
        guard let url = URL(string: jsonUrlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (datas, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            let response = response as? HTTPURLResponse
            print(response?.statusCode)
            
            guard let data = datas else { return }
            
            //            let dataAsString = String(data: data, encoding: .utf8)
            //            print(dataAsString)
            
            do {
                //                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                //                print(websiteDescription.name, websiteDescription.description)
                
                let courses = try JSONDecoder().decode(CategoryModel.self, from: data)
                //print(courses)
                print(courses.message ?? "Test")
                print(courses.data.count)
                
                
                //Swift 2/3/ObjC
                //                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                //
                //                let course = Course(json: json)
                //                print(course.name)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
    
    
    //***********Notification/Delegate**************//
    let notifyViewKey1 = Notification.Name(rawValue: notifyKey1)
    let notifyViewKey2 = Notification.Name(rawValue: notifyKey2)
    
    func createObservers(){
        //NotifyKey 1
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateLabel(notification:)), name: notifyViewKey1, object: nil)
        
        //NotifyKey 2
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateLabel(notification:)), name: notifyViewKey2, object: nil)
    }
    
    @objc func updateLabel(notification : NSNotification){
        print("Datas")
        
        let key1 = notification.name == notifyViewKey1
        
        let data = key1 ? "Pressed Notify 1" : "Pressed Notify 2"
        
        lblProducts.text = data
        
    }

    deinit {
        NSLog("View Controller Got Deinitialized")
        //Remove observers else even if controller removes observer still except for notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    

    
   
}

enum Error: Swift.Error {
    case requestFailed
}

extension ViewController : LearnDelegate {
    func sendData(typedText: String) {
        lblProducts.text = typedText
    }
    
    
}
