//
//  ModuleImport.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/17.
//

import Foundation

public class Import:Symbol
    {
    public var exportedSymbolsByShortName:Dictionary<String,Symbol>
        {
        if let module = self.importedModule
            {
            return(module.exportedSymbols.reduce(into:[:]){ dictionary,symbol in dictionary[symbol.shortName] = symbol})
            }
        return([:])
        }
        
    let path:String?
    var isPathBased = true
    var importedModule:Module?
    
    init(shortName:String,path:String?)
        {
        self.path = path
        super.init(shortName:shortName)
        self.loadModule()
        }
    
    init(name:Name,path:String?)
        {
        self.path = path
        super.init(shortName:name.first)
        self.loadModule()
        }
        
    init(shortName:String)
        {
        self.path = nil
        super.init(shortName:shortName)
//        self.importedModule = Module.rootModule.lookup
        }
        
    private func loadModule()
        {
        }
        
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    }

public struct ImportVector
    {
    public static func +(lhs:ImportVector,rhs:Import) -> ImportVector
        {
        var newVector = lhs
        newVector.imports.append(rhs)
        return(newVector)
        }
        
    @discardableResult
    public static func +=(lhs:inout ImportVector,rhs:Import) -> ImportVector
        {
        lhs.imports.append(rhs)
        return(lhs)
        }
        
    private var imports:[Import] = []
    private var cachedSymbolsByImport:[Import:[String:Symbol]] = [:]

    func lookup(shortName:String) -> SymbolSet?
        {
        for section in self.imports
            {
            if let cachedSymbols = self.cachedSymbolsByImport[section]
                {
                if let symbol = cachedSymbols[shortName]
                    {
                    return(SymbolSet(symbol))
                    }
                }
            else
                {
                let cachedSymbols = section.exportedSymbolsByShortName
                }
            }
        return(SymbolSet())
        }
    }
