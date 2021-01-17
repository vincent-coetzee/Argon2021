//
//  LocalVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LocalVariable:Variable
    {
    public override var displayString:String
        {
        return("LOCAL(\(self.shortName))")
        }
        
    internal var stackOffsetFromBasePointer:Int = 0
    
    override init(name:Name,class:Class)
        {
        super.init(shortName:name.first,class:`class`)
        }
    
    override init(shortName:Identifier,class:Class)
        {
        super.init(shortName:shortName,class:`class`)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    override func generateIntermediateCodeLoad(target:ThreeAddress,into buffer:ThreeAddressInstructionBuffer)
        {
        buffer.emitInstruction(result:target,left:self,opcode:.assign)
        }
}
