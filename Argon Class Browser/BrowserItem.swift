//
//  BrowserItem.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/04.
//

import Foundation

public class BrowserItem
    {
    class func systemClass(_ name:String) -> BrowserSystemClassItem
        {
        return(BrowserSystemClassItem(shortName:name))
        }
        
    let shortName:String
    
    init(shortName:String)
        {
        self.shortName = shortName
        }
    }
