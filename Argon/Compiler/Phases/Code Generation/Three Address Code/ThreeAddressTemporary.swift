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
    
    private static var _index = 1
    
    class func newTemporary() -> ThreeAddressTemporary
        {
        let index = self._index
        self._index += 1
        return(ThreeAddressTemporary(name:"_TEMP_\(index)"))
        }
        
    init(name:String)
        {
        self.name = name
        }
    }
