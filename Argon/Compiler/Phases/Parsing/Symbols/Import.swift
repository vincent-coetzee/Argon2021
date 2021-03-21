//
//  ModuleImport.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/17.
//

import Foundation

public class Import:Symbol,NSCoding
    {        
    private let path:String?
    private var isPathBased = true
    private var importedModule:Module?
    private var wasResolved = false
    
    init(name:Name,path:String?)
        {
        self.path = path
        super.init(shortName:name.first)
        self.loadModule()
        self.isPathBased = path != nil
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
        
    public override func encode(with coder:NSCoder)
        {
        super.encode(with:coder)
        coder.encode(self.path,forKey:"path")
        coder.encode(self.isPathBased,forKey:"isPathBased")
        coder.encode(self.importedModule,forKey:"importedModule")
        coder.encode(self.wasResolved,forKey:"wasResolved")
        }
        
    public override func lookup(name:Name) -> SymbolSet?
        {
        return(self.importedModule?.lookup(name:name))
        }
    }
