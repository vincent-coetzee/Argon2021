//
//  ThreeAddressInstructionBuffer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class ThreeAddressInstructionBuffer
    {
    private var labels:[Int:InstructionLabel] = [:]
    private var instructions:[ThreeAddressInstruction] = []
    private var pendingLabel:InstructionLabel?
    private var pendingLocation:SourceLocation?
    
    public var lastLHS:ThreeAddress
        {
        return(self.instructions.last!.left as! ThreeAddress)
        }
        
    public var lastResult:ThreeAddress
        {
        return(self.instructions.last!.result!)
        }
        
    @discardableResult
    func emitPendingLabel(index:Int) -> InstructionLabel
        {
        self.pendingLabel = InstructionLabel(index:index)
        return(self.pendingLabel!)
        }
        
    @discardableResult
    func emitPendingLabel(label:InstructionLabel) -> InstructionLabel
        {
        self.pendingLabel = label
        return(self.pendingLabel!)
        }
        
    func emitInstruction(label:InstructionLabel? = nil,result:ThreeAddress? = nil,left:ThreeAddress? = nil,opcode:ThreeAddressInstruction.InstructionCode,right:ThreeAddress? = nil,comment:String? = nil)
        {
        self.emitInstruction(ThreeAddressInstruction(label:label,result:result,left:left,opcode:opcode,right:right,comment:comment))
        }
        
    func emitPendingLocation(_ location:SourceLocation)
        {
        self.pendingLocation = location
        }
    
    @discardableResult
    func emitInstruction(opcode:ThreeAddressInstruction.InstructionCode) -> ThreeAddressInstruction
        {
        return(self.emitInstruction(ThreeAddressInstruction(opcode:opcode)))
        }
        
    @discardableResult
    func emitInstruction(_ instruction:ThreeAddressInstruction) -> ThreeAddressInstruction
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
