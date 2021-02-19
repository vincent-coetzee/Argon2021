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
    var wasResolved = false
    
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
        }
        
    private func loadModule()
        {
        // try and find the module in the central repository, if not make one up
        let module = ImportedModuleReference(shortName:self.shortName)
        Module.rootModule.addSymbol(module)
        }
        
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    override func lookup(name:Name) -> SymbolSet?
        {
        return(self.importedModule?.lookup(name:name))
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
        
    public var className:String
        {
        return("ImportVector")
        }
        
    public let id:UUID
    private var imports:[Import] = []
    private var cachedSymbolsByImport:[Import:[String:Symbol]] = [:]

    init()
        {
        self.id = UUID()
        }
        
    func lookup(name:Name) -> SymbolSet?
        {
        for anImport in self.imports
            {
            if let set = anImport.lookup(name:name)
                {
                return(set)
                }
            }
        return(nil)
        }
        
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
