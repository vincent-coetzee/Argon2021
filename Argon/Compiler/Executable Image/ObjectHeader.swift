//
//  ObjectHeader.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/28.
//

import Foundation

public enum ObjectKind:Int
    {
    case kNone = 0
    case kClass
    case kArray 
    case kString
    case kList
    case kSet
    case kDictionary
    case kLock
    case kMonitor
    case kSemaphore
    case kThread
    case kEnumeration
    case kMetaClass
    case kDate
    case kTime
    case kDateTime
    case kModule
    case kConduit
    case kKeyedConduit
    case kSequentialConduit
    case kSymbol
    case kClosure
    case kBehavior
    case kMethod
    case kFunction
    case kCollection
    case kBitSet
    case kBuffer
    }
    
public enum Tag:Word
    {
    static let kShift = ObjectHeader.kForwardedShift - ObjectHeader.kSignWidth
    
    case integer =  0b000
    case float =    0b001
    case header =   0b010
    case address =  0b011
    case bits =     0b100
    case pointer =  0b101
    }
    
public class ObjectHeader
    {
    static let kTagWidth:Word = 3
    static let kSignWidth:Word = 1
    static let kWordCountWidth:Word = 32
    static let kKindWidth:Word = 8
    static let kForwardedWidth:Word = 1
    static let kFlipCountWidth:Word = 8
    
    static let kTagShift:Word = ObjectHeader.kForwardedShift - ObjectHeader.kSignWidth
    static let kSignShift:Word = 63
    static let kWordCountShift:Word = ObjectHeader.kTagShift - ObjectHeader.kWordCountWidth
    static let kKindShift:Word = 0
    static let kForwardedShift:Word = ObjectHeader.kSignShift - ObjectHeader.kForwardedWidth
    static let kFlipCountShift:Word = ObjectHeader.kWordCountShift - ObjectHeader.kFlipCountWidth
    
    static let kSignMask:Word = ObjectHeader.kSignWidth.twoRaisedTo()
    static let kTagMask:Word = ObjectHeader.kTagWidth.twoRaisedTo()
    static let kWordCountMask:Word = ObjectHeader.kWordCountWidth.twoRaisedTo()
    static let kKindMask:Word = ObjectHeader.kKindWidth.twoRaisedTo()
    static let kForwardedMask:Word = ObjectHeader.kForwardedWidth.twoRaisedTo()
    static let kFlipCountMask:Word = ObjectHeader.kFlipCountWidth.twoRaisedTo()
    
    public var word:Word
        {
        get
            {
            return(self._word)
            }
        set
            {
            self._word = newValue
            }
        }
        
    private var _word:Word = 0
    
    public var tag:Tag
        {
        get
            {
            return(Tag(rawValue:(self.word & (Self.kTagMask << Self.kTagShift))>>Self.kTagShift)!)
            }
        set
            {
            var theWord = self.word
            theWord &= ~(Self.kTagMask << Self.kTagShift)
            theWord |= newValue.rawValue << Self.kTagShift
            self.word = theWord
            }
        }
        
    public var sign:Word
        {
        get
            {
            return((self.word & (Self.kSignMask << Self.kSignShift)) >> Self.kSignShift)
            }
        set
            {
            var theWord = self.word
            theWord &= ~(Self.kSignMask << Self.kSignShift)
            theWord |= ((newValue & Self.kSignMask) << Self.kSignShift)
            self.word = theWord
            }
        }
        
    public var wordCount:Int
        {
        get
            {
            return(Int((self.word & (Self.kWordCountMask << Self.kWordCountShift)) >> Self.kWordCountShift))
            }
        set
            {
            var theWord = self.word
            theWord &= ~(Self.kWordCountMask << Self.kWordCountShift)
            theWord |= ((Word(newValue) & Self.kWordCountMask) << Self.kWordCountShift)
            self.word = theWord
            }
        }
        
    public var flipCount:Int
        {
        get
            {
            return(Int((self.word & (Self.kFlipCountMask << Self.kWordCountShift)) >> Self.kWordCountShift))
            }
        set
            {
            var theWord = self.word
            theWord &= ~(Self.kFlipCountMask << Self.kFlipCountShift)
            theWord |= ((Word(newValue) & Self.kFlipCountMask) << Self.kFlipCountShift)
            self.word = theWord
            }
        }
        
    public var kind:ObjectKind
        {
        get
            {
            return(ObjectKind(rawValue:Int((self.word & (Self.kKindMask << Self.kKindShift)) >> Self.kKindShift))!)
            }
        set
            {
            let value = Word(newValue.rawValue)
            var theWord = self.word
            theWord &= ~(Self.kKindMask << Self.kKindShift)
            theWord |= ((value & Self.kKindMask) << Self.kKindShift)
            self.word = theWord
            }
        }
        
    public var isForwarded:Bool
        {
        get
            {
            return(((self.word & (Self.kForwardedMask << Self.kForwardedShift)) >> Self.kForwardedShift) == 1)
            }
        set
            {
            var theWord = self.word
            theWord &= ~(Self.kForwardedMask << Self.kForwardedShift)
            theWord |= ((Word(newValue ? 1 : 0) & Self.kForwardedMask) << Self.kForwardedShift)
            self.word = theWord
            }
        }
        
    init(tag:Tag = .integer,count:Int = 0,flipCount:Int = 0,isForwarded:Bool = false,kind:ObjectKind = .kNone)
        {
        self.tag = tag
        self.wordCount = count
        self.flipCount = flipCount
        self.kind = kind
        self.isForwarded = isForwarded
        }
    }
    
public class ObjectHeaderPointer:ObjectHeader
    {
    }

extension Word
    {
    func twoRaisedTo() -> Word
        {
        var value:Word = 1
        for _ in 0..<self
            {
            value *= 2
            }
        return(value - 1)
        }
    }
