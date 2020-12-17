//
//  SourceProvider.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//

import Foundation
import AppKit

public protocol SourceProvider
    {
    var image:NSImage { get }
    var children:[SourceFile] { get }
    var source:String { get }
    var isFile:Bool { get }
    var isFolder:Bool { get }
    var name:String { get }
    }
