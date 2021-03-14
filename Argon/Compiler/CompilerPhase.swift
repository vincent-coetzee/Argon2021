//
//  CompilationPhase.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal protocol CompilerPhase
    {
    var nextPhase:CompilerPhase? { get }
    var name:String { get }
    func preProcess(source:String,using:Compiler) throws
    func process(source:String,using: Compiler) throws
    func postProcess(module:RootModule,using:Compiler) throws
    }
