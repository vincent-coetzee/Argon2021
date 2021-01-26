//
//  ThreeAddressInstructionBuffer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class A3CodeBuffer:Codable
    {
    private var labels:[Int:A3Label] = [:]
    private var instructions:[A3Instruction] = []
    private var pendingLabel:A3Label?
    private var pendingLocation:SourceLocation?
    
    public var lastLHS:A3Address
        {
        return(self.instructions.last!.left as! A3Address)
        }
        
    public var lastResult:A3Address
        {
        return(self.instructions.last!.result!)
        }
        
    init()
        {
        }
        
    enum CodingKeys:String,CodingKey
        {
        case labels
        case instructions
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.labels = try values.decode(Dictionary<Int,A3Label>.self,forKey:.labels)
        self.instructions = try values.decode(Array<A3Instruction>.self,forKey:.instructions)
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.labels,forKey:.labels)
        try container.encode(self.instructions,forKey:.instructions)
        }
        
    @discardableResult
    func emitPendingLabel(index:Int) -> A3Label
        {
        self.pendingLabel = A3Label(index:index)
        return(self.pendingLabel!)
        }
        
    @discardableResult
    func emitPendingLabel(label:A3Label) -> A3Label
        {
        self.pendingLabel = label
        return(self.pendingLabel!)
        }
        
    func emitInstruction(label:A3Label? = nil,result:A3Address? = nil,left:A3Address? = nil,opcode:A3Instruction.InstructionCode,right:A3Address? = nil,comment:String? = nil)
        {
        self.emitInstruction(A3Instruction(label:label,result:result,left:left,opcode:opcode,right:right,comment:comment))
        }
        
    func emitComment(_ comment:String? = nil)
        {
        self.emitInstruction(A3Instruction(opcode:.comment,right:.string(comment!)))
        }
        
    func emitPendingLocation(_ location:SourceLocation)
        {
        self.pendingLocation = location
        }
    
    @discardableResult
    func emitInstruction(opcode:A3Instruction.InstructionCode) -> A3Instruction
        {
        return(self.emitInstruction(A3Instruction(opcode:opcode)))
        }
        
    @discardableResult
    func emitInstruction(_ instruction:A3Instruction) -> A3Instruction
        {
        if let location = self.pendingLocation
            {
            instruction.setLocation(location)
            self.pendingLocation = nil
            }
        if var label = self.pendingLabel
            {
            instruction.addLabel(label)
            label.setInstruction(instruction)
            self.pendingLabel = nil
            }
        self.instructions.append(instruction)
        return(instruction)
        }
        
    func dump()
        {
        for instruction in self.instructions
            {
            print("\(instruction.displayString)")
            }
        }
    }
