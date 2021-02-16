//
//  ArgonProject.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/15.
//

import Foundation
import AppKit

class ArgonProject: NSDocument
    {
    public static let kProjectIcon = NSImage(named:"ArgonProjectIcon")!
    public static let kSymbolsIcon = NSImage(named:"ArgonSymbolsIcon")!
    public static let kModuleIcon = NSImage(named:"ArgonModuleIcon")!
    public static let kSourceFileIcon = NSImage(named:"ArgonSourceFileIcon")!
    
    public var childFileKeys:[String]
        {
        guard let wrappers = self.wrapper.fileWrappers?.values else
            {
            return([])
            }
        let childKeys = wrappers.map{self.wrapper.keyForChildFileWrapper($0)!}
        return(childKeys)
        }
        
    let wrapper:FileWrapper
    let path:String
    let wasLoaded:Bool
    let wasCreated:Bool
    
    init(named:String,at path:String) throws
        {
        self.path = path
        self.wrapper = FileWrapper(directoryWithFileWrappers:[:])
        self.wrapper.filename = named
        self.wasCreated = true
        self.wasLoaded = false
        }
        
    init(atPath path:String) throws
        {
        self.wrapper = try FileWrapper(url:URL(fileURLWithPath: path))
        self.path = path
        self.wasLoaded = true
        self.wasCreated = false
        }
        
    private func iconImageForExtension(_ theExtension:String) -> NSImage
        {
        if theExtension == "arm"
            {
            return(Self.kModuleIcon)
            }
        else if theExtension == "argon"
            {
            return(Self.kSourceFileIcon)
            }
        else if theExtension == "arp"
            {
            return(Self.kProjectIcon)
            }
        else if theExtension == "arb"
            {
            return(Self.kSymbolsIcon)
            }
        else
            {
            fatalError("Invalid extension \(theExtension)")
            }
        }
        
    func addFile(data:Data,at name:String)
        {
        let key = self.wrapper.addRegularFile(withContents:data,preferredFilename:name)
        let file = self.wrapper.fileWrappers![key]
        let theExtension = (name as NSString).pathExtension
        file?.icon = self.iconImageForExtension(theExtension)
        }
        
    func write() throws
        {
        let url = URL(fileURLWithPath: self.path)
        self.wrapper.icon = Self.kProjectIcon
        try self.wrapper.write(to:url,options:[],originalContentsURL:nil)
        }
        
    func remove(atPath path:String) throws
        {
        let manager = FileManager.default
        try manager.removeItem(atPath: path)
        }

    override class var autosavesInPlace: Bool
        {
        return true
        }

    override func makeWindowControllers()
        {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
        }

    override func data(ofType typeName: String) throws -> Data
        {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }

    override func read(from data: Data, ofType typeName: String) throws
        {
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
