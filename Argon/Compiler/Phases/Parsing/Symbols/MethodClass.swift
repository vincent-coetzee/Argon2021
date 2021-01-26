//
//  MethodClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class ExecutableClass:Class
    {
    let argumentClasses:[Class]
    let returnTypeClass:Class
    
    init(shortName:String,argumentClasses:[Class],returnTypeClass:Class)
        {
        self.argumentClasses = argumentClasses
        self.returnTypeClass = returnTypeClass
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    }

public class MethodClass:Class
    {
    }

public class MethodInstanceClass:ExecutableClass
    {
    }

public class FunctionClass:ExecutableClass
    {
    }
    
public class ClosureClass:ExecutableClass
    {
    }
