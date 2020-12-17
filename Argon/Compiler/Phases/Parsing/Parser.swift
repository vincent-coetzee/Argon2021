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
    internal var token = Token.none
    internal var tokenIndex = 0
    private var tokens = Array<Token>()

    private var accessModifierStack = Stack<AccessModifier>()
        
    public var effectiveAccessModifier:AccessModifier
        {
        return(self.accessModifierStack.peek())
        }
        
    internal func process(using compiler:Compiler) throws
        {
        for sourceFile in compiler.sourceFiles()
            {
            print("PROCESSING \(sourceFile.path)")
            self.loadTokens(from:sourceFile)
            self.advance()
            try self.parse(using: compiler,sourceFile:sourceFile)
            }
        
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

    internal func advance()
        {
        let index = self.tokenIndex
        self.tokenIndex += 1
        if index < self.tokens.count
            {
            self.token = self.tokens[index]
            }
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
        
    @discardableResult
    private func parseModuleDeclaration() throws -> Module
        {
        try self.assert(.module,error:.moduleExpected)
        let moduleName = try self.parseIdentifier()
        var module = Module.innerScope.lookup(shortName: moduleName)?.first as? Module
        if module == nil
            {
            module = Module(shortName:moduleName)
            Module.innerScope.addSymbol(module!)
            }
        if self.token.isLeftPar
            {
            self.advance()
            let sliceName = try self.parseIdentifier()
            if self.token.isRightPar
                {
                self.advance()
                let slice = ModuleSlice(shortName:sliceName,module:module!)
                module?.addSymbol(slice)
                }
            }
        module!.push()
        defer
            {
            module!.pop()
            }
        try self.parseBraces
            {
            try self.parseModuleElements()
            }
        Module.innerScope.addSymbol(module!)
        return(module!)
        }
        
    private func parseModuleElements() throws
        {
        repeat
            {
            try self.parseAccessModifier
                {
                if self.token.isLet
                    {
                    try self.parseVariableDeclaration()
                    }
                else if self.token.isLocal
                    {
                    try self.parseLocalDeclaration()
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
                    try self.parseClassDeclaration()
                    }
                else if self.token.isAlias
                    {
                    try self.parseAliasDeclaration()
                    }
                else if self.token.isModule
                    {
                    try self.parseModuleDeclaration()
                    }
                else
                    {
                    throw(CompilerError.moduleElementDeclarationExpected)
                    }
                }
            }
        while !self.token.isRightBrace
        }
        
    private func parseBraces(_ closure:() throws -> Void) throws
        {
        if self.token.isLeftBrace
            {
            self.advance()
            }
        else
            {
            throw(CompilerError.leftBraceExpected)
            }
        try closure()
        if self.token.isRightBrace
            {
            self.advance()
            }
        else
            {
            throw(CompilerError.rightBraceExpected)
            }
        }
        
    private func parseAccessModifier(_ closure:() throws -> Void) throws
        {
        var wasPushed = false
        if self.token.isAccessModifier
            {
            self.pushAccessModifier(self.token.keyword)
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
        let localVariable = LocalVariable(shortName: name,type:.undefined)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseType()
            localVariable.type = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            localVariable.initialValue = expression
            }
        localVariable.addDeclaration(location: location)
        Module.innerScope.addSymbol(localVariable)
        }
        
    private func parseImportDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        var path = ""
        if self.token.isLeftPar
            {
            try self.parseParentheses
                {
                if !self.token.isString
                    {
                    throw(CompilerError.stringLiteralOrVariableExpected)
                    }
                path = self.token.string
                self.advance()
                }
            }
        let moduleImport = ModuleImport(shortName:name,path:path)
        moduleImport.addDeclaration(location: location)
        Module.innerScope.addSymbol(moduleImport)
        }
        
    private func parseVariableDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let variable = Variable(shortName: name,type:.undefined)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseType()
            variable.type = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            variable.initialValue = expression
            }
        variable.addDeclaration(location: location)
        Module.innerScope.addSymbol(variable)
        }
        
    private func parseFunctionDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        if !self.token.isLeftPar
            {
            throw(CompilerError.leftParExpected)
            }
        self.advance()
        let cName = try self.parseIdentifier()
        if !self.token.isRightPar
            {
            throw(CompilerError.rightParExpected)
            }
        self.advance()
        let name = try self.parseIdentifier()
        let function = Function(shortName: name, owner: nil)
        function.cName = cName
        let parameters = try self.parseFormalParameters()
        function.parameters = parameters
        if self.token.isRightArrow
            {
            self.advance()
            let type = try self.parseType()
            function.returnType = type
            }
        Module.innerScope.addSymbol(function)
        function.addDeclaration(location: location)
        }
    
    private func parseMethodDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let parameters = try self.parseFormalParameters()
        var returnType:Type = .void
        if self.token.isRightArrow
            {
            self.advance()
            returnType = try self.parseType()
            }
        let block = try self.parseBlock()
        let method = Method(shortName:name)
        method.block = block
        method.returnType = returnType
        method.parameters = parameters
        method.addDeclaration(location: location)
        Module.innerScope.addSymbol(method)
        }
        
    private func parseEnumerationDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try parseIdentifier()
        var type:Type = .void
        if self.token.isGluon
            {
            self.advance()
            type = try self.parseType()
            }
        let enumeration = Enumeration(name: name, type: type)
        try self.parseBraces
            {
            if self.token.isComma
                {
                self.advance()
                }
            let aCase = try self.parseEnumerationCase()
            enumeration.addCase(aCase)
            }
        enumeration.addDeclaration(location: location)
        Module.innerScope.addSymbol(enumeration)
        }
        
    private func parseEnumerationCase() throws -> EnumerationCase
        {
        if !self.token.isHashString
            {
            throw(CompilerError.hashStringExpected)
            }
        let string = self.token.hashString
        self.advance()
        var typeList:Types = []
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
                    let type = try self.parseType()
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
        
    private func parseClassDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let aClass = Class(shortName:name)
        aClass.push()
        defer
            {
            aClass.pop()
            }
        if self.token.isLeftBrocket
            {
            var generics = GenericTypes()
            try self.parseBrockets
                {
                generics = try self.parseGenericTypes()
                }
            aClass.generics = generics
            }
        if self.token.isGluon
            {
            self.advance()
            //
            // If it's ( then multiple superclasses
            //
            if self.token.isLeftPar
                {
                try self.parseParentheses
                    {
                    aClass.parentClasses = try self.parseSuperclasses()
                    }
                }
            //
            // Else it should be a single identifier identifying a class
            //
            else
                {
                let name = try self.parseIdentifier()
                let superclass = self.lookupClass(shortName: name)
                aClass.parentClasses = [superclass]
                }
            }
        aClass.push()
        defer
            {
            aClass.pop()
            }
        try self.parseBraces
            {
            repeat
                {
                if self.token.isSlotKeyword
                    {
                    aClass.appendSlot(try self.parseSlotDeclaration())
                    }
                else if self.token.isIdentifier && self.token.identifier == aClass.shortName
                    {
                    aClass.appendMaker(try self.parseMakerDeclaration())
                    }
                }
            while !self.token.isRightBrace
            }
        aClass.addDeclaration(location: location)
        Module.innerScope.addSymbol(aClass)
        }
        
    private func parseSlotDeclaration() throws -> Slot
        {
        let location = self.token.location
        var isClassSlot = false
        var isVirtualSlot = false
        if self.token.isClass
            {
            self.advance()
            isClassSlot = true
            }
        if !self.token.isSlot
            {
            throw(CompilerError.slotExpected)
            }
        self.advance()
        let name = try self.parseIdentifier()
        var type:Type = .void
        if self.token.isGluon
            {
            self.advance()
            type = try self.parseType()
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
            isVirtualSlot = true
            try self.parseBraces
                {
                (readBlock,writeBlock) = try self.parseVirtualSlotBlocks()
                }
            }
        var slot:Slot
        if isVirtualSlot
            {
            var mode:SlotAttributes = writeBlock == nil ? SlotAttributes.readonly : SlotAttributes.readwrite
            if isClassSlot
                {
                mode.insert(SlotAttributes.class)
                }
            mode.insert(SlotAttributes.virtual)
            slot = VirtualSlot(shortName: name, type: type, attributes: mode)
            slot.initialValue = initialValue
            slot.virtualReadBlock = readBlock!
            if let block = writeBlock
                {
                slot.virtualWriteBlock = block
                }
            }
        else
            {
            slot = Slot(shortName: name, type: type, attributes: [])
            }
        slot.addDeclaration(location: location)
        return(slot)
        }
        
    private func parseVirtualSlotBlocks() throws -> (VirtualSlotReadBlock,VirtualSlotWriteBlock?)
        {
        if !self.token.isRead
            {
            throw(CompilerError.readExpected)
            }
        self.advance()
        var block = try self.parseBlock()
        let readBlock = VirtualSlotReadBlock(block:block)
        var writeBlock:VirtualSlotWriteBlock?
        if self.token.isWrite
            {
            self.advance()
            block = try self.parseBlock()
            writeBlock = VirtualSlotWriteBlock(block:block)
            }
        return((readBlock,writeBlock))
        }
        
    private func parseMakerDeclaration() throws -> ClassMaker
        {
        let location = self.token.location
        let name = self.token.identifier
        self.advance()
        let parameters = try self.parseFormalParameters()
        let block = try self.parseBlock()
        let maker = ClassMaker(shortName: name,parameters:parameters,block:block)
        maker.addDeclaration(location: location)
        return(maker)
        }
        
    private func parseSuperclasses() throws -> Classes
        {
        var superclassNames:[String] = []
        repeat
            {
            if self.token.isComma
                {
                self.advance()
                }
            let name = try self.parseIdentifier()
            superclassNames.append(name)
            }
        while self.token.isComma
        let superclasses = superclassNames.map{self.lookupClass(shortName:$0)}
        return(superclasses)
        }
        
    private func lookupClass(shortName:String) -> Class
        {
        if let aClass = Module.innerScope.lookup(shortName:shortName)?.first as? Class
            {
            return(aClass)
            }
        let newClass = Class(shortName:shortName)
        newClass.wasDeclaredForward = true
        Module.innerScope.addSymbol(newClass)
        return(newClass)
        }
        
    private func parseBrockets(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        self.advance()
        try closure()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
            }
        self.advance()
        }
        
    private func parseGenericTypes() throws -> GenericTypes
        {
        self.advance()
        var genericTypes = GenericTypes()
        repeat
            {
            if self.token.isComma
                {
                self.advance()
                }
            let name = try self.parseIdentifier()
            var constraints:Types = []
            if self.token.isGluon
                {
                self.advance()
                if !self.token.isLeftPar
                    {
                    throw(CompilerError.leftParExpected)
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
                        let constraint = try self.parseType()
                        constraints.append(constraint)
                        }
                    while self.token.isComma
                    }
                }
            let generic = GenericType(shortName: name,constraints: constraints)
            genericTypes.append(generic)
            }
        while self.token.isComma
        return(genericTypes)
        }
        
    private func parseAliasDeclaration() throws
        {
        self.advance()
        let location = self.token.location
        let baseType = try self.parseType()
        if !self.token.isAs
            {
            throw(CompilerError.asExpected)
            }
        self.advance()
        let name = try self.parseIdentifier()
        let alias = Alias(shortName: name, baseType: baseType)
        alias.addDeclaration(location: location)
        Module.innerScope.addSymbol(alias)
        }
        
    private func parseBitSetDeclaration() throws
        {
        self.advance()
        var valueName = ""
        var keyName:String? = nil
        try self.parseBrockets
            {
            valueName = try self.parseIdentifier()
            if self.token.isComma
                {
                self.advance()
                keyName = valueName
                valueName = try self.parseIdentifier()
                }
            }
        let setName = try self.parseIdentifier()
        if keyName != nil
            {
            let bitSet = BitSet(shortName:setName,keyTypeName:keyName,valueTypeName:valueName)
            Module.innerScope.addSymbol(bitSet)
            return
            }
        var fieldNames:[String] = []
        let bitSet = BitSet(shortName:setName,keyTypeName:keyName,valueTypeName:valueName)
        Module.innerScope.addSymbol(bitSet)
        try self.parseBraces
            {
            repeat
                {
                self.advance()
                let name = try self.parseIdentifier()
                try self.parseParentheses
                    {
                    if self.token.isIdentifier && fieldNames.contains(self.token.identifier)
                        {
                        let fieldName = self.token.identifier
                        fieldNames.append(fieldName)
                        self.advance()
                        if self.token.isAdd
                            {
                            self.advance()
                            if !self.token.isIntegerNumber
                                {
                                throw(CompilerError.integerNumberExpected)
                                }
                            let offset = self.token.integerValue
                            self.advance()
                            bitSet.addField(BitSetField(name: name, offset: Expression.additionOperation(.bitSetField(fieldName),.add,.integer(offset))))
                            }
                        else
                            {
                            bitSet.addField(BitSetField(name: name, offset: .bitSetField(fieldName)))
                            }
                        }
                    else if self.token.isAdd
                        {
                        }
                    else if self.token.isIntegerNumber
                        {
                        }
                    let offset = try self.parseExpression()
                    if !self.token.isComma
                        {
                        throw(CompilerError.commaExpected)
                        }
                    self.advance()
                    if self.token.isIdentifier
                        {
                        bitSet.addField(BitSetField(name:name,offset:offset))
                        self.advance()
                        }
                    else
                        {
                        let value = try self.parseExpression()
                        bitSet.addField(BitSetField(name:name,offset:offset))
                        }
                    }
                }
            while self.token.isBitField
            }
        Module.innerScope.addSymbol(bitSet)
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
                let name = try self.parseIdentifier()
                if !self.token.isGluon
                    {
                    throw(CompilerError.gluonExpected)
                    }
                self.advance()
                let type = try self.parseType()
                let parameter = Parameter(shortName:name,type:type,hasTag:hasTag)
                parameters.append(parameter)
                }
            while self.token.isComma
            }
        return(parameters)
        }
        
    private func parseParentheses(_ closure:() throws -> Void) throws
        {
        if !self.token.isLeftPar
            {
            throw(CompilerError.leftParExpected)
            }
        self.advance()
        try closure()
        if !self.token.isRightPar
            {
            throw(CompilerError.rightParExpected)
            }
        self.advance()
        }
        
    private func parseType() throws -> Type
        {
        if self.token.isNativeType
            {
            var aClass:Type = .void
            switch(self.token)
                {
                case .nativeType(let keyword,_):
                    switch(keyword)
                        {
                        case .Integer:
                            aClass = .integer
                        case .Integer8:
                            aClass = .integer8
                        case .Integer16:
                            aClass = .integer16
                        case .Integer32:
                            aClass = .integer32
                        case .Integer64:
                            aClass = .integer64
                        case .UInteger:
                            aClass = .uinteger
                        case .UInteger8:
                            aClass = .uinteger8
                        case .UInteger16:
                            aClass = .uinteger16
                        case .UInteger32:
                            aClass = .uinteger32
                        case .UInteger64:
                            aClass = .uinteger64
                        case .Float:
                            aClass = .float
                        case .Float16:
                            aClass = .float16
                        case .Float32:
                            aClass = .float32
                        case .Float64:
                            aClass = .float64
                        case .Boolean:
                            aClass = .boolean
                        case .String:
                            aClass = .string
                        case .Character:
                            aClass = .character
                        case .Void:
                            aClass = .void
                        case .Symbol:
                            aClass = .symbol
                        case .All:
                            aClass = .all
                        case .Date:
                            aClass = .date
                        case .Time:
                            aClass = .time
                        case .DateTime:
                            aClass = .dateTime
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
        else if self.token.isIdentifier
            {
            let typeName = self.token.identifier
            self.advance()
            if let set = Module.innerScope.lookup(shortName:typeName)
                {
                let symbol = set.first
                return(symbol.type)
                }
            else
                {
                let aClass = Class(shortName:typeName)
                Module.innerScope.addSymbol(aClass)
                return(.class(aClass))
                }
            }
        else if token.isLeftPar
            {
            self.advance()
            var types = Types()
            repeat
                {
                if self.token.isComma
                    {
                    self.advance()
                    }
                types.append(try self.parseType())
                }
            while self.token.isComma
            if !self.token.isRightPar
                {
                throw(CompilerError.rightParExpected)
                }
            self.advance()
            return(.tuple(types))
            }
        return(Type.undefined)
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
                    throw(CompilerError.integerNumberExpected)
                    }
                let amount = Int64((rangeOperator == .halfRange) ? 1 : 0)
                return(.bounded(lowerBound:lower,upperBound: self.token.integer - amount))
                }
            else
                {
                return(.upperBounded(lower))
                }
            }
        else if self.token.isIdentifier
            {
            return(.enumeration(Enumeration(name: self.token.identifier,type: Module.rootModule.integerClass.type)))
            }
        return(.none)
        }

    @discardableResult
    private func parseArrayType() throws -> Type
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        self.advance()
        let indexType = try self.parseArrayIndexType()
        if !self.token.isComma
            {
            throw(CompilerError.commaExpected)
            }
        self.advance()
        let elementType = try self.parseType()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
            }
        return(.array(indexType: indexType,elementType: elementType))
        }
        
    @discardableResult
    private func parsePointerType() throws -> Type
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        self.advance()
        let elementType = try self.parseType()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
            }
        return(.pointer(elementType: elementType))
        }

    @discardableResult
    private func parseListType() throws -> Type
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        self.advance()
        let elementType = try self.parseType()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
            }
        return(.list(elementType:elementType))
        }

    @discardableResult
    private func parseSetType() throws -> Type
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        self.advance()
        let elementType = try self.parseType()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
            }
        return(.set(elementType: elementType))
        }

    @discardableResult
    private func parseDictionaryType() throws -> Type
        {
        self.advance()
        if !self.token.isLeftBrocket
            {
            throw(CompilerError.leftBrocketExpected)
            }
        self.advance()
        let keyType = try self.parseType()
        if !self.token.isComma
            {
            throw(CompilerError.commaExpected)
            }
        let valueType = try self.parseType()
        if !self.token.isRightBrocket
            {
            throw(CompilerError.rightBrocketExpected)
            }
        return(.dictionary(keyType:keyType,valueType:valueType))
        }
        
    private func assert(_ keyword:Token.Keyword,error:CompilerError) throws
        {
        if self.token.isKeyword && self.token.keyword == keyword
            {
            self.advance()
            return
            }
        throw(error)
        }
        
    private func parseIdentifier() throws -> String
        {
        if self.token.isIdentifier
            {
            let value = self.token.identifier
            self.advance()
            return(value)
            }
        throw(CompilerError.identifierExpected)
        }
        
    private func parseBlock() throws -> Block
        {
        let block = Block()
        block.push()
        defer
            {
            block.pop()
            }
        try self.parseBlock(block)
        return(block)
        }
        
    @discardableResult
    private func parseBlock(_ block:Block) throws -> Block
        {
        try self.parseBraces
            {
            repeat
                {
                block.addStatement(try self.parseStatement())
                }
            while !self.token.isRightBrace
            }
        return(block)
        }
        
    internal func parseClosure() throws -> Closure
        {
        self.advance()
        let closure = Closure()
        closure.push()
        defer
            {
            closure.pop()
            }
        try self.parseBraces
            {
            if self.token.isWith
                {
                self.advance()
                closure.parameters = try self.parseFormalParameters()
                }
            repeat
                {
                closure.addStatement(try self.parseStatement())
                }
            while !self.token.isRightBrace
            }
        return(closure)
        }
        
    private func parseStatement() throws -> Statement
        {
        if self.token.isLocal
            {
            return(try self.parseLocalStatement())
            }
        else if self.token.isLet
            {
            return(try self.parseVariableStatement())
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
            return(try self.parseAssignmentStatement())
            }
        }
        
    private func parseVariableStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let variable = Variable(shortName: name,type:.undefined)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseType()
            variable.type = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            variable.initialValue = expression
            }
        variable.addDeclaration(location: location)
        Module.innerScope.addSymbol(variable)
        return(LetStatement(variable:variable))
        }
        
    private func parseLocalStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        let localVariable = LocalVariable(shortName: name,type:.undefined)
        if self.token.isGluon
            {
            self.advance()
            let type = try self.parseType()
            localVariable.type = type
            }
        if self.token.isAssign
            {
            self.advance()
            let expression = try self.parseExpression()
            localVariable.initialValue = expression
            }
        localVariable.addDeclaration(location: location)
        let statement = LocalStatement(localVariable:localVariable)
        Module.innerScope.addSymbol(localVariable)
        return(statement)
        }
        
    private func parseLValue() throws -> LValue
        {
        var value:[LValue] = []
        if self.token.isLeftPar
            {
            try self.parseParentheses
                {
                value.append(try self.parseLValue())
                while self.token.isComma
                    {
                    self.advance()
                    value.append(try self.parseLValue())
                    }
                }
            if value.count > 1
                {
                return(.tuple(value))
                }
            }
        if self.token.isIdentifier
            {
            let name = self.token.identifier
            self.advance()
            value.append(.variable(name))
            }
        if self.token.isLeftBracket
            {
            self.advance()
            let index = try self.parseExpression()
            if !self.token.isRightBracket
                {
                throw(CompilerError.rightBracketExpected)
                }
            self.advance()
            value.append(.subscript(index))
            }
        if self.token.isRightArrow
            {
            var slots:[String] = []
            while self.token.isRightArrow
                {
                self.advance()
                if self.token.isIdentifier
                    {
                    slots.append(self.token.identifier)
                    self.advance()
                    }
                }
            value.append(.slot(slots))
            }
        return(.compound(value))
        }
        
    private func parseAssignmentStatement() throws -> Statement
        {
        let value = try self.parseLValue()
        if self.token.isAssign
            {
            self.advance()
            let rvalue = try self.parseExpression()
            return(AssignmentStatement(lvalue:value,rvalue:rvalue))
            }
        throw(CompilerError.assignExpected)
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
        let block = try self.parseBlock()
        return(TimesStatement(expression:timesExpression!,block:block,location:location))
        }
        
    private func parseReturnStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        var value:Expression? = nil
        try self.parseParentheses
            {
            value = try self.parseExpression()
            }
        return(ReturnStatement(value:value!,location:location))
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
        return(ResumeStatement(signal:signal!,location:location))
        }
        
    private func parseNextStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let arguments = try self.parseArguments()
        let statement = NextStatement(arguments:arguments)
        statement.location = location
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
        statement.push()
        defer
            {
            statement.pop()
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
                let block = try self.parseBlock()
                statement.whenClauses.append(WhenClause(expression:whenExpression!,block:block))
                }
            if self.token.isOtherwise
                {
                self.advance()
                let block = try self.parseBlock()
                statement.otherwiseClause = OtherwiseClause(block:block)
                }
            }
        return(statement)
        }
        
    private func parseIfStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let condition = try self.parseExpression()
        let block = try parseBlock()
        let statement = IfStatement(condition:condition,block:block)
        statement.location = location
        statement.push()
        defer
            {
            statement.pop()
            }
        while self.token.isElse
            {
            self.advance()
            if self.token.isIf
                {
                self.advance()
                let condition = try self.parseExpression()
                let block = try self.parseBlock()
                let elseIf = ElseIfClause(condition:condition,block:block)
                statement.elseClauses.append(elseIf)
                }
            else
                {
                let block = try self.parseBlock()
                let clause = ElseClause(block:block)
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
                    throw(CompilerError.hashStringExpected)
                    }
                symbols.append(self.token.hashString)
                self.advance()
                }
            while self.token.isComma
            }
        let block = Block()
        block.push()
        var variable:InductionVariable?
        defer
            {
            block.pop()
            }
        try self.parseBraces
            {
            if !self.token.isWith
                {
                throw(CompilerError.withExpected)
                }
            self.advance()
            var inductionVariableName:String = ""
            try self.parseParentheses
                {
                inductionVariableName = try self.parseIdentifier()
                }
            variable = InductionVariable(shortName:inductionVariableName,type:Type.symbol)
            block.addSymbol(variable!)
            repeat
                {
                block.addStatement(try self.parseStatement())
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
        return(SignalStatement(signal:signal!,location:location))
        }
        
    private func parseForStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let name = try self.parseIdentifier()
        if !self.token.isIn
            {
            throw(CompilerError.inExpected)
            }
        self.advance()
        if !self.token.isLeftBracket
            {
            throw(CompilerError.leftBracketExpected)
            }
        self.advance()
        if !self.token.isFrom
            {
            throw(CompilerError.fromExpected)
            }
        self.advance()
        if !self.token.isColon
            {
            throw(CompilerError.colonExpected)
            }
        self.advance()
        let from = try self.parseExpression()
        if !self.token.isComma
            {
            throw(CompilerError.commaExpected)
            }
        self.advance()
        if !self.token.isTo
            {
            throw(CompilerError.toExpected)
            }
        self.advance()
        if !self.token.isColon
            {
            throw(CompilerError.colonExpected)
            }
        self.advance()
        let to = try self.parseExpression()
        if !self.token.isComma
            {
            throw(CompilerError.commaExpected)
            }
        self.advance()
        if !self.token.isBy
            {
            throw(CompilerError.byExpected)
            }
        self.advance()
        if !self.token.isColon
            {
            throw(CompilerError.colonExpected)
            }
        self.advance()
        let by = try self.parseExpression()
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        let inductionVariable = ForInductionVariable(shortName:name)
        let block = Block(inductionVariable: inductionVariable)
        block.push()
        defer
            {
            block.pop()
            }
        try self.parseBlock(block)
        inductionVariable.addDeclaration(location: location)
        return(ForInStatement(inductionVariable:inductionVariable,from: from, to: to, by: by, block: block,location:location))
        }
        
    private func parseRepeatStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let block = try self.parseBlock()
        if !self.token.isWhile
            {
            throw(CompilerError.whileExpected)
            }
        let condition = try self.parseExpression()
        return(RepeatStatement(condition:condition,block:block,location:location))
        }
        
    private func parseWhileStatement() throws -> Statement
        {
        self.advance()
        let location = self.token.location
        let condition = try self.parseExpression()
        let block = try self.parseBlock()
        return(WhileStatement(condition:condition,block:block,location:location))
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
        return(ForkStatement(expression:expression!,location:location))
        }
        
    internal func parseArguments() throws -> Arguments
        {
        var arguments = Arguments()
        try self.parseParentheses
            {
            repeat
                {
                if self.token.isComma
                    {
                    self.advance()
                    }
                arguments.append(try self.parseArgument())
                }
            while self.token.isComma
            }
        return(arguments)
        }
        
    private func parseArgument() throws -> Argument
        {
        let tag = try self.parseIdentifier()
        if !self.token.isGluon
            {
            throw(CompilerError.gluonExpected)
            }
        self.advance()
        let value = try self.parseExpression()
        return(Argument(tag:tag,value:value))
        }

    func parseExpression() throws -> Expression
        {
        let lhs = try self.parseCastExpression()
        if self.token.isLogicalOperator
            {
            return(Expression.logicalOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseCastExpression() throws -> Expression
        {
        let lhs = try self.parseBooleanExpression()
        if self.token.isCastOperator
            {
            return(Expression.castOperation(lhs,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseBooleanExpression() throws -> Expression
        {
        let lhs = try self.parseRelationalExpression()
        if self.token.isBooleanOperator
            {
            return(Expression.booleanOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseRelationalExpression() throws -> Expression
        {
        let lhs = try self.parseBitExpression()
        if self.token.isRelationalOperator
            {
            return(Expression.bitOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseBitExpression() throws -> Expression
        {
        let lhs = try self.parseAdditiveExpression()
        if self.token.isBitOperator
            {
            return(Expression.bitOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseAdditiveExpression() throws -> Expression
        {
        let lhs = try self.parseMultiplicativeExpression()
        if self.token.isAdditionOperator
            {
            return(Expression.additionOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseMultiplicativeExpression() throws -> Expression
        {
        let lhs = try self.parsePowerExpression()
        if self.token.isMultiplicationOperator
            {
            return(Expression.multiplicationOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parsePowerExpression() throws -> Expression
        {
        let lhs = try self.parseShiftExpression()
        if self.token.isPower
            {
            return(Expression.powerOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseShiftExpression() throws -> Expression
        {
        let lhs = try self.parseUnaryExpression()
        if self.token.isBitShiftLeft || self.token.isBitShiftRight
            {
            return(Expression.shiftOperation(lhs,self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseUnaryExpression() throws -> Expression
        {
        let lhs = try self.parsePrimaryTerm()
        if self.token.isSub || self.token.isBitNot || self.token.isAdd || self.token.isNot
            {
            return(Expression.unaryOperation(self.token.symbol,try self.parseExpression()))
            }
        return(lhs)
        }
        
    func parseThisExpression() throws -> Expression
        {
        if self.token.isRightArrow
            {
            return(try self.parseSlotTerm(expression: .this))
            }
        return(.this)
        }
        
    func parseTHISExpression() throws -> Expression
        {
        if self.token.isRightArrow
            {
            return(try self.parseSlotTerm(expression: .This))
            }
        return(.This)
        }
        
    func parseDateExpression() throws -> Expression
        {
        var isDate = true
        try self.parseParentheses
            {
            let first = try self.parseExpression()
            if self.token.isColon
                {
                return(try self.parseTimeTerm())
                }
            
            self.advance()
            let second = try self.parseExpression()
            if isDate && !self.token.isForwardSlash
                {
                throw(CompilerError.dateComponentSeparatorExpected)
                }
            else if !isDate && !self.token.isColon
                {
                throw(CompilerError.timeComponentSeparatorExpected)
                }
            self.advance()
            let third = try self.parseExpression()
            if isDate && !self.token.isRightPar
                {
                let time = try self.parseTimeTerm
                }
            }
        }
    func parsePrimaryTerm() throws -> Expression
        {
        if self.token.isHashString && (self.token.hashString == "#true"  || self.token.hashString == "#false")
            {
            let local = self.token.hashString
            self.advance()
            if local == "#true"
                {
                return(.boolean(.trueValue))
                }
            else
                {
                return(.boolean(.falseValue))
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
            return(.nil(RootModule.rootModule.nilInstance))
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
            return(.byte(byteValue))
            }
        else if self.token.isCharacter
            {
            let byteValue = self.token.characterValue
            self.advance()
            return(.character(byteValue))
            }
        else if self.token.isIntegerNumber
            {
            let integerValue = self.token.integerValue
            self.advance()
            return(.integer(integerValue))
            }
        else if self.token.isFloatingPointNumber
            {
            let byteValue = self.token.floatingPointValue
            self.advance()
            return(.float(byteValue))
            }
        else if self.token.isString
            {
            let byteValue = self.token.stringValue
            self.advance()
            return(.string(byteValue))
            }
        else if self.token.isHashString
            {
            let byteValue = self.token.hashStringValue
            self.advance()
            return(.symbol(byteValue))
            }
        else if self.token.isIdentifier
            {
            return(try self.parseIdentifierTerm(self.token.identifier))
            }
        else if self.token.isLeftBrace
            {
            return(Expression.closure(try self.parseClosure()))
            }
        else
            {
            return(.error("Uknown term type \(self.token)"))
            }
        }
        
    private func parseSubscriptedTerm(expression:Expression) throws -> Expression
        {
        self.advance()
        let index = try self.parseExpression()
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.readSubscript(expression,index))
        }
        
    private func parseSlotTerm(expression:Expression) throws -> Expression
        {
        var slotTerms:[String] = []
        while self.token.isRightArrow
            {
            self.advance()
            //
            // if the arrow is object->23 that means 23rd slot as a pointer
            //
            if self.token.isInteger
                {
                slotTerms.append("\(self.token.integer)")
                }
            //
            // Else it's a normal slot
            //
            else
                {
                let name = try self.parseIdentifier()
                slotTerms.append(name)
                }
            }
        return(.readSlots(expression,slotTerms))
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
        
    func parseIdentifierTerm(_ identifier:String) throws -> Expression
        {
        self.advance()
        if let object = Module.innerScope.lookup(shortName: identifier)?.first
            {
            if object is Variable
                {
                let variable = object as! Variable
                if variable.canBeInvoked && self.token.isLeftPar
                    {
                    let arguments = try self.parseArguments()
                    return(.variableInvocation(variable,arguments))
                    }
                var expression:Expression = .readVariable(variable)
                if self.token.isLeftBracket || self.token.isRightArrow
                    {
                    expression = try self.parseSlotOrSubscript(expression:expression)
                    }
                return(expression)
                }
            else if object is Class
                {
                return(.class(object as! Class))
                }
            else if object is Closure
                {
                let closure = object as! Closure
                var expression:Expression
                if self.token.isLeftPar
                    {
                    let arguments = try self.parseArguments()
                    expression = .closureInvocation(closure,arguments)
                    if self.token.isStop || self.token.isLeftBracket
                        {
                        expression = try self.parseSlotOrSubscript(expression: expression)
                        }
                    }
                else
                    {
                    return(.closure (object as! Closure))
                    }
                }
            else if object is Method
                {
                let method = object as! Method
                if self.token.isLeftPar
                    {
                    let arguments = try self.parseArguments()
                    var expression = Expression.methodInvocation(method,arguments)
                    if self.token.isStop || self.token.isLeftBracket
                        {
                        expression = try self.parseSlotOrSubscript(expression: expression)
                        }
                    return(expression)
                    }
                else
                    {
                    return(.method(object as! Method))
                    }
                }
            else if object is Function
                {
                let function = object as! Function
                if self.token.isLeftPar
                    {
                    let arguments = try self.parseArguments()
                    var expression = Expression.functionInvocation(function,arguments)
                    if self.token.isStop || self.token.isLeftBracket
                        {
                        expression = try self.parseSlotOrSubscript(expression: expression)
                        }
                    return(expression)
                    }
                else
                    {
                    return(.function(object as! Function))
                    }
                }
            else if object is Module
                {
                let module = object as! Module
                var expression = Expression.module(module)
                if self.token.isStop || self.token.isLeftBracket
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
                    return(Expression.enumerationCase(enumeration,enumeration.enumerationCase(named:nextToken.identifier)!))
                    }
                return(Expression.enumeration(enumeration))
                }
            }
        else
            {
            return(Expression.undefinedValue(identifier))
            }
        return(Expression.error("Uknown identifier term \(identifier)"))
        }
        
    private func parseMakeInvocation() throws -> Expression
        {
        self.advance()
        var arguments = Arguments()
        var theClass:Class?
        try self.parseParentheses
            {
            let name = try self.parseIdentifier()
            if let aClass = Module.innerScope.lookup(shortName: name)?.first as? Class
                {
                theClass = aClass
                }
            else
                {
                throw(CompilerError.classLiteralExpected)
                }
            while self.token.isComma
                {
                self.advance()
                arguments.append(try self.parseArgument())
                }
            }
        let expression = Expression.makeInvocation(theClass!,arguments)
        if self.token.isStop
            {
            return(try self.parseSlotTerm(expression: expression))
            }
        return(expression)
        }
        
    private func parseParenthesizedExpression() throws -> Expression
        {
        self.advance()
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
            throw(CompilerError.rightParExpected)
            }
        return(.tuple(expressions))
        }

    private func parseBracketedExpression() throws -> Expression
        {
        // { index | index ** 2 : index in 0..200 }
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
            throw(CompilerError.literalValueExpected)
            }
        }
        
    private func parseLiteralIntegerArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isInteger
            {
            literals.append(.integer(self.token.integer))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralFloatArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isFloatingPointNumber
            {
            literals.append(.float(self.token.floatingPointValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralStringArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isString
            {
            literals.append(.string(self.token.string))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralSymbolArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isHashString
            {
            literals.append(.symbol(self.token.hashString))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralIdentifierArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isIdentifier
            {
            literals.append(.identifier(self.token.identifier))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralBooleanArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isTrue || self.token.isFalse
            {
            literals.append(.boolean(self.token.booleanValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralCharacterArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isCharacter
            {
            literals.append(.character(self.token.characterValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
        
    private func parseLiteralByteArray() throws -> Expression
        {
        var literals:[Expression] = []
        while self.token.isByte
            {
            literals.append(.byte(self.token.byteValue))
            self.advance()
            if self.token.isComma
                {
                self.advance()
                }
            }
        if !self.token.isRightBracket
            {
            throw(CompilerError.rightBracketExpected)
            }
        self.advance()
        return(.literalArray(literals))
        }
    }
