//
//  ArgonFile.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
import AppKit

public class SourceFile:SourceProvider
    {
    public var image:NSImage
        {
        return(NSImage(named:"PinkFile")!)
        }
        
    public var name: String
        {
        return((self._path as NSString).lastPathComponent)
        }
    
    public var isFolder:Bool
        {
        return(false)
        }
        
    public var isFile:Bool
        {
        return(true)
        }
        
    public var children:[SourceFile]
        {
        return([])
        }
    
    var isExpandable: Bool
        {
        return(false)
        }
        
    init()
        {
        self.path = ""
        }
        
    init(path:String)
        {
        self.path = path
        self.loadElements()
        }
        
    public var path:String
        {
        get
            {
            return(self._path)
            }
        set
            {
            self._path = newValue
            }
        }
        
    internal var _path:String = ""
    
    internal var module:Module?
    
    public lazy var tokens:[Token] =
        {
        return(TokenStream(source: self.source).tokens(withComments: true))
        }()
        
    public lazy var source:String =
        {
        return((try? String(contentsOfFile: self.path)) ?? "")
        }()
        
    internal func loadElements()
        {
        }
    }
