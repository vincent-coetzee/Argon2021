//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Cocoa

public class Method:Symbol,NSCoding
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
        
    public override var image:NSImage
        {
        return(NSImage(named:"IconMethod64")!)
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
        
    public override func encode(with coder:NSCoder)
        {
        super.encode(with:coder)
        coder.encode(self.instances,forKey:"instances")
        }
        
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    public required init?(coder:NSCoder)
        {
        self.instances = coder.decodeObject(forKey:"instances") as! Array<MethodInstance>
        super.init(coder:coder)
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
        
   public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptMethod(self)
        }
}

