//
//  SharedObject.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/03.
//

import Foundation

public class SharedObject
    {
    let path:String
    var handle:UnsafeMutableRawPointer?
    var functions:[String:UnsafeMutableRawPointer] = [:]
    
    init(path:String)
        {
        self.path = path
        }
        
    func open() -> Bool
        {
        if let pointer = dlopen(path, RTLD_NOW)
            {
            self.handle = pointer
            return(true)
            }
        return(false)
        }
        
    func bind(name:String) -> Bool
        {
        if let address = dlsym(self.handle!,name)
            {
            self.functions[name] = address
            return(true)
            }
        return(false)
        }
    }
