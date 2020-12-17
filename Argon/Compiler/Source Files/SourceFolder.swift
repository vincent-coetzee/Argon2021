//
//  SourceFolder.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
import AppKit

public class SourceFolder:SourceFile
    {
    public static func files(ofPath path:String) -> SourceFile
        {
        var pointer:ObjCBool = ObjCBool(false)
        let result = FileManager.default.fileExists(atPath: path, isDirectory: &pointer)
        return(result && pointer.boolValue ? SourceFolder(path:path) : SourceFile(path:path))
        }
        
    public override var image:NSImage
        {
        return(NSImage(named:"PinkFolder")!)
        }
        
    public override var isFolder:Bool
        {
        return(true)
        }
        
    public override var isFile:Bool
        {
        return(false)
        }
        
    public override var children:[SourceFile]
        {
        let manager = FileManager.default
        var nodes:[SourceFile] = []
        guard let localPaths = try? manager.contentsOfDirectory(atPath: self.path) else
            {
            return(nodes)
            }
        for aPath in localPaths where !aPath.hasPrefix(".")
            {
            let nextPath = (self.path as NSString).appendingPathComponent(aPath)
            var isDirectory:ObjCBool = ObjCBool(false)
            if manager.fileExists(atPath: nextPath, isDirectory: &isDirectory) && isDirectory.boolValue
                {
                let folder = SourceFolder(path: nextPath)
                nodes.append(folder)
                }
            else if (nextPath as NSString).pathExtension == "argon"
                {
                let file = SourceFile(path: nextPath)
                nodes.append(file)
                }
            }
        return(nodes)
        }
    
    override var isExpandable: Bool
        {
        return(self.children.count > 0)
        }
    }
