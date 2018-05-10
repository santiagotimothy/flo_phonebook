//
//  FileHelper.swift
//  FLO_Phonebook
//
//  Created by Timothy Santiago on 10/05/2018.
//  Copyright © 2018 santiagotimothy. All rights reserved.
//

import Foundation
import SwiftyJSON

class FileHelper{
    
    public static func loadContactsToJSON()->JSON?{
        let filePath = Bundle.main.path(forResource: "phonebook", ofType: "json", inDirectory: nil)
        
        if let filePath = filePath {
            do {
                let fileUrl = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                return try? JSON(data: jsonData)["contacts"]
            } catch {
                print(error)
                fatalError("Unable to read contents of the file url")
            }
        }
        return nil
    }
    
}
