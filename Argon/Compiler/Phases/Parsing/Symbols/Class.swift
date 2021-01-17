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
        
    public static let rootClass = Class(shortName:"Root")
    public static let classClass = Class(shortName:"Class").parentClass(.rootClass)
    public static let metaClass = Class(shortName:"Metaclass").parentClass(.classClass)
    public static let allClass = Class(shortName:"All").parentClass(.rootClass)
    public static let voidClass = Class(shortName:"Void").parentClass(.rootClass)
    public static let valueClass = Class(shortName:"Value").parentClass(.rootClass)
    public static let constantClass = ConstantClass(shortName:"Constant").parentClass(.valueClass)
    public static let addressClass = AddressClass(shortName:"Address").parentClass(.valueClass)
    public static let objectClass = Class(shortName:"Object").parentClass(.rootClass)
    public static let enumerationClass = Class(shortName:"Enumeration").parentClass(.valueClass)
    public static let bitValueClass = Class(shortName:"BitValue").parentClass(.valueClass)
    public static let nilClass = Class(shortName:"Nil").parentClass(.rootClass)
    public static let booleanClass = Class(shortName:"Boolean").parentClass(.valueClass)
    public static let byteClass = Class(shortName:"Byte").parentClass(.valueClass)
    public static let characterClass = Class(shortName:"Character").parentClass(.valueClass)
    public static let tupleClass = Class(shortName:"Tuple").parentClass(.objectClass)
    public static let conduitClass = Class(shortName:"Conduit").parentClass(.objectClass)
    public static let keyedConduitClass = Class(shortName:"KeyedConduit").parentClass(.conduitClass)
    public static let sequentialConduitClass = Class(shortName:"SequentialConduitClass").parentClass(.conduitClass)
    public static let dateClass = Class(shortName:"Date").parentClass(.valueClass)
    public static let timeClass = Class(shortName:"Time").parentClass(.valueClass)
    public static let dateTimeClass = Class(shortName:"DateTime").parentClass(.valueClass)
    public static let signalClass = Class(shortName:"Signal").parentClass(.valueClass)
    public static let semaphoreClass = Class(shortName:"Semaphore").parentClass(.objectClass)
    public static let moduleClass = Class(shortName:"Module").parentClass(.objectClass)
    public static let stringClass = Class(shortName:"String").parentClass(.valueClass)
    public static let symbolClass = Class(shortName:"Symbol").parentClass(.stringClass)
    public static let lockClass = Class(shortName:"Lock").parentClass(.valueClass)
    public static let threadClass = Class(shortName:"Thread").parentClass(.objectClass)
    public static let behaviorClass = Class(shortName:"Behavior").parentClass(.objectClass)
    public static let methodClass = Class(shortName:"Method").parentClass(.behaviorClass)
    public static let closureClass = Class(shortName:"Closure").parentClass(.behaviorClass)
    public static let functionClass = Class(shortName:"Function").parentClass(.behaviorClass)
    public static let integerClass = Class(shortName:"Integer").parentClass(.bitValueClass)
    public static let integer8Class = Class(shortName:"Integer8").parentClass(.bitValueClass)
    public static let integer16Class = Class(shortName:"Integer16").parentClass(.bitValueClass)
    public static let integer32Class = Class(shortName:"Integer32").parentClass(.bitValueClass)
    public static let integer64Class = Class(shortName:"Integer64").parentClass(.bitValueClass)
    public static let uIntegerClass = Class(shortName:"UInteger").parentClass(.bitValueClass)
    public static let uInteger8Class = Class(shortName:"UInteger8").parentClass(.bitValueClass)
    public static let uInteger16Class = Class(shortName:"UInteger16").parentClass(.bitValueClass)
    public static let uInteger32Class = Class(shortName:"UInteger32").parentClass(.bitValueClass)
    public static let uInteger64Class = Class(shortName:"UInteger64").parentClass(.bitValueClass)
    public static let floatClass = Class(shortName:"Float").parentClass(.bitValueClass)
    public static let float32Class = Class(shortName:"Float32").parentClass(.bitValueClass)
    public static let float64Class = Class(shortName:"Float64").parentClass(.bitValueClass)
    public static let float16Class = Class(shortName:"Float16").parentClass(.bitValueClass)
    public static let collectionClass = CollectionClass(shortName:"Collection").parentClass(.objectClass).slot(Identifier("count"),.integerClass).slot(Identifier("elementType"),.classClass)
    public static let arrayClass = ArrayClass(shortName:"Array",indexType:.unbounded, elementTypeClass: .voidClass).parentClass(.collectionClass)
    public static let setClass = SetClass(shortName:"Set",elementTypeClass:.voidClass).parentClass(.collectionClass)
    public static let listClass = ListClass(shortName:"List",elementTypeClass:.voidClass).parentClass(.collectionClass)
    public static let bitSetClass = BitSetClass(shortName:"BitSet",keyType:.void,valueType:.void).parentClass(.collectionClass)
    public static let dictionaryClass = DictionaryClass(shortName:"Dictionary",keyTypeClass:.voidClass,valueTypeClass:.voidClass).parentClass(.collectionClass)
    
    public static func invocationClass(_ name:String,_ kind:InvocationClass.InvocationType,_ classes:[Class],_ returnClass:Class) -> InvocationClass { InvocationClass(shortName:name,type:kind,argumentClasses:classes,returnClass:returnClass) }
    
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
    internal var classSlots:[String:Slot] = [:]
    internal var metaSlots:[String:Slot] = [:]
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
        self.classSlots[slot.shortName] = slot
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
        if let name = slotNames.first,let slot = self.classSlots.values.first(where: {$0.shortName == name})
            {
            return(slot.slotType(Array<String>(slotNames.dropFirst())))
            }
        return(Type.undefined)
        }
        
    internal func slotType(_ slotName:String) -> Type
        {
        if let slot = self.classSlots.values.first(where: {$0.shortName == slotName})
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
        self.classSlots[slot.shortName] = slot
        slot = Slot(name:Name("superclasses"),class: (Class.arrayClass as! ArrayClass).classWithIndex(Type.ArrayIndexType.unbounded),container:self,attributes:.readonly)
        self.classSlots[slot.shortName] = slot
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
        
    func addClassSlot(_ slot:Slot)
        {
        self.classSlots[slot.shortName] = slot
        slot.symbolAdded(to: self)
        }
        
    func addMetaSlot(_ slot:Slot)
        {
        self.metaSlots[slot.shortName] = slot
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
        for slot in self.classSlots.values
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
        if let slot = self.classSlots[shortName]
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
        
    @discardableResult
    func placeholderSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.class]) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:self,attributes: attributes)
        self.addClassSlot(slot)
        return(self)
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
    public enum InvocationType
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
