//
//  LocalVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class LocalVariable:Variable,NSCoding
    {
    public override var displayString:String
        {
        return("LOCAL(\(self.shortName))")
        }
        
    internal var stackOffsetFromBasePointer:Int = 0
    
    override init(name:Name,class:Class)
        {
        super.init(shortName:name.first,class:`class`)
        self.memoryAddress = Compiler.shared.stackSegment.zero
        }
    
    override init(shortName:String,class:Class)
        {
        super.init(shortName:shortName,class:`class`)
        self.memoryAddress = Compiler.shared.stackSegment.zero
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public override func encode(with coder:NSCoder)
        {
        coder.encode(self.stackOffsetFromBasePointer, forKey:"stackOffsetFromBasePointer")
        super.encode(with:coder)
        }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        }
        
    override func generateIntermediateCodeLoad(target:A3Address,into buffer:A3CodeBuffer)
        {
        buffer.emitInstruction(result:target,left:.localVariable(self),opcode:.assign)
        }
}
