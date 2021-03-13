//
//  Block.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Block:Statement
    {
    static func ==(lhs:Block,rhs:Block) -> Bool
        {
        return(lhs.statements == rhs.statements && lhs.localVariables == rhs.localVariables)
        }
        
    internal var lastStatementIsNotReturn:Bool
        {
        if self.statements.isEmpty
            {
            return(true)
            }
        let last = self.statements.last!
        return(!last.isReturnStatement)
        }
        
    internal var blockLocalVariables:[LocalVariable]
        {
        return(self.localVariables.values.map{$0 as! LocalVariable})
        }
        
    internal var statements:[Statement] = []
    internal var localVariables = Dictionary<String,LocalVariable>()
    internal var marker:Int?
    internal var container:SymbolContainer = .nothing
    
    convenience init(container:SymbolContainer)
        {        
        self.init()
        self.container = container
        }
        
    init(block:Block)
        {
        self.statements = block.statements
        self.localVariables = block.localVariables
        self.marker = block.marker
        }
    
    init(statement:Statement)
        {
        }
        
    init(inductionVariable:InductionVariable)
        {
        self.marker = Argon.nextIndex()
        super.init()
        self.addLocalVariable(inductionVariable)
        }
        
    override init(location:SourceLocation = .zero)
        {
        super.init(location:location)
        }
        
    init()
        {
        super.init(location:.zero)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        for statement in self.statements
            {
            try statement.allocateAddresses(using:compiler)
            }
        fatalError("")
        }
        
    internal var lastStatement:Statement
        {
        return(self.statements.last!)
        }
        
    
    internal func addLocalVariable(_ variable:LocalVariable)
        {
        self.localVariables[variable.shortName] = variable
        }
        
    internal override func addStatement(_ statement:Statement?)
        {
        if let aLine = statement
            {
            self.statements.append(aLine)
            }
        }

    internal func setStatements(_ statements:[Statement])
        {
        self.statements = statements
        }
        
    public override func lookup(shortName:String) -> SymbolSet
        {
        if let variable = self.localVariables[shortName]
            {
            return(SymbolSet(variable))
            }
        return(self.container.lookup(shortName:shortName))
        }
        
    public override func lookup(name:Name) -> SymbolSet
        {
        if name.isAnchored
            {
            return(Module.rootModule.lookup(name:name))
            }
        if let variable = self.localVariables[name.first]
            {
            return(SymbolSet(variable))
            }
        return(self.container.lookup(name:name))
        }
        
    internal override func lookupMethod(shortName:String) -> Method?
        {
        return(self.container.lookupMethod(shortName:shortName))
        }
        
    public override func typeCheck() throws
        {
        for statement in self.statements
            {
            try statement.typeCheck()
            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        // TODO: Add check for reachability of artifical return I add at end here
        for statement in self.statements
            {
            try statement.generateIntermediateCode(in: module,codeHolder:CodeHolder.block(self), into: buffer, using: using)
            }
        }
    }
