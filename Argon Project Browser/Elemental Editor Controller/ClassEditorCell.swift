//
//  ClassEditorCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/05.
//

import Cocoa

class ClassEditorCell: ItemEditorCell,NSTableViewDelegate,NSTableViewDataSource
    {
    private let tableView:NSTableView
    private let theClass:Class
    private var elements:[Any] = []
    
    init(class:Class)
        {
        self.theClass = `class`
        self.tableView = NSTableView(frame:.zero)
        super.init(frame:NSRect.zero)
        self.addSubview(self.tableView)
        self.tableView.register(NSNib(nibNamed: "LabelView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelView"))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "0"))
        self.tableView.addTableColumn(column)
        elements.append("Superclasses")
        for element in self.theClass.superclasses
            {
            elements.append(element)
            }
        elements.append("Type Variables")
        for element in self.theClass.typeVariables
            {
            elements.append(element)
            }
        elements.append("Slots")
        for element in self.theClass.localSlots.values
            {
            elements.append(element)
            }
        self.tableView.reloadData()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout()
        {
        super.layout()
        self.tableView.frame = self.bounds
        }
        
    override func reload()
        {
        self.tableView.reloadData()
        }
        
    func numberOfRows(in tableView: NSTableView) -> Int
        {
        return(self.elements.count)
        }

    func tableView(_ tableView: NSTableView,objectValueFor tableColumn: NSTableColumn?,row: Int) -> Any?
        {
        return(self.elements[row])
        }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
        {
        return(NSTableRowView(frame:.zero))
        }
        
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
        {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelView"), owner: nil) as! LabelView

        let element = self.elements[row]
        if element is String
            {
            view.labelView.stringValue = element as! String
            view.button1.isHidden = true
            view.button2.isHidden = true
            }
        else
            {
            view.labelView.stringValue = (element as! Symbol).shortName
            view.button1.title = "􀈓"
            view.button2.title = "􀁌"
            var frame = view.labelView.frame
            frame.origin.x += 24
            view.labelView.frame = frame
            }
        return(view)
        }
    }
