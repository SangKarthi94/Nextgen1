//
//  Constants.swift
//  Nextgen1
//
//  Created by SangaviKarthik on 17/07/19.
//  Copyright © 2019 Cruzze. All rights reserved.
//

import UIKit

class Constants: NSObject {

    static let BASE_URL = "http://watertecindia.com/watertec_api/"
    
    struct Params {
        static let CATEGORY = BASE_URL + "category_list.php"//GET
    }
    
    struct  CategoryEntity {
        
        static let entityName = "CategoryEntity"
        static let categoryID = "categoryID"
        static let categoryImage = "categoryImage"
        static let categoryName = "categoryName"
        static let subCategoryCount = "subCategoryCount"
    }
    
}
