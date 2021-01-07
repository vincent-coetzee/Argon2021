//
//  Statement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Statement:ParseNode,Equatable
    {
    public static func ==(lhs:Statement,rhs:Statement) -> Bool
        {
        fatalError("Function \(#function) should not have been called")
        }
        
    internal var location:SourceLocation = .zero
    
    public func typeCheck() throws
        {
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        fatalError("Not implemented")
        }
    }

