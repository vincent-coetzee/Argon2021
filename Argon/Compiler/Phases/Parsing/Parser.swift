//
//  Parser.swift
//  spark
//
//  Created by Vincent Coetzee on 09/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class Parser:CompilerPhase
    {
    internal var nextPhase:CompilerPhase?
        {
        return(TypeChecker())
        }
        
    internal var lineNumber:Int
        {
        return(self.token.location.line)
        }
        
    internal let name = "Parsing"
    @usableFromInline internal var token = Token.none
    internal var tokenIndex = 0
    private var tokens = Array<Token>()
    private var topModule:Module?
    private var tokenStream:TokenStream = TokenStream()
    private var accessModifierStack = Stack<AccessModifier>()
    private var isFirstModule = true
    private var lodgedIssues = CompilerIssues()
    
    public var effectiveAccessModifier:AccessModifier
        {
        return(self.accessModifierStack.peek())
        }
        
    internal func process(source:String,using compiler:Compiler) throws
        {
        self.loadTokens(from:source)
        self.advance()
        var module:Module?
        try self.parseAccessModifier
            {
            module = try self.parseModuleDeclaration()
            }
        if let aModule = module
            {
            compiler.module = aModule
            }
        compiler.issues.append(contentsOf:self.lodgedIssues)
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(module:Module,using compiler:Compiler) throws
        {
        print("halt")
        }
        
    private func loadTokens(from file:SourceFile)
        {
        let tokenStream = TokenStream(source:file.source)
        var aToken = tokenStream.nextToken()
        while !aToken.isEnd
            {
            self.tokens.append(aToken)
            aToken = tokenStream.nextToken()
            }
        self.tokens.append(aToken)
        self.tokenIndex = 0
        file.tokens = self.tokens
        }

    private func loadTokens(from source:String)
        {
        self.tokenStream = TokenStream(source:source)
        var aToken = self.tokenStream.nextToken()
        while !aToken.isEnd
            {
            self.tokens.append(aToken)
            aToken = self.tokenStream.nextToken()
            }
        self.tokens.append(aToken)
        self.tokenIndex = 0
        }
        
    @inlinable
    @inline(__always)
    internal func advance()
        {
        let index = self.tokenIndex
        self.tokenIndex += 1
        if index < self.tokens.count
            {
            self.token = self.tokens[index]
            }
        }
 
    private func lodgeError(_ error:SystemError,_ location:SourceLocation = .zero)
        {
        self.lodgedIssues.append(CompilerError(error,location))
        }
        
    private func lodgeError(_ error:CompilerError)
        {
        self.lodgedIssues.append(error)
        }
        
    private func lodgeError(_ error:Error)
        {
        let issue = CompilerError(error)
        self.lodgedIssues.append(issue)
        }
        
    private func lodgeWarning(_ error:SystemError,_ location:SourceLocation = .zero)
        {
        self.lodgedIssues.append(CompilerWarning(error,location))
        }
        
    internal func token(at index:Int) -> Token
        {
        return(self.tokens[self.tokenIndex + index])
        }
        
    private func pushAccessModifier(_ modifier:Token.Keyword)
        {
        self.accessModifierStack.push(AccessModifier(modifier))
        }
        
    private func popAccessModifier()
        {
        self.accessModifierStack.pop()
        }
        
    internal func parse(using:Compiler,sourceFile:SourceFile) throws
        {
        let module = try self.parseModuleDeclaration()
        sourceFile.module = module
        }
        
    internal func parseModule(source:String) -> Module?
        {
        do
            {
            self.loadTokens(from:source)
            self.advance()
            var module:Module?
            try self.parseAccessModifier
                {
                module = try self.parseModuleDeclaration()
                }
            return(module!)
            }
        catch let error as CompilerError
            {
            self.lodgeError(error)
            }
        catch let error
            {
            self.lodgeError(error)
            }
        return(nil)
        }
        
    @discardableResult
    private func parseModuleDeclaration() throws -> Module
        {
        self.advance()
        let moduleName = try self.parseIdentifier()
        var module = Module.currentScope.lookup(shortName: moduleName)?.first as? Module
        if module == nil
            {
            module = Module(shortName:moduleName)
            Module.currentScope.addSymbol(module!)
            }
        module!.pushScope()
        defer
            {
            module!.popScope()
            }
        self.topModule = module
        try self.parseBraces
            {
            try self.parseModuleElements()
            }
        module!.accessLevel = self.effectiveAccessModifier
        return(module!)
        }
        
    private func parseModuleElements() throws
        {
        let braceDepth = self.tokenStream.braceDepth
        do
            {
            repeat
                {
                try self.parseAccessModifier
                    {
                    if self.token.isOpaque
                        {
                        try self.parseOpaqueType()
                        }
                    else if self.token.isRefine
                        {
                        try self.parseRefineDeclaration()
                        }
                    else if self.token.isHandler
                        {
                        let statement = try self.parseHandlerStatement() as! HandlerStatement
                        let symbol = statement.asHandlerSymbol()
                        Module.currentScope.addSymbol(symbol)
                        }
                    else if self.token.isLet
                        {
                        try self.parseVariableDeclaration()
                        }
                    else if self.token.isEntry
                        {
                        self.topModule?.setEntry(try self.parseEntryDeclaration())
                        }
                    else if self.token.isExit
                        {
                        self.topModule?.setExit(try self.parseExitDeclaration())
                        }
                    else if self.token.isSlot
                        {
                        Module.currentScope.addSymbol(try self.parseSlotDeclaration(slotAttributes:[.module]))
                        }
                    else if self.token.isLocal
                        {
                        try self.parseLocalDeclaration()
                        }
                    else if self.token.isConstant
                        {
                        Module.currentScope.addSymbol(try self.parseConstantDeclaration())
                        }
                    else if self.token.isImport
                        {
                        try self.parseImportDeclaration()
                        }
                    else if self.token.isFunction
                        {
                        try self.parseFunctionDeclaration()
                        }
                    else if self.token.isMethod
                        {
                        try self.parseMethodDeclaration()
                        }
                    else if self.token.isEnumeration
                        {
                        try self.parseEnumerationDeclaration()
                        }
                    else if self.token.isBitSet
                        {
                        try self.parseBitSetDeclaration()
                        }
                    else if self.token.isClass
                        {
                        try self.parseStructuredTypeDeclaration()
                        }
                    else if self.token.isValue
                        {
                        try self.parseStructuredTypeDeclaration()
                        }
                    else if self.token.isType
                        {
                        try self.parseTypeDeclaration()
                        }
                    else if self.token.isModule
                        {
                        try self.parseModuleDeclaration()
                        }
                    else
                        {
                        throw(CompilerError(.moduleElementDeclarationExpected,self.token.location))
                        }
                    }
                }
            while !self.token.isRightBrace
            }
        catch let error as CompilerError
            {
            self.lodgeError(error)
            self.recover(fromBraceDepth: braceDepth)
            }
        catch let error
            {
            self.lodgeError(CompilerError(error))
            self.recover(fromBraceDepth: braceDepth)
            }
        }
        
    private func parseOpaqueType() throws
        {
        self.advance()
        if self.token.isClass || self.token.isValue
            {
            if let structure = try self.parseStructuredTypeDeclaration()
                {
                structure.becomeOpaque()
                }
            }
        }
        
    private func recover(fromBraceDepth depth:Int)
        {
        while !self.token.isEnd && !self.token.isRightBrace && self.tokenStream.braceDepth >= depth
            {
            self.advance()
            }
        }
        
    private func parseRefineDeclaration() throws
        {
        self.advance()
        let name = try self.parseName()
        if let set = Module.currentScope.lookup(name:name)
            {
            let item = set.first
            if item is Slot
                {
                try self.parseRefineSlot(item as! Slot)
                }
            else if item is Constant
                {
                try self.parseRefineConstant(item as! Constant)
                }
            else
                {
                self.lodgeError(.refineMustBeSlotClassOrConstant(self.token),self.token.location)
                }
            }
        }
        
    private func parseRefineSlot(_ slot:Slot) throws
        {
        let location = self.token.location
        var name = try self.parseIdentifier()
        if name != slot.shortName
            {
            self.lodgeError(.refinedSlotMustHaveOriginalName(slot.shortName,name),location)
            name = slot.shortName
            }
        self.advance()
        var value:Expression?
        if self.token.isAssign
            {
            self.advance()
            value = try self.parseExpression()
            }
        slot.container.replaceSlot(slot.cloned(withInitialValue:value))
        }
        
    private func parseRefineConstant(_ constant:Constant) throws
        {
        let location = self.token.location
        var name = try self.parseIdentifier()
        if name != constant.shortName
            {
            self.lodgeError(.refinedConstantMustHaveOriginalName(constant.shortName,name),location)
            name = constant.shortName
            }
        self.advance()
        var value:Expression?
        if !self.token.isAssign
            {
            self.lodgeError(.refinedConstantCanOnlyChangeValue,location)
            }
        else
            {
            self.advance()
            }
        value = try self.parseExpression()
        constant.container.replaceConstant(constant.cloned(withValue:value ?? Expression()))
        }
        
    private func parseEntryDeclaration() throws -> ModuleFunction
        {
        let function = ModuleFunction(shortName:"_ENTRY_")
        self.advance()
        try self.parseBraces
            {
            repeat
                {
                if let statement = try self.parseStatement()
                    {
                    function.addStatement(statement)
                    }
                }
            while !self.token.isRightBrace
            }
        return(function)
        }
        
    private func parseExitDeclaration() throws -> ModuleFunction
        {
        let function = ModuleFunction(shortName:"_EXIT_")
        self.advance()
        try self.parseBraces
            {
            repeat
                {
                if let statement = try self.parseStatement()
                    {
                    function.addStatement(statement)
                    }
                }
            while !self.token.isRightBrace
            }
        return(function)
        }
        
    @inline(__always)
    private func parseBraces(_ closure:() throws -> Void) throws
        {
        if self.token.isLeftBrace
            {
            self.advance()
            }
        else
            {
            throw(CompilerError(.leftBraceExpected,self.token.location))
            }
        try closure()
        if self.token.isRightBrace
            {
            self.advance()
            }
        else
            {
            throw(CompilerError(.rightBraceExpected,self.token.location))
            }
        }
        
    private func parseAccessModifier(_ closure:() throws -> Void) throws
        {
        var wasPushed = false
        if self.token.isAccessModifier
            {
            self.pushAccessModifier(self.token.keyword)
            self.advance()
            wasPushed = true
            }
        try closure()
        if wasPushed
            {
            self.popAccessModifier()
            }
        }
        
    private func parseLocalDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let localVariable = LocalVariable(shortName: name,class:.voidClass)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseTypeClass()
            localVariable._class = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            localVariable.initialValue = expression
            }
        localVariable.addDeclaration(location: location)
        Module.currentScope.addSymbol(localVariable)
        }
        
    private func parseConstantDeclaration() throws -> Constant
        {
        self.advance()
        let location = self.token.location
        var name = try self.parseIdentifier()
        if name.prefix(1) != "$"
            {
            self.lodgeError(.prefixOfConstantNameShouldBeDollar,self.token.location)
            name = "$" + name
            }
        let constant = Constant(shortName: name,class:.voidClass)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseTypeClass()
            constant._class = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            constant.initialValue = expression
            }
        constant.addDeclaration(location: location)
        constant.accessLevel = self.effectiveAccessModifier
        return(constant)
        }
        
    private func parseImportDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseName()
        var path = ""
        var isPathBased = false
        if self.token.isLeftPar
            {
            try self.parseParentheses
                {
                if !self.token.isCompoundIdentifier && !self.token.isIdentifier
                    {
                    throw(CompilerError(.identifierExpected,self.token.location))
                    }
                path = self.token.isIdentifier ? self.token.identifier : self.token.compoundIdentifier
                isPathBased = true
                self.advance()
                }
            }
        let moduleImport = Import(name:name,path:path)
        moduleImport.addDeclaration(location: location)
        Module.currentScope.addSymbol(moduleImport)
        }
        
    private func parseVariableDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let variable = Variable(shortName: name,class:.voidClass)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseTypeClass()
            variable._class = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            variable.initialValue = expression
            }
        variable.addDeclaration(location: location)
        Module.currentScope.addSymbol(variable)
        }
        
    private func parseFunctionDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        if !self.token.isLeftPar
            {
            throw(CompilerError(.leftParExpected,self.token.location))
            }
        self.advance()
        let libraryName = try self.parseIdentifier()
        if !self.token.isComma
            {
            throw(CompilerError(.properFunctionNameExpected,self.token.location))
            }
        self.advance()
        let cName = try self.parseIdentifier()
        if !self.token.isRightPar
            {
            throw(CompilerError(error: .rightParExpected,location: self.token.location,hint:"parseFunctionDeclaration"))
            }
        self.advance()
        let name = try self.parseIdentifier()
        let function = Function(shortName: name)
        function.libraryName = libraryName
        function.cName = cName
        let parameters = try self.parseFormalParameters()
        function.parameters = parameters
        if self.token.isRightArrow
            {
            self.advance()
            let type = try self.parseTypeClass()
            function.returnTypeClass = type
            }
        Module.currentScope.addSymbol(function)
        function.addDeclaration(location: location)
        function.accessLevel = self.effectiveAccessModifier
        }
    
    private func parseMethodDeclaration() throws
        {
        let start = self.token.location
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        var theMethod:Method
        if let method = Module.currentScope.lookup(shortName:name)?.first as? Method
            {
            theMethod = method
            }
        else
            {
            theMethod = Method(shortName:name)
            Module.currentScope.addSymbol(theMethod)
            }
        let parameters = try self.parseFormalParameters()
        var returnType:Class = .voidClass
        if self.token.isRightArrow
            {
            self.advance()
            returnType = try self.parseTypeClass()
            }
        let block = try self.parseBlock(parameters:parameters,container:Module.currentScope.asSymbolContainer())
        let instance = MethodInstance(shortName:name)
        instance.block = block
        instance.returnTypeClass = returnType
        instance.parameters = parameters
        instance.addDeclaration(location: location)
        let finish = self.token.location
        instance.source = self.tokenStream.source(from:start,to:finish)
        theMethod.addInstance(instance)
        theMethod.accessLevel = self.effectiveAccessModifier
        }
        
    private func parseEnumerationDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try parseIdentifier()
        var type:Class = Class.voidClass
        if self.token.isGluon
            {
            self.advance()
            type = try self.parseTypeClass()
            }
        let enumeration = Enumeration(shortName: name, class: type)
        try self.parseBraces
            {
            while !self.token.isRightBrace
                {
                let aCase = try self.parseEnumerationCase()
                enumeration.addCase(aCase)
                }
            }
        enumeration.addDeclaration(location: location)
        Module.currentScope.addSymbol(enumeration)
        enumeration.accessLevel = self.effectiveAccessModifier
        }
        
    private func parseEnumerationCase() throws -> EnumerationCase
        {
        if !self.token.isHashString
            {
            throw(CompilerError(.hashStringExpected,self.token.location))
            }
        let string = self.token.hashString
        self.advance()
        var typeList:Classes = []
        var valueExpression:Expression?
        if self.token.isLeftPar
            {
            try self.parseParentheses
                {
                repeat
                    {
                    if self.token.isComma
                        {
                        self.advance()
                        }
                    let type = try self.parseTypeClass()
                    typeList.append(type)
                    }
                while self.token.isComma
                }
            }
        if self.token.isAssign
            {
            self.advance()
            valueExpression = try self.parseExpression()
            }
        let enumCase = EnumerationCase(shortName: string, symbol: string, associatedTypes: typeList,value:valueExpression)
        return(enumCase)
        }
        
//    private func parseValueDeclaration() throws
//        {
//        self.advance()
//        let location = self.token.location
//        let name = try self.parseIdentifier()
//        var aClass:Class
//        if self.token.isLeftBrocket
//            {
//            let theClass = TemplateValueClass(shortName: name)
//            aClass = theClass
//            var types = Array<TypeVariable>()
//            try self.parseBrockets
//                {
//                types = try self.parseTypeVariables()
//                }
//            theClass.typeVariables = types
//            }
//        else
//            {
//            aClass = ValueClass(shortName:name)
//            }
//        aClass.addDeclaration(location: location)
//        Module.currentScope.addSymbol(aClass)
//        if self.token.isGluon
//            {
//            self.advance()
//            let name = try self.parseIdentifier()
//            let superclass = self.lookupClass(shortName: name)
//            aClass.superclasses = [superclass]
//            }
//        else
//            {
//            aClass.superclasses = [Class.valueClass]
//            }
//        for someClass in aClass.superclasses
//            {
//            someClass.subclasses.insert(aClass)
//            }
//        try self.parseBraces
//            {
//            repeat
//                {
//                if self.token.isSlotKeyword
//                    {
//                    let slot = try self.parseSlotDeclaration(slotAttributes: [.value])
//                    if slot.isRegularSlot
//                        {
//                        aClass.addRegularSlot(slot)
//                        }
//                    else
//                        {
//                        aClass.addClassSlot(slot)
//                        }
//                    }
//                else if self.token.isIdentifier && self.token.identifier == aClass.shortName
//                    {
//                    aClass.addMaker(try self.parseMakerDeclaration())
//                    }
//                else if self.token.isConstant
//                    {
//                    aClass.addConstant(try self.parseConstantDeclaration())
//                    }
//                else
//                    {
//                    throw(CompilerError(.valueElementExpected,self.token.location))
//                    }
//                }
//            while !self.token.isRightBrace
//            }
//        aClass.accessLevel = self.effectiveAccessModifier
//        }
        
    private func makeClassAndModulesOnPath(name:Name) -> Class
        {
        var module:Module
        if name.isAnchored
            {
            module = Module.rootModule
            }
        else
            {
            module = Module.currentModule
            }
        let className = name.last
        for part in name.withoutLast()
            {
            if let pathModule = module.lookupModule(shortName: part)
                {
                module = pathModule
                }
            else
                {
                let newModule = Module(shortName: part)
                newModule.wasDeclaredForward = true
                module.addSymbol(newModule)
                module = newModule
                }
            }
        let theClass = Class(shortName:className)
        theClass.wasDeclaredForward = true
        module.addSymbol(theClass)
        return(theClass)
        }
        
    @discardableResult
    private func parseStructuredTypeDeclaration() throws -> Class?
        {
        let braceDepth = self.tokenStream.braceDepth
        do
            {
            let isValue = self.token.isValue
            self.advance()
            let location = self.token.location
            let name = try self.parseIdentifier()
            var aClass:Class
            if self.token.isLeftBrocket
                {
                let theClass = isValue ? Class(shortName:name).becomeValue() : Class(shortName: name)
                var types = Array<TypeVariable>()
                try self.parseBrockets
                    {
                    types = try self.parseTypeVariables()
                    }
                theClass.typeVariables = types
                aClass = theClass
                }
            else
                {
                aClass = isValue ? Class(shortName:name).becomeValue() : Class(shortName: name)
                }
            Module.currentScope.addSymbol(aClass)
            var hasSuperclass = false
            if self.token.isGluon
                {
                self.advance()
                //
                // If it's ( then multiple superclasses
                //
                if self.token.isLeftPar && !isValue
                    {
                    try self.parseParentheses
                        {
                        aClass.superclasses = try self.parseSuperclasses()
                        hasSuperclass = true
                        }
                    }
                //
                // Else it should be a single identifier identifying a class or in the case
                // of a value it can only be a single supertype since value classes do not allow
                // for multiple supertypes
                //
                else
                    {
                    let name = try self.parseName()
                    if let superclass = Module.currentModule.lookupClass(name: name)
                        {
                        aClass.superclasses = [superclass]
                        }
                    else
                        {
                        let superclass = self.makeClassAndModulesOnPath(name:name)
                        aClass.superclasses = [superclass]
                        }
                    hasSuperclass = true
                    }
                }
            if !hasSuperclass
                {
                aClass.superclasses = [Class.objectClass]
                }
            for someClass in aClass.superclasses
                {
                someClass.subclasses.insert(aClass)
                }
            aClass.container = Module.currentScope.asSymbolContainer()
            aClass.pushScope()
            defer
                {
                aClass.popScope()
                }
            try self.parseBraces
                {
                repeat
                    {
                    if self.token.isAlias
                        {
                        let slot = try self.parseAliasSlotDeclaration()
                        if slot.isRegularSlot
                            {
                            aClass.addRegularSlot(slot)
                            }
                        else if slot.isClassSlot
                            {
                            aClass.addClassSlot(slot)
                            }
                        }
                    else if self.token.isSlotKeyword || self.token.isVirtual || self.token.isClass
                        {
                        let slot = try self.parseSlotDeclaration(slotAttributes: [.class])
                        if slot.isRegularSlot
                            {
                            aClass.addRegularSlot(slot)
                            }
                        else
                            {
                            aClass.addClassSlot(slot)
                            }
                        }
                    else if self.token.isIdentifier && self.token.identifier == aClass.shortName
                        {
                        aClass.addMaker(try self.parseMakerDeclaration())
                        }
                    else if self.token.isConstant
                        {
                        aClass.addConstant(try self.parseConstantDeclaration())
                        }
                    else
                        {
                        throw(CompilerError(.classElementExpected,self.token.location))
                        }
                    }
                while !self.token.isRightBrace
                }
            aClass.addDeclaration(location: location)
            aClass.accessLevel = self.effectiveAccessModifier
            return(aClass)
            }
        catch let error as CompilerError
            {
            self.lodgeError(error)
            self.recover(fromBraceDepth: braceDepth)
            }
        catch let error
            {
            self.lodgeError(CompilerError(error))
            self.recover(fromBraceDepth: braceDepth)
            }
        return(nil)
        }
        
    private func parseAliasSlotDeclaration() throws -> Slot
        {
        let location = self.token.location
        self.advance()
        if !self.token.isSlot
            {
            throw(CompilerError(.slotExpected,self.token.location))
            }
        self.advance()
        let name = try self.parseIdentifier()
        var expression:Expression?
        if self.token.isAssign
            {
            self.advance()
            expression = try self.parseExpression()
            }
        let slot = AliasSlot(shortName: name,attributes: .alias,expression:expression ?? VoidExpression())
        slot.addDeclaration(location: location)
        return(slot)
        }
        
    private func parseSlotDeclaration(slotAttributes:SlotAttributes) throws -> Slot
        {
        var slotMode = slotAttributes
        let location = self.token.location
        if self.token.isVirtual
            {
            slotMode.insert(.virtual)
            self.advance()
            }
        if self.token.isClass
            {
            slotMode.insert(.class)
            self.advance()
            }
        else
            {
            slotMode.insert(.regular)
            }
        if !self.token.isSlot
            {
            throw(CompilerError(.slotExpected,self.token.location))
            }
        self.advance()
        let name = try self.parseIdentifier()
        var type:Class = .voidClass
        if self.token.isGluon
            {
            self.advance()
            type = try self.parseTypeClass()
            }
        var initialValue:Expression?
        if self.token.isAssign
            {
            self.advance()
            initialValue = try self.parseExpression()
            }
        var readBlock:VirtualSlotReadBlock?
        var writeBlock:VirtualSlotWriteBlock?
        if self.token.isLeftBrace
            {
            try self.parseBraces
                {
                (readBlock,writeBlock) = try self.parseVirtualSlotBlocks()
                }
            }
        var slot:Slot
        if slotMode.contains(.virtual)
            {
            slotMode.insert(writeBlock == nil ? SlotAttributes.readonly : SlotAttributes.readwrite)
            slot = VirtualSlot(shortName: name, class: type, attributes: slotMode)
            slot.initialValue = initialValue
            slot.virtualReadBlock = readBlock!
            if let block = writeBlock
                {
                slot.virtualWriteBlock = block
                }
            }
        else
            {
            slotMode.insert(SlotAttributes.readwrite)
            slot = Slot(shortName: name, class: type, attributes: slotMode)
            slot.initialValue = initialValue
            }
        slot.addDeclaration(location: location)
        slot.accessLevel = self.effectiveAccessModifier
        return(slot)
        }
        
    private func parseVirtualSlotBlocks() throws -> (VirtualSlotReadBlock,VirtualSlotWriteBlock?)
        {
        if !self.token.isRead
            {
            throw(CompilerError(.readExpected,self.token.location))
            }
        self.advance()
        let block = try self.parseBlock(Block())
        let readBlock = VirtualSlotReadBlock(block:block)
        var writeBlock:VirtualSlotWriteBlock?
        if self.token.isWrite
            {
            self.advance()
            writeBlock = VirtualSlotWriteBlock(block:try parseBlock(Block()))
            }
        return((readBlock,writeBlock))
        }
        
    private func parseMakerDeclaration() throws -> ClassMaker
        {
        let location = self.token.location
        let name = self.token.identifier
        self.advance()
        let parameters = try self.parseFormalParameters()
        let block = try self.parseBlock(parameters:parameters,container: Module.currentScope.asSymbolContainer())
        let maker = ClassMaker(shortName: name,parameters:parameters,block:block)
        maker.addDeclaration(location: location)
        return(maker)
        }
        
    private func parseSuperclasses() throws -> Classes
        {
        var superclassNames:[Name] = []
        repeat
            {
            if self.token.isComma
                {
                self.advance()
                }
            let name = try self.parseName()
            superclassNames.append(name)
            }
        while self.token.isComma
        let superclasses = superclassNames.map{self.lookupClass(name:$0)}
        return(superclasses)
        }
        
    private func lookupClass(shortName:String) -> Class
        {
        if let aClass = Module.currentScope.lookup(shortName:shortName)?.first as? Class
            {
            return(aClass)
            }
        let newClass = Class(shortName:shortName)
        newClass.wasDeclaredForward = true
        Module.currentScope.addSymbol(newClass)
        return(newClass)
        }
        
    private func lookupClass(name:Name) -> Class
        {
        if let aClass = Module.currentScope.lookup(name:name)?.first as? Class
            {
            return(aClass)
            }
        let newClass = self.makeClassAndModulesOnPath(name: name)
        return(newClass)
        }
        
    private func lookupClass(name:String) -> Class
        {
        if let aClass = Module.currentScope.lookup(shortName:name)?.first as? Class
            {
            return(aClass)
            }
        let newClass = Class(shortName:name)
        newClass.wasDeclaredForward = true
        Module.currentScope.addSymbol(newClass)
        return(newClass)
        }
        
    private func parseBrockets(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.leftBrocketExpected,self.token.location))
            }
        self.advance()
        try closure()
        if !self.token.isRightBrocket
            {
            throw(CompilerError(.rightBrocketExpected,self.token.location))
            }
        self.advance()
        }
        
    private func parseBrackets(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftBracket
            {
            throw(CompilerError(.leftBracketExpected,self.token.location))
            }
        self.advance()
        try closure()
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        }
        
    private func parseTypeVariables() throws -> Array<TypeVariable>
        {
        self.advance()
        var types = Array<TypeVariable>()
        repeat
            {
            if self.token.isComma
                {
                self.advance()
                }
            let name = try self.parseIdentifier()
            var constraints:Classes = []
            if self.token.isGluon
                {
                self.advance()
                if !self.token.isLeftPar
                    {
                    throw(CompilerError(.leftParExpected,self.token.location))
                    }
                self.advance()
                try self.parseParentheses
                    {
                    repeat
                        {
                        if self.token.isComma
                            {
                            self.advance()
                            }
                        let constraint:Class = try self.parseTypeClass()
                        constraints.append(constraint)
                        }
                    while self.token.isComma
                    }
                }
            let type = TypeVariable(shortName: name,constraints:constraints)
            types.append(type)
            }
        while self.token.isComma
        return(types)
        }
        
    private func parseTypeDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        if !self.token.isIs
            {
            throw(CompilerError(.isExpected,self.token.location))
            }
        self.advance()
        let baseType = try self.parseTypeClass()
        let alias = TypeSymbol(shortName: name, class: baseType)
        alias.addDeclaration(location: location)
        Module.currentScope.addTypeSymbol(alias)
        alias.accessLevel = self.effectiveAccessModifier
        }
        
    private func parseBitSetDeclaration() throws
        {
        self.advance()
        var valueKind:Class?
        var keyClass:Class? = nil
        try self.parseBrockets
            {
            valueKind = try self.parseTypeClass()
            if self.token.isComma
                {
                self.advance()
                keyClass = valueKind
                valueKind = try self.parseTypeClass()
                }
            }
        let setName = try self.parseIdentifier()
        if keyClass != nil
            {
            let bitSet = BitSet(shortName:setName,keyClass:keyClass!,valueClass:valueKind!)
            Module.currentScope.addSymbol(bitSet)
            let maker = BitSetMaker(shortName:bitSet.shortName,bitSet:bitSet)
            Module.currentScope.addSymbol(maker)
            return
            }
        let bitSet = BitSet(shortName:setName,keyClass:nil,valueClass:valueKind!)
        Module.currentScope.addSymbol(bitSet)
        try self.parseBraces
            {
            var currentOffset = Argon.Integer(0)
            var currentWidth = Argon.Integer(0)
            repeat
                {
                let name = try self.parseIdentifier()
                try self.parseParentheses
                    {
                    var offset:Argon.Integer
                    if self.token.isAdd
                        {
                        offset = currentOffset + currentWidth
                        currentOffset += currentWidth
                        self.advance()
                        }
                    else if self.token.isIntegerNumber
                        {
                        offset = self.token.integerValue
                        currentOffset = offset
                        self.advance()
                        }
                    else
                        {
                        throw(CompilerError(.plusOrIntegerLiteralExpectedInBitSetField,self.token.location))
                        }
                    if !self.token.isComma
                        {
                        throw(CompilerError(.commaExpected,self.token.location))
                        }
                    self.advance()
                    if self.token.isIntegerNumber
                        {
                        currentWidth = self.token.integerValue
                        bitSet.addField(BitSetField(name:name,offset:offset,width:currentWidth))
                        self.advance()
                        }
                    else
                        {
                        throw(CompilerError(.integerNumberExpected,self.token.location))
                        }
                    }
                }
            while self.token.isIdentifier
            }
        let maker = BitSetMaker(shortName:bitSet.shortName,bitSet:bitSet)
        Module.currentScope.addSymbol(maker)
        bitSet.accessLevel = self.effectiveAccessModifier
        }
        
    private func parseFormalParameters() throws -> Parameters
        {
        var parameters:Parameters = []
        try self.parseParentheses
            {
            repeat
                {
                var hasTag = true
                if self.token.isComma
                    {
                    self.advance()
                    }
                if self.token.isAssign
                    {
                    hasTag = false
                    self.advance()
                    }
                if !self.token.isRightPar
                    {
                    let tag = try self.parseTag()
                    let type = try self.parseTypeClass()
                    let parameter = Parameter(shortName:tag,type:type,hasTag:hasTag)
                    parameters.append(parameter)
                    }
                }
            while self.token.isComma
            }
        return(parameters)
        }
        
    @inline(__always)
    private func parseParentheses(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftPar
            {
            throw(CompilerError(.leftParExpected,self.token.location))
            }
        self.advance()
        try closure()
        if !self.token.isRightPar
            {
            throw(CompilerError(error: .rightParExpected,location: self.token.location,hint:"parseParenthses"))
            }
        self.advance()
        }
        
    @inline(__always)
    private func parseParentheses<T>(_ closure:() throws -> T) throws -> T
        {
        if !self.token.isLeftPar
            {
            throw(CompilerError(.leftParExpected,self.token.location))
            }
        self.advance()
        let result = try closure()
        if !self.token.isRightPar
            {
            throw(CompilerError(error: .rightParExpected,location: self.token.location,hint:"parseParentheses"))
            }
        self.advance()
        return(result)
        }
        
    private func parseNativeTypeClass(_ aToken:Token) throws -> Class
        {
        var aClass:Class = .voidClass
        switch(aToken)
            {
            case .nativeType(let keyword,_):
            switch(keyword)
                {
                case .Integer:
                    aClass = .integerClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Integer8:
                    aClass = .integer8Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Integer16:
                    aClass = .integer16Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Integer32:
                    aClass = .integer32Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Integer64:
                    aClass = .integer64Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .UInteger:
                    aClass = .uIntegerClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .UInteger8:
                    aClass = .uInteger8Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .UInteger16:
                    aClass = .uInteger16Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .UInteger32:
                    aClass = .uInteger32Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .UInteger64:
                    aClass = .uInteger64Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Float:
                    aClass = .floatClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Float16:
                    aClass = .float16Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Float32:
                    aClass = .float32Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Float64:
                    aClass = .float64Class
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Boolean:
                    aClass = .booleanClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .String:
                    aClass = .stringClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Character:
                    aClass = .characterClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Void:
                    aClass = .voidClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Symbol:
                    aClass = .symbolClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Object:
                    aClass = .objectClass
                case .Date:
                    aClass = .dateClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Time:
                    aClass = .timeClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .DateTime:
                    aClass = .dateTimeClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Byte:
                    aClass = .byteClass
                    aClass = try self.parseBaseTypeReduction(aClass)
                case .Pointer:
                    aClass = try self.parsePointerType()
                case .Array:
                    aClass = try self.parseArrayType()
                case .List:
                    aClass = try self.parseListType()
                case .Set:
                    aClass = try self.parseSetType()
                case .Dictionary:
                    aClass = try self.parseDictionaryType()
                default:
                    fatalError("Unhandled native type")
                }
        default:
            fatalError("This should not happen")
        }
    return(aClass)
    }
        
    private func parseTypeClass() throws -> Class
        {
        var theClass:Class = .voidClass
        if self.token.isBackSlash || self.token.isIdentifier
            {
            var prefixedWithAnchor = false
            if !self.token.isIdentifier
                {
                prefixedWithAnchor = true
                self.advance()
                }
            var name = try self.parseName()
            name = prefixedWithAnchor ? name.anchored() : name
            if name.isAnchored
                {
                if let object = Module.rootScope.lookup(name:name)?.first
                    {
                    theClass = object.typeClass
                    }
                }
            else if let object = Module.currentScope.lookup(name:name)?.first
                {
                theClass = object.typeClass
                }
            else
                {
                theClass = FullyQualifiedName(name:name)
                }
            }
        else if self.token.isCompoundIdentifier
            {
            let name = Name(self.token.compoundIdentifier)
            self.advance()
            if let object = name.isAnchored ? Module.rootScope.lookup(name:name)?.first : Module.currentScope.lookup(name:name)?.first
                {
                theClass = object.typeClass
                }
            else
                {
                theClass = FullyQualifiedName(name:name)
                }
            }
        else if self.token.isNativeType
            {
            theClass = try self.parseNativeTypeClass(self.token)
            }
        else if self.token.isPointer
            {
            self.advance()
            if !self.token.isLeftBrocket
                {
                throw(CompilerError(.leftBrocketExpected,self.token.location))
                }
            self.advance()
            let elementType = try self.parseTypeClass()
            if !self.token.isRightBrocket
                {
                throw(CompilerError(.rightBrocketExpected,self.token.location))
                }
            self.advance()
            let pointer = Module.argonModule.lookupClass(name: Name("Pointer"))!
            return(pointer.specialize(elementType:elementType))
            }
        else if token.isLeftPar
            {
            self.advance()
            var types = Classes()
            repeat
                {
                if self.token.isComma
                    {
                    self.advance()
                    }
                types.append(try self.parseTypeClass())
                }
            while self.token.isComma
            if !self.token.isRightPar
                {
                throw(CompilerError(error: .rightParExpected,location: self.token.location,hint:"parseTypeClass"))
                }
            self.advance()
            theClass = TupleClass(elements: types)
            }
        if theClass.isGeneric && !self.token.isLeftBrocket
            {
            self.lodgeError(.typeVariableExpected,self.token.location)
            theClass = theClass.specialize(with: Array<Class>(repeating: .voidClass,count:theClass.typeArity))
            }
        else
            {
            self.advance()
            if theClass.isArray
                {
                let index = try self.parseArrayIndexType()
                if !theClass.isGeneric
                    {
                    return(theClass.instanciateArray(withIndex:index))
                    }
                }
            var typeVariables = Array<Class>()
            while !self.token.isRightBrocket
                {
                var name = Name()
                if !(self.token.isIdentifier || self.token.isCompoundIdentifier)
                    {
                    self.lodgeError(.identifierExpected,self.token.location)
                    name = Name("Name\(Argon.nextIndex())")
                    }
                else
                    {
                    name = try self.parseName()
                    if let aClass = Module.currentScope.lookup(name:name)?.first as? Class
                        {
                        typeVariables.append(aClass)
                        }
                    }
                if self.token.isComma
                    {
                    self.advance()
                    }
                }
            if typeVariables.count != theClass.typeArity
                {
                self.lodgeError(.classExpectedCountTypesButGot(theClass.typeArity,typeVariables.count),self.token.location)
                typeVariables = Array<Class>(repeating:.voidClass,count:theClass.typeArity)
                }
            theClass = theClass.specialize(with:typeVariables)
            self.advance()
            }
        return(theClass)
        }
        
    @discardableResult
    private func parseBaseTypeReduction(_ aClass:Class) throws -> Class
        {
        self.advance()
        if !self.token.isGluon
            {
            return(aClass)
            }
        self.advance()
        if !self.token.isLeftBracket
            {
            return(aClass)
            }
        if aClass == .stringClass || aClass == .voidClass || aClass == .characterClass || aClass == .byteClass
            {
            return(aClass)
            }
        if aClass == .integerClass || aClass == .integer64Class || aClass == .integer32Class || aClass == .integer16Class || aClass == .integer8Class || aClass == .uIntegerClass || aClass == .uInteger64Class || aClass == .uInteger32Class || aClass == .uInteger16Class || aClass == .uInteger8Class || aClass == .booleanClass || aClass == .dateClass || aClass == .timeClass || aClass == .dateTimeClass || aClass == .byteClass
            {
            if aClass == .dateClass
                {
                fatalError("Handle reduction of dates")
                }
            else if aClass == .booleanClass
                {
                fatalError("Handle reduction of booleans")
                }
            else if aClass == .timeClass
                {
                fatalError("Handle reduction of times")
                }
            else if aClass == .dateTimeClass
                {
                fatalError("Handle reduction of date times")
                }
            else if aClass == .byteClass
                {
                fatalError("Handle reduction of Bytes")
                }
            }
        if self.token.isLeftBracket
            {
            self.advance()
            if !self.token.isIntegerNumber
                {
                throw(CompilerError(.integerNumberExpected,self.token.location))
                }
            let startInteger = self.token.integerValue
            self.advance()
            if !self.token.isFullRange && !self.token.isHalfRange
                {
                throw(CompilerError(.fullOrHalfRangeExpected,self.token.location))
                }
            let range = self.token.symbol
            self.advance()
            if !self.token.isIntegerNumber
                {
                throw(CompilerError(.integerNumberExpected,self.token.location))
                }
            let endInteger = self.token.integerValue
            self.advance()
            if !self.token.isRightBracket
                {
                throw(CompilerError(.rightBracketExpected,self.token.location))
                }
            self.advance()
            let module = Module.rootModule.lookupModule(name: Name("Argon\\Collections"))
            let generator = SequenceGeneratorClass(baseClass: aClass, start: LiteralIntegerExpression(integer: startInteger), step: Expression(), end: LiteralIntegerExpression(integer: endInteger),range:range)
            generator.container = .module(module!)
            return(generator)
            }
        else
            {
            fatalError("This needs to be handled and is not ")
            }
        }

    @discardableResult
    private func parseArrayIndexType() throws -> Type.ArrayIndexType
        {
        if self.token.isIntegerNumber
            {
            let lower = self.token.integer
            self.advance()
            if self.token.isHalfRange || self.token.isFullRange
                {
                let rangeOperator = self.token.symbol
                self.advance()
                if !self.token.isIntegerNumber
                    {
                    throw(CompilerError(.integerNumberExpected,self.token.location))
                    }
                let amount = Int64((rangeOperator == .halfRange) ? 1 : 0)
                let value = self.token.integer - amount
                self.advance()
                return(.bounded(lowerBound:lower,upperBound:value))
                }
            else
                {
                return(.size(lower))
                }
            }
        else if self.token.isIdentifier || self.token.isCompoundIdentifier
            {
            let name = try self.parseName()
            if let result = Module.currentScope.lookup(name: name)?.first
                {
                if let enumeration = result as? Enumeration
                    {
                    return(.enumeration(enumeration))
                    }
                else if let constant = result as? Constant,constant.isIntegerConstant
                    {
                    let lowerBound = constant.integerValue
                    if self.token.isHalfRange || self.token.isFullRange
                        {
                        let rangeOperator = self.token.symbol
                        self.advance()
                        if self.token.isIdentifier || self.token.isCompoundIdentifier
                            {
                            let newName = try self.parseName()
                            if let nextConstant = Module.currentScope.lookup(name: newName)?.first as? Constant,nextConstant.isIntegerConstant
                                {
                                let upperBound = nextConstant.integerValue
                                let amount = Int64((rangeOperator == .halfRange) ? 1 : 0)
                                let value = upperBound - amount
                                return(.bounded(lowerBound:lowerBound,upperBound:value))
                                }
                            else
                                {
                                self.lodgeError(.invalidArrayIndexType(""))
                                return(.size(0))
                                }
                            }
                        else if self.token.isIntegerNumber
                            {
                            let upperBound = self.token.integerValue
                            self.advance()
                            let amount = Int64((rangeOperator == .halfRange) ? 1 : 0)
                            let value = upperBound - amount
                            return(.bounded(lowerBound:lowerBound,upperBound:value))
                            }
                        else
                            {
                            self.lodgeError(.invalidArrayIndexType(""))
                            return(.size(0))
                            }
                        }
                    else
                        {
                        return(.size(lowerBound))
                        }
                    }
                else
                    {
                    self.lodgeError(CompilerError(.invalidArrayIndexType(name.stringName),self.token.location))
                    return(.size(0))
                    }
                }
            else
                {
                let enumeration = Enumeration(shortName:name.last,class: .voidClass)
                enumeration.wasDeclaredForward = true
                Module.currentScope.addSymbol(enumeration)
                }
            }
        return(.unbounded)
        }

    @discardableResult
    private func parseArrayType() throws -> Class
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.leftBrocketExpected,self.token.location))
            }
        self.advance()
        let indexType = try self.parseArrayIndexType()
        if !self.token.isComma
            {
            throw(CompilerError(.commaExpected,self.token.location))
            }
        self.advance()
        let elementTypeClass = try self.parseTypeClass()
        if !self.token.isRightBrocket
            {
            throw(CompilerError(.rightBrocketExpected,self.token.location))
            }
        self.advance()
        let arrayClass = Module.argonModule.lookupClass(name: Name("Collections\\Array"))!
        let aClass = arrayClass.specialize(indexType:indexType,elementType: elementTypeClass)
        return(aClass)
        }
        
    @discardableResult
    private func parsePointerType() throws -> Class
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.leftBrocketExpected,self.token.location))
            }
        self.advance()
        let elementType = try self.parseTypeClass()
        if !self.token.isRightBrocket
            {
            throw(CompilerError(.rightBrocketExpected,self.token.location))
            }
        let pointerClass = Module.argonModule.lookupClass(name: Name("Pointer"))!
        let specializedClass = pointerClass.specialize(with:[elementType])
        return(specializedClass)
        }

    @discardableResult
    private func parseListType() throws -> Class
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.leftBrocketExpected,self.token.location))
            }
        self.advance()
        let elementType = try self.parseTypeClass()
        if !self.token.isRightBrocket
            {
            throw(CompilerError(.rightBrocketExpected,self.token.location))
            }
        let listClass = Module.argonModule.lookupClass(name: Name("List"))!
        let specializedClass = listClass.specialize(elementType:elementType)
        return(specializedClass)
        }

    @discardableResult
    private func parseSetType() throws -> Class
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.leftBrocketExpected,self.token.location))
            }
        self.advance()
        let elementType = try self.parseTypeClass()
        if !self.token.isRightBrocket
            {
            throw(CompilerError(.rightBrocketExpected,self.token.location))
            }
        let setClass = Module.argonModule.lookupClass(name: Name("Set"))!
        let specializedClass = setClass.specialize(elementType:elementType)
        return(specializedClass)
        }
        
    @discardableResult
    private func parseDictionaryType() throws -> Class
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.leftBrocketExpected,self.token.location))
            }
        self.advance()
        let _ = try self.parseTypeClass()
        if !self.token.isComma
            {
            throw(CompilerError(.commaExpected,self.token.location))
            }
        let _ = try self.parseTypeClass()
        if !self.token.isRightBrocket
            {
            throw(CompilerError(.rightBrocketExpected,self.token.location))
            }
        let _ = Module.argonModule.lookupClass(name: Name("Dictionary"))!
//        let specializedClass = dictionaryClass.specialize(elementType:
        fatalError()
//        return(specializedClass)
        }
        
    private func parseIdentifier() throws -> Identifier
        {
        if self.token.isIdentifier
            {
            let identifier = self.token.identifier
            self.advance()
            return(identifier)
            }
        else if self.token.isKeyword
            {
            let identifier = self.token.keyword.rawValue
            self.advance()
            return(identifier)
            }
        throw(CompilerError(.identifierExpected,self.token.location))
        }
        
    private func parseName() throws -> Name
        {
        if self.token.isCompoundIdentifier
            {
            let name = Name(self.token.compoundIdentifier)
            self.advance()
            return(name)
            }
        else if token.isIdentifier
            {
            let name = Name(self.token.identifier)
            self.advance()
            return(name)
            }
        else
            {
            throw(CompilerError(.identifierOrCompoundIdentifierExpected(self.token),self.token.location))
            }
        }
        
    private func parseTag() throws -> String
        {
        var identifier = ""
        if self.token.isIdentifier
            {
            identifier = self.token.identifier
            self.advance()
            if self.token.isGluon
                {
                self.advance()
                }
            return(identifier)
            }
        throw(CompilerError(.tagExpected,self.token.location))
        }
        
    private func parseBlock(parameters:Parameters,container:SymbolContainer) throws -> Block
        {

        let block = Block(container:container)
        for parameter in parameters
            {
            block.addVariable(parameter)
            }
        try self.parseBlock(block)
        return(block)
        }
        
    @discardableResult
    private func parseBlock(_ block:Block) throws -> Block
        {
        block.pushScope()
        defer
            {
            block.popScope()
            }
        try self.parseBraces
            {
            let braceDepth = self.tokenStream.braceDepth
            do
                {
                repeat
                    {
                    block.addStatement(try self.parseStatement())
                    }
                while !self.token.isRightBrace
                }
            catch let error as CompilerError
                {
                self.lodgeError(error)
                self.recover(fromBraceDepth: braceDepth)
                }
            catch let error
                {
                self.lodgeError(CompilerError(error))
                self.recover(fromBraceDepth: braceDepth)
                }
            }
        return(block)
        }
        
    internal func parseClosure() throws -> Closure
        {
        let closure = Closure(shortName:"_CLOSURE_\(Argon.nextIndex())")
        closure.returnTypeClass = .voidClass
        closure.pushScope()
        defer
            {
            closure.popScope()
            }
        try self.parseBraces
            {
            if self.token.isUsing
                {
                self.advance()
                closure.parameters = try self.parseFormalParameters()
                if self.token.isRightArrow
                    {
                    self.advance()
                    let returnType = try self.parseTypeClass()
                    closure.returnTypeClass = returnType
                    }
                }
            repeat
                {
                closure.addStatement(try self.parseStatement())
                }
            while !self.token.isRightBrace
            }
        return(closure)
        }
        
    private func parseStatement() throws -> Statement?
        {
        if self.token.isType
            {
            try self.parseTypeDeclaration()
            return(nil)
            }
        else if self.token.isLocal
            {
            return(try self.parseLocalStatement())
            }
        else if self.token.isLet
            {
            return(try self.parseLetStatement())
            }
        else if self.token.isSelect
            {
            return(try self.parseSelectStatement())
            }
        else if self.token.isIf
            {
            return(try self.parseIfStatement())
            }
        else if self.token.isHandler
            {
            return(try self.parseHandlerStatement())
            }
        else if self.token.isSignal
            {
            return(try self.parseSignalStatement())
            }
        else if self.token.isFor
            {
            return(try self.parseForStatement())
            }
        else if self.token.isRepeat
            {
            return(try self.parseRepeatStatement())
            }
        else if self.token.isWhile
            {
            return(try self.parseWhileStatement())
            }
        else if self.token.isFork
            {
            return(try self.parseForkStatement())
            }
        else if self.token.isNext
            {
            return(try self.parseNextStatement())
            }
        else if self.token.isResume
            {
            return(try self.parseResumeStatement())
            }
        else if self.token.isReturn
            {
            return(try self.parseReturnStatement())
            }
        else if self.token.isTimes
            {
            return(try self.parseTimesStatement())
            }
        else
            {
            if self.tokens[self.tokenIndex].isIdentifier
                {
                return(try self.parseInvocationStatement())
                }
            else if self.token.isIdentifier && self.tokens[self.tokenIndex].isLeftPar
                {
                return(try self.parseInvocationStatement())
                }
            else if self.token.isIdentifier && self.tokens[self.tokenIndex].isBackSlash
                {
                return(try self.parseInvocationStatement())
                }
            else if self.token.isKeyword && self.tokens[self.tokenIndex].isLeftPar
                {
                return(try self.parseInvocationStatement())
                }
            else
                {
                return(try self.parseAssignmentStatement())
                }
            }
        }
        
    private func parseName(_ string:String) throws -> Name
        {
        var name = Name(string)
        while self.token.isBackSlash
            {
            self.advance()
            if self.token.isIdentifier
                {
                name += self.token.identifier
                self.advance()
                }
            }
        return(name)
        }
        
    private func parseInvocationStatement() throws -> Statement
        {
        var name:Name
        if self.token.isKeyword
            {
            name = Name(self.token.keyword.rawValue)
            self.advance()
            }
        else if self.token.isBackSlash
            {
            name = try self.parseName()
            }
        else
            {
            let identifier = self.token.identifier
            self.advance()
            if self.token.isBackSlash
                {
                name = try self.parseName(identifier)
                }
            else
                {
                name = Name(identifier)
                }
            }
        if !self.token.isLeftPar
            {
            throw(CompilerError(.leftParExpected,self.token.location))
            }
        let arguments = try self.parseArguments()
        return(InvocationStatement(name:name,arguments:arguments))
        }
        
    private func parseLetStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        if name == "pointer"
            {
            print("halt")
            }
        let variable = LocalVariable(shortName: name,class:.voidClass)
        if self.token.isGluon
            {
            self.advance()
            let typeClass = try self.parseTypeClass()
            variable._class = typeClass
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            variable.initialValue = expression
            }
        variable.addDeclaration(location: location)
        Module.currentScope.addLocalVariable(variable)
        return(LetStatement(location:location,variable:variable))
        }
        
    private func parseLocalStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let localVariable = LocalVariable(shortName: name,class:.voidClass)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseTypeClass()
            localVariable._class = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            localVariable.initialValue = expression
            }
        localVariable.addDeclaration(location: location)
        let statement = LocalStatement(localVariable:localVariable)
        Module.currentScope.addLocalVariable(localVariable)
        return(statement)
        }

    private func parseAssignmentStatement() throws -> Statement
        {
        let value = try self.parseLHSValue()
        if self.token.isAssign
            {
            self.advance()
            let rvalue = try self.parseExpression()
            let statement = AssignmentStatement(lvalue:value,rvalue:rvalue)
            statement.location = self.token.location
            return(statement)
            }
        throw(CompilerError(.assignExpected,self.token.location))
        }
        
    private func parseTimesStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var timesExpression:Expression? = nil
        try self.parseParentheses
            {
            timesExpression = try self.parseExpression()
            }
        return(TimesStatement(location:location,expression:timesExpression!,block:try self.parseBlock(Block())))
        }
        
    private func parseReturnStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var value:Expression? = nil
        let returnStatement = ReturnStatement()
        returnStatement.container = Module.currentScope.asSymbolContainer()
        try self.parseParentheses
            {
            if !self.token.isRightPar
                {
                value = try self.parseExpression()
                }
            }
        returnStatement.location = location
        returnStatement.value = value
        return(returnStatement)
        }
        
    private func parseResumeStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var signal:Expression?
        try self.parseParentheses
            {
            signal = try self.parseExpression()
            }
        return(ResumeStatement(location:location,signal:signal!))
        }
        
    private func parseNextStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let arguments = try self.parseArguments()
        let statement = NextStatement(location:location,arguments:arguments)
        return(statement)
        }
        
    private func parseSelectStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var selectionExpression:Expression?
        try self.parseParentheses
            {
            selectionExpression = try self.parseExpression()
            }
        let statement = SelectStatement(expression:selectionExpression!)
        statement.location = location
        let block = Block()
        block.container = Module.currentScope.asSymbolContainer()
        block.pushScope()
        defer
            {
            block.popScope()
            }
        try self.parseBraces
            {
            while self.token.isWhen
                {
                self.advance()
                var whenExpression:Expression?
                try self.parseParentheses
                    {
                    whenExpression = try self.parseExpression()
                    }
                statement.whenClauses.append(WhenClause(expression:whenExpression!,block:try self.parseBlock(block)))
                }
            if self.token.isOtherwise
                {
                self.advance()
                statement.otherwiseClause = OtherwiseClause(block:try self.parseBlock(Block(container:statement.container)))
                }
            }
        return(statement)
        }
        
    private func parseIfStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let condition = try self.parseExpression()
        let block = Block()
        let statement = IfStatement(condition:condition,block:try self.parseBlock(block))
        statement.location = location
        block.pushScope()
        defer
            {
            block.popScope()
            }
        while self.token.isElse
            {
            self.advance()
            if self.token.isIf
                {
                self.advance()
                let condition = try self.parseExpression()
                let elseIf = ElseIfClause(condition: condition, block:try self.parseBlock(Block()))
                statement.elseClauses.append(elseIf)
                }
            else
                {
                let clause = ElseClause(block:try self.parseBlock(Block()))
                statement.elseClauses.append(clause)
                }
            }
        return(statement)
        }
        
//    class Some::(None,Object) {}
//    [12,34,56]
//    [12->#hello,13->#goodbye]
//    !(12,13,14)
//    @(12/12/2020)
//    @(12:05:24)
//    performIt[n::string,argument::integer] => integer
//        (
//        let value = performIt[n::"vince",argument::0]
//        )
        
    private func parseHandlerStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var symbols = Array<String>()
        try self.parseParentheses
            {
            repeat
                {
                if self.token.isComma
                    {
                    self.advance()
                    }
                if !self.token.isHashString
                    {
                    throw(CompilerError(.hashStringExpected,self.token.location))
                    }
                symbols.append(self.token.hashString)
                self.advance()
                }
            while self.token.isComma
            }
        let block = Block()
        block.pushScope()
        var variable:InductionVariable?
        defer
            {
            block.popScope()
            }
        try self.parseBraces
            {
            if !self.token.isUsing
                {
                throw(CompilerError(.usingExpected,self.token.location))
                }
            self.advance()
            var inductionVariableName:String = ""
            try self.parseParentheses
                {
                inductionVariableName = try self.parseIdentifier()
                }
            variable = InductionVariable(shortName:inductionVariableName,class:.symbolClass)
            block.addInductionVariable(variable!)
            repeat
                {
                if let statement = try self.parseStatement()
                    {
                    block.addStatement(statement)
                    }
                }
            while !self.token.isRightBrace
            }
        variable!.addDeclaration(location: location)
        let statement = HandlerStatement(inductionVariable:variable!,block:block)
        statement.location = location
        return(statement)
        }
        
    private func parseSignalStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var signal:Expression?
        try self.parseParentheses
            {
            signal = try self.parseExpression()
            }
        return(SignalStatement(location:location,signal:signal!))
        }

    private func parseForStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        if !self.token.isIn
            {
            throw(CompilerError(.inExpected,self.token.location))
            }
        self.advance()
        if !self.token.isLeftBracket
            {
            throw(CompilerError(.leftBracketExpected,self.token.location))
            }
        self.advance()
        if !self.token.isFrom
            {
            throw(CompilerError(.fromExpected,self.token.location))
            }
        self.advance()
        if !self.token.isGluon
            {
            throw(CompilerError(.gluonExpected,self.token.location))
            }
        self.advance()
        let from = try self.parseExpression()
        if !self.token.isComma
            {
            throw(CompilerError(.commaExpected,self.token.location))
            }
        self.advance()
        if !self.token.isTo
            {
            throw(CompilerError(.toExpected,self.token.location))
            }
        self.advance()
        if !self.token.isGluon
            {
            throw(CompilerError(.gluonExpected,self.token.location))
            }
        self.advance()
        let to = try self.parseExpression()
        if !self.token.isComma
            {
            throw(CompilerError(.commaExpected,self.token.location))
            }
        self.advance()
        if !self.token.isBy
            {
            throw(CompilerError(.byExpected,self.token.location))
            }
        self.advance()
        if !self.token.isGluon
            {
            throw(CompilerError(.gluonExpected,self.token.location))
            }
        self.advance()
        let by = try self.parseExpression()
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        let inductionVariable = ForInductionVariable(shortName:name)
        let block = Block(inductionVariable: inductionVariable)
        inductionVariable.container = .block(block)
        try self.parseBlock(block)
        inductionVariable.addDeclaration(location: location)
        let statement = ForInStatement(location:location,inductionVariable:inductionVariable,from: from, to: to, by: by, block: block)
        return(statement)
        }
        
    private func parseRepeatStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let block = try self.parseBlock(Block())
        if !self.token.isWhile
            {
            throw(CompilerError(.whileExpected,self.token.location))
            }
        let condition = try self.parseExpression()
        return(RepeatStatement(location:location,condition:condition,block:block))
        }
        
    private func parseWhileStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let condition = try self.parseExpression()
        return(WhileStatement(location:location,condition:condition,block:try self.parseBlock(Block())))
        }
        
    private func parseForkStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var expression:Expression?
        try self.parseParentheses
            {
            expression = try self.parseExpression()
            }
        return(ForkStatement(location:location,expression:expression!))
        }
        
    internal func parseArguments() throws -> Arguments
        {
        var arguments = Arguments()
        var argumentIndex = 1
        try self.parseParentheses
            {
            while !self.token.isRightPar
                {
                if self.token.isComma
                    {
                    self.advance()
                    }
                arguments.append(try self.parseArgument(index:argumentIndex))
                argumentIndex += 1
                }
            }
        return(arguments)
        }
        
    private func parseArgument(index:Int) throws -> Argument
        {
        var tag:String?
        if (self.token.isIdentifier || self.token.isKeyword) && self.tokens[self.tokenIndex].isGluon
            {
            if self.token.isKeyword
                {
                tag = self.token.keyword.rawValue
                }
            else
                {
                tag = self.token.identifier
                }
            self.advance()
            self.advance()
            }
        let value = try self.parseExpression()
        return(Argument(tag:tag,value:value,index:index))
        }

    func parseLHSValue() throws -> LHSValue
        {
        var value:LHSValue?
        if self.token.isThis || self.token.isTHIS || self.token.isSuper
            {
            value = .pseudoVariable(self.token.keyword)
            self.advance()
            }
        else if self.token.isLeftPar
            {
            value = try self.parseParentheses
                {
                try self.parseLHSValue()
                }
            }
        else if self.token.isIdentifier
            {
            let name = self.token.identifier
            self.advance()
            if let object = Module.currentScope.lookup(shortName:name)?.first as? Variable
                {
                value = .variable(object)
                }
            else
                {
                let variable = Variable(shortName: name, class: .voidClass)
                variable.wasDeclaredForward = true
                value = .variable(variable)
                }
            }
        while self.token.isLeftBracket || self.token.isRightArrow
            {
            if self.token.isLeftBracket
                {
                var index:Expression?
                try self.parseBrackets
                    {
                    index = try self.parseExpression()
                    }
                value = .arrayAccess(value!,index!)
                }
            else if self.token.isRightArrow
                {
                self.advance()
                let slot = try self.parseExpression()
                value = .slotAccess(value!,slot)
                }
            }
        if value == nil
            {
            throw(CompilerError(.invalidExpression,self.token.location))
            }
        return(value!)
        }
        
    func parseExpression() throws -> Expression
        {
        var lhs = try self.parseSlotExpression()
        while self.token.isLogicalOperator
            {
            let action = self.token.symbol
            self.advance()
            lhs = LogicalExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseSlotExpression() throws -> Expression
        {
        var lhs = try self.parseBooleanExpression()
        while self.token.isRightArrow
            {
            self.advance()
            lhs = SlotExpression(target: lhs,slot:try self.parseExpression())
            }
        return(lhs)
        }
    
    func parseBooleanExpression() throws -> Expression
        {
        var lhs = try self.parseRelationalExpression()
        while self.token.isBooleanOperator
            {
            let action = self.token.symbol
            self.advance()
            lhs = BooleanExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseRelationalExpression() throws -> Expression
        {
        var lhs = try self.parseCastExpression()
        while self.token.isRelationalOperator
            {
            let action = self.token.symbol
            self.advance()
            lhs = RelationalExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseCastExpression() throws -> Expression
        {
        var lhs = try self.parseBitExpression()
        while self.token.isCastOperator
            {
            self.advance()
            lhs = CastExpression(lhs: lhs,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseBitExpression() throws -> Expression
        {
        var lhs = try self.parseAdditiveExpression()
        while self.token.isBitOperator
            {
            let action = self.token.symbol
            self.advance()
            lhs = BitExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseAdditiveExpression() throws -> Expression
        {
        var lhs = try self.parseMultiplicativeExpression()
        while self.token.isAdditionOperator
            {
            let action = self.token.symbol
            self.advance()
            lhs = AdditionExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseMultiplicativeExpression() throws -> Expression
        {
        var lhs = try self.parsePowerExpression()
        while self.token.isMultiplicationOperator
            {
            let action = self.token.symbol
            self.advance()
            lhs = MultiplicationExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parsePowerExpression() throws -> Expression
        {
        var lhs = try self.parseShiftExpression()
        while self.token.isPower
            {
            self.advance()
            lhs = PowerExpression(lhs: lhs,operation: .pow,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseShiftExpression() throws -> Expression
        {
        var lhs = try self.parseUnaryExpression()
        while self.token.isBitShiftLeft || self.token.isBitShiftRight
            {
            let action = self.token.symbol
            self.advance()
            lhs = ShiftExpression(lhs: lhs,operation: action,rhs: try self.parseExpression())
            }
        return(lhs)
        }
        
    func parseUnaryExpression() throws -> Expression
        {
        if self.token.isSub || self.token.isBitNot || self.token.isNot
            {
            let action = self.token.symbol
            self.advance()
            return(UnaryExpression(lhs: try self.parseUnaryExpression(),operation: action))
            }
        return(try self.parseTerm())
        }
        
    func parseThisExpression() throws -> Expression
        {
        if self.token.isRightArrow
            {
            return(try self.parseSlotTerm(expression: ThisExpression()))
            }
        return(ThisExpression())
        }
        
    func parseTHISExpression() throws -> Expression
        {
        if self.token.isRightArrow
            {
            self.advance()
            return(try self.parseSlotTerm(expression: THISExpression()))
            }
        return(THISExpression())
        }
        
    func parseTimeTerm(first:Expression) throws -> Expression
        {
        self.advance()
        let second = try self.parseExpression()
        if !self.token.isColon
            {
            throw(CompilerError(.timeComponentSeparatorExpected,self.token.location))
            }
        let third = try self.parseExpression()
        return(TimeValueExpression(hour: first,minute: second,second: third))
        }
        
    func parseDateTerm(first:Expression) throws -> Expression
        {
        self.advance()
        let second = try self.parseExpression()
        if !self.token.isForwardSlash
            {
            throw(CompilerError(.dateComponentSeparatorExpected,self.token.location))
            }
        let third = try self.parseExpression()
        if !self.token.isRightPar
            {
            let hour = try self.parseExpression()
            if !self.token.isColon
                {
                throw(CompilerError(.timeComponentSeparatorExpected,self.token.location))
                }
            self.advance()
            let minute = try self.parseExpression()
            if !self.token.isColon
                {
                throw(CompilerError(.timeComponentSeparatorExpected,self.token.location))
                }
            self.advance()
            let second = try self.parseExpression()
            return(DateTimeValueExpression(date: DateValueExpression(day: first,month: second,year: third),time: TimeValueExpression(hour: hour,minute: minute,second: second)))
            }
        return(DateValueExpression(day: first,month: second,year: third))
        }
        
    func parseDateExpression() throws -> Expression
        {
        var term:Expression?
        try self.parseParentheses
            {
            let first = try self.parseExpression()
            if self.token.isColon
                {
                term = try self.parseTimeTerm(first:first)
                }
            else if self.token.isForwardSlash
                {
                term = try self.parseDateTerm(first:first)
                }
            else
                {
                throw(CompilerError(.dateOrTimeExpressionExpected,self.token.location))
                }
            }
        return(term!)
        }
        
    func parseTerm() throws -> Expression
        {
        if self.token.isTypeKeyword
            {
            let type = try self.parseTypeClass()
            if self.token.isLeftPar
                {
                var arguments = Arguments()
                arguments = try self.parseArguments()
                return(TypeMakerInvocationExpression(class: type,arguments: arguments))
                }
            else if self.token.isRightArrow
                {
                return(SlotExpression(target:ClassExpression(class: type),slot: try self.parseExpression()))
                }
            return(LiteralClassExpression(class:type))
            }
        if self.token.isHollowVariableIdentifier
            {
            self.advance()
            return(VariableExpression(variable:HollowVariable.sharedInstance))
            }
        else if self.token.isTrue || self.token.isFalse
            {
            let local = self.token.isTrue
            self.advance()
            if local
                {
                return(LiteralBooleanExpression(boolean: true))
                }
            else
                {
                return(LiteralBooleanExpression(boolean: false))
                }
            }
        else if self.token.isAt
            {
            self.advance()
            return(try self.parseDateExpression())
            }
        else if self.token.isThis
            {
            self.advance()
            return(try self.parseThisExpression())
            }
        else if self.token.isTHIS
            {
            self.advance()
            return(try self.parseTHISExpression())
            }
        else if token.isNil
            {
            self.advance()
            return(NullExpression())
            }
        else if self.token.isLeftBracket
            {
            self.advance()
            return(try self.parseBracketedExpression())
            }
        else if self.token.isLeftPar
            {
            self.advance()
            return(try self.parseParenthesizedExpression())
            }
        else if self.token.isByte
            {
            let byteValue = self.token.byteValue
            self.advance()
            return(LiteralByteExpression(byte: byteValue))
            }
        else if self.token.isCharacter
            {
            let byteValue = self.token.characterValue
            self.advance()
            return(LiteralCharacterExpression(character: byteValue))
            }
        else if self.token.isIntegerNumber
            {
            let integerValue = self.token.integerValue
            self.advance()
            return(LiteralIntegerExpression(integer: integerValue))
            }
        else if self.token.isFloatingPointNumber
            {
            let byteValue = self.token.floatingPointValue
            self.advance()
            return(LiteralFloatExpression(float: byteValue))
            }
        else if self.token.isString
            {
            let byteValue = self.token.stringValue
            self.advance()
            return(LiteralStringExpression(string: byteValue))
            }
        else if self.token.isHashString
            {
            let byteValue = self.token.hashStringValue
            self.advance()
            return(LiteralSymbolExpression(symbol: byteValue))
            }
        else if self.token.isIdentifier || self.token.isKeyword || self.token.isCompoundIdentifier
            {
            let name = self.token.isCompoundIdentifier ? Name(self.token.compoundIdentifier) : (self.token.isKeyword ? Name(self.token.keyword.rawValue) : Name(self.token.identifier))
            self.advance()
            var object:Symbol?
            object = Module.currentScope.lookup(name:name)?.first
            if object != nil
                {
                return(try self.parseObjectTerm(name.stringName,object!))
                }
            let variable = Variable(shortName:name.stringName,class:.voidClass)
            variable.wasDeclaredForward = true
            return(ForwardVariableExpression(variable: variable))
            }
        else if self.token.isLeftBrace
            {
            return(ClosureExpression(closure: try self.parseClosure()))
            }
        else if self.token.isBackSlash
            {
            return(try self.parseQualifiedNameTerm())
            }
        else if self.token.isRightArrow
            {
            self.advance()
            let slotName = try self.parseIdentifier()
            return(InferredSlotExpression(slot: slotName))
            }
        else
            {
            fatalError("This should be an expression")
            }
        }
        
    private func parseQualifiedNameTerm() throws -> Expression
        {
        let name = try self.parseName()
        if let object = Module.rootScope.lookup(name:name)?.first
            {
            return(try self.parseObjectTerm(name.stringName,object))
            }
        fatalError("QualifiedNameTerm not handled properly")
        }
        
    private func parseSubscriptedTerm(expression:Expression) throws -> Expression
        {
        self.advance()
        let index = try self.parseExpression()
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(SubscriptExpression(target: expression,subscript: index))
        }
        
    private func parseSlotTerm(expression:Expression) throws -> Expression
        {
        var term:Expression = expression
        while self.token.isRightArrow
            {
            self.advance()
            //
            // if the arrow is object->23 that means 23rd slot as a pointer
            //
            if self.token.isInteger
                {
                term = SlotExpression(target: term,slot:IdentifierExpression(identifier: "\(self.token.integer)"))
                self.advance()
                }
            //
            // Else it's a normal slot
            //
            else
                {
                let name = try self.parseIdentifier()
                term = SlotExpression(target: term,slot:IdentifierExpression(identifier:name))
                }
            }
        return(term)
        }
        
    private func parseSlotOrSubscript(expression incomingExpression:Expression) throws -> Expression
        {
        var expression = incomingExpression
        while self.token.isLeftBracket || self.token.isRightArrow
            {
            if self.token.isLeftBracket
                {
                expression = try self.parseSubscriptedTerm(expression:expression)
                }
            else if self.token.isRightArrow
                {
                expression = try self.parseSlotTerm(expression:expression)
                }
            }
        return(expression)
        }
        
    func parseMakerInvocation(_ aClass:Class) throws -> Expression
        {
        let arguments = try self.parseArguments()
        return(ClassMakerInvocationExpression(class:aClass,arguments:arguments))
        }
        
    func parseGenericClassSpecialization(_ aClass:Class) throws -> Class
        {
        if !self.token.isLeftBrocket
            {
            throw(CompilerError(.typeSpecializationExpected,self.token.location))
            }
        self.advance()
        var classes:[Class] = []
        while !self.token.isRightBrocket
            {
            classes.append(try self.parseTypeClass())
            if self.token.isComma
                {
                self.advance()
                }
            }
        self.advance()
        return(aClass.specialize(with: classes))
        }
        
    func parseObjectTerm(_ identifier:String,_ object:Symbol) throws -> Expression
        {
        if object is Variable
            {
            let variable = object as! Variable
            if variable.canBeInvoked || self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                return(ClosureInvocationExpression(closure:VariableExpression(variable:variable),arguments:arguments))
                }
            var expression:Expression = VariableExpression(variable:variable)
            if self.token.isLeftBracket || self.token.isRightArrow
                {
                expression = try self.parseSlotOrSubscript(expression:expression)
                }
            return(expression)
            }
        else if object is Class
            {
            let aClass = object as! Class
            if aClass.isGenericClass
                {
                let specializedClass = try self.parseGenericClassSpecialization(aClass)
                if self.token.isLeftPar
                    {
                    return(try self.parseMakerInvocation(specializedClass))
                    }
                return(ClassExpression(class:specializedClass))
                }
            else
                {
                if self.token.isLeftPar
                    {
                    return(try self.parseMakerInvocation(aClass))
                    }
                return(ClassExpression(class:object as! Class))
                }
            }
        else if object is Closure
            {
            let closure = object as! Closure
            var expression:Expression
            if self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                expression = ClosureInvocationExpression(closure: ClosureExpression(closure:closure),arguments:arguments)
                if self.token.isStop || self.token.isLeftBracket
                    {
                    expression = try self.parseSlotOrSubscript(expression: expression)
                    }
                }
            else
                {
                return(ClosureExpression(closure: (object as! Closure)))
                }
            }
        else if object is Method
            {
            let method = object as! Method
            if self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                var expression:Expression = MethodInvocationExpression(methodName:method.shortName,method:method,arguments:arguments)
                if self.token.isStop || self.token.isLeftBracket
                    {
                    expression = try self.parseSlotOrSubscript(expression: expression)
                    }
                return(expression)
                }
            else
                {
                return(MethodExpression(method:object as! Method))
                }
            }
        else if object is Function
            {
            let function = object as! Function
            if self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                var expression:Expression = FunctionInvocationExpression(function: function,arguments: arguments)
                if self.token.isStop || self.token.isLeftBracket
                    {
                    expression = try self.parseSlotOrSubscript(expression: expression)
                    }
                return(expression)
                }
            else
                {
                return(FunctionInvocationExpression(function: object as! Function, arguments: []))
                }
            }
        else if object is Module
            {
            let module = object as! Module
            var expression:Expression = ModuleExpression(module: module)
            if self.token.isStop || self.token.isLeftBracket || self.token.isRightArrow
                {
                expression = try self.parseSlotOrSubscript(expression: expression)
                }
            return(expression)
            }
        else if object is Enumeration
            {
            let enumeration = object as! Enumeration
            let nextToken = self.token(at:1)
            if self.token.isStop && nextToken.isIdentifier && enumeration.hasCase(named: nextToken.identifier)
                {
                self.advance()
                self.advance()
                return(EnumerationCaseValueExpression(name: "\(enumeration.shortName)->\(nextToken.identifier)",enumeration: enumeration,case: enumeration.enumerationCase(named:nextToken.identifier)!))
                }
            return(LiteralEnumerationExpression(enumeration: enumeration))
            }
        else if object is BitSet
            {
            let bitSet = object as! BitSet
            if self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                if let method = Module.currentScope.lookupMethod(name: Name(bitSet.shortName))
                    {
                    return(MethodInvocationExpression(methodName: method.shortName, method:method, arguments: arguments))
                    }
                else
                    {
                    throw(CompilerError(.makerForBitSetShouldHaveBeenAutoDeclared,self.token.location))
                    }
                }
            }
        else
            {
            if self.token.isLeftPar
                {
                let arguments = try self.parseArguments()
                let aClass = Class(shortName:identifier)
                return(MakerInvocationExpression(class: aClass,arguments: arguments))
                }
            fatalError("ObjectTerm not handled completely - \(object)")
            }
        throw(CompilerError(.invalidTermInExpression,self.token.location))
        }
        
    private func parseParenthesizedExpression() throws -> Expression
        {
        let expression = try self.parseExpression()
        if self.token.isRightPar
            {
            self.advance()
            return(expression)
            }
        var expressions:[Expression] = [expression]
        while self.token.isComma
            {
            self.advance()
            expressions.append(try self.parseExpression())
            }
        if !self.token.isRightPar
            {
            throw(CompilerError(error: .rightParExpected,location: self.token.location,hint:"parseParenthesizedExpression"))
            }
        self.advance()
        return(TupleExpression(elements:expressions))
        }

    private func parseBracketedExpression() throws -> Expression
        {
        // { ?1 | ?1 ** 2, ?1 in 0..200 }
        //%( (x,y) | x,y : x in 0..<100,y in 100..<1000 )
        if self.token.isInteger
            {
            return(try self.parseLiteralIntegerArray())
            }
        else if self.token.isFloatingPointNumber
            {
            return(try self.parseLiteralFloatArray())
            }
        else if self.token.isString
            {
            return(try self.parseLiteralStringArray())
            }
        else if self.token.isHashString
            {
            return(try self.parseLiteralSymbolArray())
            }
        else if self.token.isIdentifier
            {
            return(try self.parseLiteralIdentifierArray())
            }
        else if self.token.isTrue || self.token.isFalse
            {
            return(try self.parseLiteralBooleanArray())
            }
        else if self.token.isCharacter
            {
            return(try self.parseLiteralCharacterArray())
            }
        else if self.token.isByte
            {
            return(try self.parseLiteralByteArray())
            }
        else
            {
            throw(CompilerError(.literalValueExpected,self.token.location))
            }
        }
        
    private func parseMacro() throws -> Macro
        {
        self.advance()
        let name = try self.parseIdentifier()
        var argumentNames = Array<String>()
        try self.parseParentheses
            {
            while !self.token.isRightPar
                {
                let argument = try self.parseIdentifier()
                argumentNames.append(argument)
                if self.token.isComma
                    {
                    self.advance()
                    }
                }
            }
        if !self.token.isMacroStart
            {
            throw(CompilerError(.macroStartMarkerExpected,self.token.location))
            }
        self.advance()
        let text = self.tokenStream.scanTextUntilMacroEndMarker()
        let macro = Macro(shortName:name,argumentNames:argumentNames,source:text)
        Module.currentScope.addSymbol(macro)
        return(macro)
        }
        
    private func parseLiteralIntegerArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isInteger
            {
            literals.append(LiteralIntegerExpression(integer:self.token.integer))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralFloatArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isFloatingPointNumber
            {
            literals.append(LiteralFloatExpression(float:self.token.floatingPointValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralStringArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isString
            {
            literals.append(LiteralStringExpression(string:self.token.string))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralSymbolArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isHashString
            {
            literals.append(LiteralSymbolExpression(symbol:self.token.hashString))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralIdentifierArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isIdentifier
            {
            literals.append(LiteralStringExpression(string:self.token.identifier))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralBooleanArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isTrue || self.token.isFalse
            {
            literals.append(LiteralBooleanExpression(boolean:self.token.booleanValue == .trueValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralCharacterArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isCharacter
            {
            literals.append(LiteralCharacterExpression(character:self.token.characterValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
        
    private func parseLiteralByteArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isByte
            {
            literals.append(LiteralByteExpression(byte:self.token.byteValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError(.rightBracketExpected,self.token.location))
            }
        self.advance()
        return(LiteralArrayExpression(array:literals))
        }
    }
