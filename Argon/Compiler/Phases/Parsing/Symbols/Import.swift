//
//  ModuleImport.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/17.
//

import Foundation

public class Import:Symbol
    {
    let path:String?
    
    init(shortName:String,path:String?)
        {
        self.path = path
        super.init(shortName:shortName)
        }
    
    init(name:Name,path:String?)
        {
        self.path = path
        super.init(shortName:name.first)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
