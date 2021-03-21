//
//  IntegerClasses.swift
//  Argon
//
//  Created by Vincent Coetzee on 3/21/21.
//

import Foundation

public class IntegerClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }
    
public class Integer64Class:IntegerClass
    {
    }

public class Integer32Class:IntegerClass
    {
    }

public class Integer16Class:IntegerClass
    {
    }

public class Integer8Class:IntegerClass
    {
    }

public class UIntegerClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }
    
public class UInteger64Class:UIntegerClass
    {
    }

public class WordClass:UInteger64Class
    {
    }
    
public class UInteger32Class:UIntegerClass
    {
    }

public class UInteger16Class:UIntegerClass
    {
    }

public class UInteger8Class:UIntegerClass
    {
    }
    
public class FloatClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }
    
public class Float64Class:FloatClass
    {
    }

public class Float32Class:FloatClass
    {
    }

public class Float16Class:FloatClass
    {
    
    }

public class ByteClass:Integer8Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }

public class CharacterClass:Integer16Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }

public class BooleanClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }

public class CollectionClass:Class
    {
    }
    
public class ArrayClass:CollectionClass
    {
    }
    
public class StringClass:ArrayClass
    {
    }
    
public class SymbolClass:StringClass
    {
    }

public class ByteArrayClass:ArrayClass
    {
    }

public class ListClass:CollectionClass
    {
    }
    
public class SetClass:CollectionClass
    {
    }
    
public class DictionaryClass:CollectionClass
    {
    }

public class DateClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
public class TimeClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }
    
public class DateTimeClass:Class
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.structureAttributes.insert(.value)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }
