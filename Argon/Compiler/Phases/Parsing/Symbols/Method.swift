//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class Method:Symbol
    { 
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
        
    enum CodingKeys:String,CodingKey
        {
        case instances
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.instances = try values.decode(Array<MethodInstance>.self,forKey:.instances)
        try super.init(from: values.superDecoder())
        self.memoryAddress = Compiler.shared.codeSegment.zero
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.instances,forKey:.instances)
        try super.encode(to: container.superEncoder())
        }
        
    public init(shortName:String)
        {
        super.init(shortName:shortName)
        self.memoryAddress = Compiler.shared.codeSegment.zero
        }
        
    internal override func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
        super.relinkSymbolsUsingIds(symbols:symbols)
        for instance in self.instances
            {
            instance.relinkSymbolsUsingIds(symbols:symbols)
            }
        }
        
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        compiler.codeSegment.updateAddress(self)
        for instance in self.instances
            {
            try instance.allocateAddresses(using:compiler)
            }
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
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using compiler:Compiler) throws
        {
        for instance in self.instances
            {
            try instance.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:compiler)
            }
        }
        
    public override func dump()
        {
        print("\(Swift.type(of:self)) \(self.shortName)")
        }
}
