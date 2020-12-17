//
//  ModuleImport.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/17.
//

import Foundation

public class ModuleImport:Symbol
    {
    let path:String?
    
    init(shortName:String,path:String?)
        {
        self.path = path
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
