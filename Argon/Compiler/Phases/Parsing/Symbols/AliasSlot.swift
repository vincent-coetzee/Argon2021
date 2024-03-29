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
        super.init(shortName:shortName,class:.voidClass,attributes:attributes)
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    internal required init(shortName: String, class: Class, container: SymbolContainer = .nothing, attributes: SlotAttributes)
        {
        self.expression = Expression()
        super.init(shortName:shortName,class:`class`,container:container,attributes:attributes)
        }
}
