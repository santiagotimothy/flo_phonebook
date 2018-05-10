//
//  ContactDetailsViewController.swift
//  FLO_Phonebook
//
//  Created by Timothy Santiago on 10/05/2018.
//  Copyright © 2018 santiagotimothy. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactDetailsViewController: UIViewController{
    
    @IBOutlet var stackView: UIStackView!
    var contactDetails: JSON?
    
    override func viewDidLoad() {
        guard let details = contactDetails else { return }
        
        //load views
        for (key,element):(String, JSON) in details {
            if let texts = getTextFrom(element: element, key: key, level: 0) {
                for text in texts{
                    let elementLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.stackView.frame.width, height: self.stackView.frame.height))
                    elementLabel.text = text
                    elementLabel.sizeToFit()
                    stackView.addArrangedSubview(elementLabel)
                }
            }
        }
        
    }
    
    func getTextFrom(element: JSON, key: String, level:Int)->[String]?{
        //check if element is displayable
        var texts = [String]()
        if element.object is String{
            texts.append("\(String(repeating:"\t",count: level)) \(key) : \(element.stringValue)")
        }else if element.object is Int{
            texts.append("\(String(repeating:"\t",count: level)) \(key) : \(String(element.intValue))")
        }else if element.object is Bool{
            texts.append("\(String(repeating:"\t",count: level)) \(key) : \(element.boolValue ? "Yes" : "No")")
        }
        
        // prevent showing friends' dictionaries
        guard level <= 1 else { return texts }
        
        //if dictionary, iterate and recur through elements
        if let subElement = element.dictionary{
            //only show array labels (level 0)
            if level == 0 { texts.append("\(String(repeating:"\t",count: level))  - \(key) -") }
            for (subKey,subElement):(String, JSON) in subElement {
                if let arrayTexts = getTextFrom(element: subElement, key: subKey, level: level+1){
                    texts.append(contentsOf: arrayTexts)
                }
            }
        }
        //if array, iterate and recur through children
        else if let subArray = element.array{
            texts.append("\(String(repeating:"\t",count: level))  - \(key) -")
            for subElement in subArray {
                if let arrayTexts = getTextFrom(element: subElement, key: key, level: level+1){
                    texts.append(contentsOf: arrayTexts)
                }
            }
        }
        return texts
    }
    
}
