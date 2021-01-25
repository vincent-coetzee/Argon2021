//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class Method:Symbol,ThreeAddress
    {
    public override var recordKind:RecordKind
        {
        return(.method)
        }
        
    public var displayString: String
        {
        return(self.shortName)
        }
        
    private var instances:[MethodInstance] = []
    
    public var parameterTypes:[Type]
        {
        fatalError("This should have been defined in the method instance")
        }
        
    public var returnType:Type
        {
        fatalError("This should have been defined in the method instance")
        }
        
    public var returnTypeClass:Class
        {
        fatalError("This should have been defined in the method instance")
        }
        
    public init(shortName:String)
        {
        super.init(shortName:shortName)
        }
        
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    public required init(file:ObjectFile) throws
        {
        fatalError()
        }
        
    public func addInstance(_ instance:MethodInstance)
        {
        self.instances.append(instance)
        instance.symbolAdded(to: self)
        }
        
    public override func typeCheck() throws
        {
        for instance in self.instances
            {
            try instance.typeCheck()
            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using compiler:Compiler) throws
        {
        for instance in self.instances
            {
            try instance.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:compiler)
            }
        }
        
    public override func write(file: ObjectFile) throws
        {
        try super.write(file:file)
        for instance in self.instances
            {
            try instance.write(file:file)
            }
        }
        
    public override func dump()
        {
        print("\(Swift.type(of:self)) \(self.shortName)")
        }
}
