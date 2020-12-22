//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class Method:Symbol
    {
    private var instances:[MethodInstance] = []
    
    public var parameterTypes:[Type]
        {
        fatalError("This should have been defined in the method instance")
        }
        
    public var returnType:Type
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
}
