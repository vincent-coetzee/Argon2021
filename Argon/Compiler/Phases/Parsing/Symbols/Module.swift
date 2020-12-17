//
//  Package.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Module:SymbolContainer
    {
    public static let rootModule = RootModule(shortName: "Argon")
        
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
        
    private var slices:[String:ModuleSlice] = [:]
    
    public private(set) var genericTypes:[GenericType] = []
    
    public override var isModuleLevelSymbol:Bool
        {
        return(true)
        }
        
    internal override func addSymbol(_ symbol:Symbol)
        {
        super.addSymbol(symbol)
        if symbol is ModuleSlice
            {
            (symbol as! ModuleSlice).module = self
            self.slices[symbol.shortName] = (symbol as! ModuleSlice)
            }
        }
        
    internal override func lookup(name:Name) -> SymbolSet?
        {
        if name.count == 0
            {
            return(SymbolSet(self))
            }
        for slice in self.slices.values
            {
            if let set = slice.lookup(name: name)
                {
                return(set)
                }
            }
        return(nil as SymbolSet?)
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        for slice in self.slices.values
            {
            if let set = slice.lookup(shortName: shortName)
                {
                return(set)
                }
            }
        if let set = super.lookup(shortName: shortName)
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }


