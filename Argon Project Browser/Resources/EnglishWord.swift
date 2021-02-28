//
//  EnglishWord.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Foundation

public struct EnglishWord
    {
    public static let  allWords:Array<EnglishWord> =
        {
        let path = Bundle.main.path(forResource:"words",ofType:"txt")!
        if let allWords = try? String(contentsOfFile: path, encoding: .utf8)
            {
            let theWords = allWords.components(separatedBy: "\r\n")
            return(theWords.map{EnglishWord(stringValue:$0)})
            }
        return([])
        }()
        
    public static func randomWord() -> EnglishWord
        {
        let count = self.allWords.count
        let index = Int.random(in: 0..<count)
        return(self.allWords[index])
        }
        
    public var count:Int
        {
        return(self.string.count)
        }
        
    public var stringValue:String
        {
        get
            {
            return(string)
            }
        set
            {
            self.string = newValue
            }
        }
        
    private var string:String
    
    init(stringValue:String)
        {
        self.string = stringValue
        }
    }
    
