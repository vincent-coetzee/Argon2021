//
//  AliasSlot.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class AliasSlot:Slot
    {
    let expression:Expression
    
    internal init(shortName:String,attributes:SlotAttributes,expression:Expression)
        {
        self.expression = expression
        super.init(shortName:shortName,class:.voidClass,container:nil,attributes:attributes)
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
