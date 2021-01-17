//
//  ThreeAddressTemporary.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class ThreeAddressTemporary:ThreeAddress
    {
    private let name:String
    
    public var displayString:String
        {
        return(self.name)
        }
    
    class func newTemporary() -> ThreeAddressTemporary
        {
        let index = Argon.nextIndex()
        return(ThreeAddressTemporary(name:"t_\(index)"))
        }
        
    init(name:String)
        {
        self.name = name
        }
    }
