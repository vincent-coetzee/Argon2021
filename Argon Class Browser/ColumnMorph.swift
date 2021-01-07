//
//  ColumnMorph.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/07.
//

import Foundation

public class ColumnMorphColumn
    {
    let title:String?
    let hasTitle:Bool
    let layoutFrame:LayoutFrame
    var frame:NSRect = .zero
    var valueMorphs:[ArgonMorph?] = []
    var rowCount:Int
    let parentMorph:ArgonMorph
    
    init(rowCount:Int,title:String? = nil,layoutFrame:LayoutFrame,parentMorph:ArgonMorph)
        {
        self.parentMorph = parentMorph
        self.rowCount = rowCount
        self.valueMorphs = Array<ArgonMorph?>(repeating: nil, count: rowCount)
        self.title = title
        self.hasTitle = title != nil
        self.layoutFrame = layoutFrame
        }
        
    func layout(in rect:NSRect)
        {
        self.frame = layoutFrame.rectangle(in: rect)
        }
        
    func setMorph(_ morph:ArgonMorph,atRow:Int)
        {
        self.valueMorphs[atRow] = morph
        self.parentMorph.markAsNeedingLayout = true
        }
    }
    
public class ColumnMorph:ArgonMorph
    {
    var columns:[ColumnMorphColumn] = []
    
    init(columns:[ColumnMorphColumn])
        {
        self.columns = columns
        super.init()
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    func setMorph(_ morph:ArgonMorph,atRow:Int,atColumn:Int)
        {
        let column = self.columns[atColumn]
        column.setMorph(morph,atRow:atRow)
        self.markAsNeedingLayout = true
        self.markAsNeedingDisplay = true
        }
        
    override func layout(inFrame frame:NSRect)
        {
        self.frame = self.layoutFrame.rectangle(in:frame)
        for column in self.columns
            {
            column.layout(in:frame)
            }
        }
    }
