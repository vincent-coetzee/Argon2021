//
//  ThreeAddressTemporary.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class A3Temporary:Codable
    {
    private let name:String
        
    public var displayString:String
        {
        return(self.name)
        }
    
    class func newTemporary() -> A3Temporary
        {
        let index = Argon.nextIndex()
        return(A3Temporary(name:"t_\(index)"))
        }
        
    class func makeNew() -> A3Address
        {
        let index = Argon.nextIndex()
        return(.temporary(A3Temporary(name:"t_\(index)")))
        }
        
    init(name:String)
        {
        self.name = name
        }
    }
