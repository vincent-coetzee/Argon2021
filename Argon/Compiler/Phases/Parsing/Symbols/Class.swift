//
//  Pattern.swift
//  spark
//
//  Created by Vincent Coetzee on 15/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Class:Symbol,ThreeAddress
    {
    public static func ==(lhs:Class,rhs:Class) -> Bool
        {
        return(Swift.type(of:rhs)==Swift.type(of:lhs) && rhs.shortName == lhs.shortName)
        }
        
    internal static let rootClass = Class(shortName:"Root")
    internal static let classClass = Class(shortName:"Class").parentClass(.rootClass)
    internal static let metaClass = Class(shortName:"Metaclass").parentClass(.classClass)
    internal static let allClass = Class(shortName:"All").parentClass(.rootClass)
    internal static let voidClass = Class(shortName:"Void").parentClass(.rootClass)
    internal static let valueClass = Class(shortName:"Value").parentClass(.rootClass)
    internal static let constantClass = ConstantClass(shortName:"Constant").parentClass(.valueClass)
    internal static let addressClass = AddressClass(shortName:"Address").parentClass(.valueClass)
    internal static let objectClass = Class(shortName:"Object").parentClass(.rootClass)
    internal static let enumerationClass = Class(shortName:"Enumeration").parentClass(.valueClass)
    internal static let bitValueClass = Class(shortName:"BitValue").parentClass(.valueClass)
    internal static let nilClass = Class(shortName:"Nil").parentClass(.rootClass)
    internal static let booleanClass = Class(shortName:"Boolean").parentClass(.valueClass)
    internal static let byteClass = Class(shortName:"Byte").parentClass(.valueClass)
    internal static let characterClass = Class(shortName:"Character").parentClass(.valueClass)
    internal static let tupleClass = Class(shortName:"Tuple").parentClass(.objectClass)
    internal static let dateClass = Class(shortName:"Date").parentClass(.valueClass)
    internal static let timeClass = Class(shortName:"Time").parentClass(.valueClass)
    internal static let dateTimeClass = Class(shortName:"DateTime").parentClass(.valueClass)
    internal static let signalClass = Class(shortName:"Signal").parentClass(.valueClass)
    internal static let semaphoreClass = Class(shortName:"Semaphore").parentClass(.objectClass)
    internal static let moduleClass = Class(shortName:"Module").parentClass(.objectClass)
    internal static let stringClass = Class(shortName:"String").parentClass(.valueClass)
    internal static let symbolClass = Class(shortName:"Symbol").parentClass(.stringClass)
    internal static let lockClass = Class(shortName:"Lock").parentClass(.valueClass)
    internal static let threadClass = Class(shortName:"Thread").parentClass(.objectClass)
    internal static let behaviorClass = Class(shortName:"Behavior").parentClass(.objectClass)
    internal static let methodClass = Class(shortName:"Method").parentClass(.behaviorClass)
    internal static let closureClass = Class(shortName:"Closure").parentClass(.behaviorClass)
    internal static let functionClass = Class(shortName:"Function").parentClass(.behaviorClass)
    internal static let integerClass = Class(shortName:"Integer").parentClass(.bitValueClass)
    internal static let integer8Class = Class(shortName:"Integer8").parentClass(.bitValueClass)
    internal static let integer16Class = Class(shortName:"Integer16").parentClass(.bitValueClass)
    internal static let integer32Class = Class(shortName:"Integer32").parentClass(.bitValueClass)
    internal static let integer64Class = Class(shortName:"Integer64").parentClass(.bitValueClass)
    internal static let uIntegerClass = Class(shortName:"UInteger").parentClass(.bitValueClass)
    internal static let uInteger8Class = Class(shortName:"UInteger8").parentClass(.bitValueClass)
    internal static let uInteger16Class = Class(shortName:"UInteger16").parentClass(.bitValueClass)
    internal static let uInteger32Class = Class(shortName:"UInteger32").parentClass(.bitValueClass)
    internal static let uInteger64Class = Class(shortName:"UInteger64").parentClass(.bitValueClass)
    internal static let floatClass = Class(shortName:"Float").parentClass(.bitValueClass)
    internal static let float32Class = Class(shortName:"Float32").parentClass(.bitValueClass)
    internal static let float64Class = Class(shortName:"Float64").parentClass(.bitValueClass)
    internal static let float16Class = Class(shortName:"Float16").parentClass(.bitValueClass)
    internal static let collectionClass = CollectionClass(shortName:"Collection").parentClass(.objectClass).slot(Identifier("count"),.integerClass).slot(Identifier("elementType"),.classClass)
    internal static let arrayClass = ArrayClass(shortName:"Array",indexType:.unbounded, elementTypeClass: .voidClass).parentClass(.collectionClass)
    internal static let setClass = SetClass(shortName:"Set",elementTypeClass:.voidClass).parentClass(.collectionClass)
    internal static let listClass = ListClass(shortName:"List",elementTypeClass:.voidClass).parentClass(.collectionClass)
    internal static let bitSetClass = BitSetClass(shortName:"BitSet",keyType:.void,valueType:.void).parentClass(.collectionClass)
    internal static let dictionaryClass = DictionaryClass(shortName:"Dictionary",keyTypeClass:.voidClass,valueTypeClass:.voidClass).parentClass(.collectionClass)
    
    internal static func invocationClass(_ name:String,_ kind:InvocationClass.InvocationType,_ classes:[Class],_ returnClass:Class) -> InvocationClass { InvocationClass(shortName:name,type:kind,argumentClasses:classes,returnClass:returnClass) }
    
    public var displayString:String
        {
        return("$\(self.shortName)")
        }
        
    var parentClasses:Classes
        {
        get
            {
            self._parentClasses
            }
        set
            {
            self._parentClasses = newValue
            }
        }
        
    internal var _parentClasses = Classes()
    internal var generics = GenericClasses()
    internal var slots:[String:Slot] = [:]
    internal var makers = ClassMakers()
    internal var hollowMethods:[HollowMethod] = []
    internal var symbols:[String:Symbol] = [:]
    internal var classDescriptor:ClassDescriptor?
    
    internal var isGeneric:Bool
        {
        return(!self.generics.isEmpty)
        }
        
    internal override var typeClass:Class
        {
        return(self)
        }
        
    @discardableResult
    internal func slot(_ name:Identifier,_ class:Class) -> Class
        {
        let slot = Slot(shortName: name, class: `class`, attributes: .readonly)
        self.slots[slot.shortName] = slot
        return(self)
        }
        
    internal func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        fatalError("This should not have been called")
        }
        
    internal func slotType(_ slotNames:[String]) -> Type
        {
        if slotNames.count == 0
            {
            return(self.type)
            }
        if let name = slotNames.first,let slot = self.slots.values.first(where: {$0.shortName == name})
            {
            return(slot.slotType(Array<String>(slotNames.dropFirst())))
            }
        return(Type.undefined)
        }
        
    internal func slotType(_ slotName:String) -> Type
        {
        if let slot = self.slots.values.first(where: {$0.shortName == slotName})
            {
            return(slot.slotType(Array<String>()))
            }
        return(Type.undefined)
        }
        
    internal func hollowMethod(_ name:String,_ parms:ParameterName...) -> Class
        {
        self.hollowMethods.append(HollowMethod(name,parms))
        return(self)
        }
        
    internal func parentClass(_ parent:Class) -> Class
        {
        self._parentClasses.append(parent)
//        self.slot("superclasses",.array(indexType: .unbounded,elementType: Class.classClass.type))
        return(self)
        }
        
    internal func instanciate() -> Instance
        {
        return(Instance(class:self))
        }
        
    init(shortName:String,generics:GenericClasses)
        {
        self.generics = generics
        super.init(shortName:shortName)
        var slot = Slot(name:Name("class"),class:Class.classClass,container:self,attributes: .readonly)
        self.slots[slot.shortName] = slot
        slot = Slot(name:Name("superclasses"),class: (Class.arrayClass as! ArrayClass).classWithIndex(Type.ArrayIndexType.unbounded),container:self,attributes:.readonly)
        self.slots[slot.shortName] = slot
        }
        
    init(shortName:String)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    init(shortName:String,indexType:Type.ArrayIndexType,elementType:Type)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    init(shortName:String,keyType:Type,valueType:Type)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    init(shortName:String,elementType:Type)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    func appendSlot(_ slot:Slot)
        {
        self.slots[slot.shortName] = slot
        slot.symbolAdded(to: self)
        }
    
    func isSubclass(of superclass:Class) -> Bool
        {
        for parent in self._parentClasses
            {
            if superclass == parent
                {
                return(true)
                }
            if parent.isSubclass(of:superclass)
                {
                return(true)
                }
            }
        return(false)
        }
        
    internal override func sourceFileElements() -> [SourceFileElement]
        {
        var elements:[SourceFileElement] = []
        for slot in self.slots.values
            {
            elements.append(SourceFileElement(.slot(slot)))
            }
        return(elements)
        }
        
    func appendConstant(_ constant:Constant)
        {
        self.symbols[constant.shortName] = constant
        constant.symbolAdded(to: self)
        }
        
    func appendMaker(_ maker:ClassMaker)
        {
        self.makers.append(maker)
        maker.symbolAdded(to: self)
        }
        
    override func lookup(shortName: String) -> SymbolSet?
        {
        if let slot = self.slots[shortName]
            {
            return(SymbolSet(slot))
            }
        return(self.parentScope?.lookup(shortName:shortName))
        }
        
    func allParentClasses() -> Set<Class>
        {
        var set = Set<Class>()
        for aClass in self.parentClasses
            {
            set.insert(aClass)
            for newClass in aClass.allParentClasses()
                {
                set.insert(newClass)
                }
            }
        return(set)
        }
        
    func allocateAddresses(using:Compiler) throws
        {
        }
        
    func layoutClass() throws
        {
        
        }
    }

typealias Classes = Array<Class>

public class RRRCLASS:Class
    {
    let _class:Class
    let symbol:Token.Symbol
    let start:Int
    let end:Int
        
    init(class:Class,symbol:Token.Symbol,start:Int,end:Int)
        {
        self.symbol = symbol
        self.start = start
        self.end = end
        self._class = `class`
        super.init(shortName:Argon.nextName("SUBRANGE"))
        }
    }


public class SetClass:CollectionClass
    {
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) -> Class
        {
        return(SetClass(shortName:Argon.nextName("SET"),elementTypeClass:self.elementTypeClass))
        }
    }

public class ListClass:CollectionClass
    {
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) ->Class
        {
        return(ListClass(shortName:Argon.nextName("LIST"),elementTypeClass:self.elementTypeClass))
        }
    }

public class BitSetClass:CollectionClass
    {
    public let keyType:Type
    public let valueType:Type
    
    init(shortName:String,keyType:Type,valueType:Type)
        {
        self.keyType = keyType
        self.valueType = valueType
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.bitset(keyType:self.keyType,valueType:self.valueType))
        }
    }


public class InvocationClass:Class
    {
    enum InvocationType
        {
        case operation(Token.Symbol)
        case object(String)
        }
        
    let invocationType:InvocationType
    let argumentClasses:[Class]
    let returnClass:Class
    
    init(shortName:String,type:InvocationType,argumentClasses:[Class],returnClass:Class)
        {
        self.invocationType = type
        self.argumentClasses = argumentClasses
        self.returnClass = returnClass
        super.init(shortName:shortName)
        }
    }
    
public class CrossProduct:Class
    {
    private var operands:[Class]
    private var operation:Token.Symbol
    
    init(shortName:String,operation:Token.Symbol,operands:[Class])
        {
        self.operands = operands
        self.operation = operation
        super.init(shortName:shortName)
        }
    }

public class TupleClass:Class
    {
    let elements:[Class]
    
    init(elements:[Class])
        {
        self.elements = elements
        super.init(shortName:"TUPLE_\(Argon.nextIndex())")
        }
    }

public class ValueClass:Class
    {
    }
    
public class AddressClass:ValueClass
    {
    }
    
public class ConstantClass:ValueClass
    {
    let _class:Class
    
    override init(shortName:String)
        {
        self._class = .voidClass
        super.init(shortName:shortName)
        }
        
    init(shortName:String,class:Class)
        {
        self._class = `class`
        super.init(shortName:shortName)
        }
    }

public class SequenceGeneratorClass:Class
    {
    let baseClass:Class
    let start:Expression
    let end:Expression
    let step:Expression
    
    init(baseClass:Class,start:Expression,step:Expression,end:Expression)
        {
        self.baseClass = baseClass
        self.start = start
        self.step = step
        self.end = end
        super.init(shortName:Argon.nextName("SEQUENCE"))
        }
    }
