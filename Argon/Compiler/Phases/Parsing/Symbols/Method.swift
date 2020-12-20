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
}
