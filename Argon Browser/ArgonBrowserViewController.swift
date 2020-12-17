//
//  ArgonBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//

import Cocoa

class ArgonBrowserViewController: NSViewController
    {
    @IBOutlet var outlineView:NSOutlineView!
    @IBOutlet var textView:NSTextView!
    
    private var sourceFile = SourceFile()
    private var projectURL = URL(string: "")
    private var styles = [TokenStyle]()
    private var pendingStyles:[TokenStyle] = []
    private var pendingStringCount:Int = 0
    private var tokenStream = TokenStream(source:"")
    private var selectedFile = SourceFile()
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initTokenStyles()
        self.initOutliner()
        self.initTextView()
        }
    
    private func initTokenStyles()
        {
        styles.append(TokenStyle(type:.keyword,foreground: NSColor.argonPink,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.comment,foreground: NSColor.argonPurple,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.nativeType,foreground: NSColor.argonCoral,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.identifier,foreground: NSColor.argonYellow,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.symbol,foreground: NSColor.argonBlue,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.float,foreground: NSColor.argonCyan,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.string,foreground: NSColor.argonRed,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.integer,foreground: NSColor.argonGreen,font:NSFont.tokenFont))
        styles.append(TokenStyle(type:.hashString,foreground: NSColor.argonBlue,font:NSFont.tokenFont))
        }
        
    private func initTextView()
        {
        self.textView.backgroundColor = NSColor.black
        self.textView.delegate = self
        }
        
    private func initOutliner()
        {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["argon","arproj"]
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        if panel.runModal() == .cancel
            {
            return
            }
        self.projectURL = panel.url!
        let folder = SourceFolder.files(ofPath: self.projectURL!.path)
        if folder.isExpandable
            {
            self.sourceFile = folder
            self.outlineView.reloadData()
            }
        self.textView.lnv_setUpLineNumberView()
        self.outlineView.rowHeight = 50
        }
    }
    
extension ArgonBrowserViewController:NSOutlineViewDataSource
    {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item == nil && self.sourceFile.isFolder
            {
            return(1)
            }
        else if item == nil
            {
            return(self.sourceFile.children.count)
            }
        return((item as! SourceProvider).children.count)
        }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item == nil
            {
            return(self.sourceFile)
            }
        return((item as! SourceProvider).children[index])
        }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        return((item as! SourceProvider).children.count > 0)
        }
    }
    
extension ArgonBrowserViewController:NSOutlineViewDelegate
    {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?,item: Any) -> NSView?
        {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("TableCell"), owner: nil)
        let tableCell = (view as? NSTableCellView)?.textField!
        tableCell!.stringValue = (item as! SourceProvider).name
        let imageView = (view as? NSTableCellView)?.imageView
        imageView!.image = (item as! SourceProvider).image
        return(view)
        }
        
    func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let row = self.outlineView.selectedRow
        let item = self.outlineView.item(atRow: row)
        guard item != nil else
            {
            return
            }
        let sourceItem = item as! SourceProvider
        self.selectedFile = item as! SourceFile
        let source = sourceItem.source
        self.textView.font = NSFont(name:"Menlo",size:14)!
        self.tokenStream.reset(source:source)
        let tokens = self.tokenStream.tokens(withComments: true)
        let attributedString = NSMutableAttributedString(string:source,attributes:[:])
        attributedString.beginEditing()
        for style in self.styles
            {
            style.apply(tokens:tokens,string: attributedString)
            }
        attributedString.endEditing()
        DispatchQueue.main.async
            {
            self.textView.textStorage?.setAttributedString(attributedString)
            }
        }
    }

extension ArgonBrowserViewController:NSTextViewDelegate
    {
    public func textDidChange(_ notification:Notification)
        {
        let source = self.textView.attributedString()
        self.textView.resetTextAttributes()
        self.tokenStream.reset(source:source.string)
        let tokens = self.tokenStream.tokens(withComments: true)
        let attributedString = NSMutableAttributedString(attributedString:source)
        attributedString.beginEditing()
        for style in self.styles
            {
            style.apply(tokens:tokens,string: attributedString)
            }
        attributedString.endEditing()
        DispatchQueue.main.async
            {
            self.textView.textStorage?.font = NSFont(name:"Menlo",size:14)!
            self.textView.textStorage?.foregroundColor = NSColor.white
            self.textView.textStorage?.setAttributedString(attributedString)
            }
        }
    }

extension NSTextView
    {
    func resetTextAttributes()
        {
        let range = NSRange(location: 0,length: self.string.count)
        self.setFont(NSFont(name:"Menlo",size:14)!,range: range)
        self.setTextColor(NSColor.white,range: range)
        self.backgroundColor = NSColor.black
        }
    }