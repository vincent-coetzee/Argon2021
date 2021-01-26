//
//  Instruction.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public protocol Instruction
    {
    var labels:InstructionLabels { get }
    func addLabel(_ label:A3Label)
    }
