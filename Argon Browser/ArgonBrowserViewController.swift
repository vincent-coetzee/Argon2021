//
//  ArgonBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//

import Cocoa
//
//class ArgonBrowserViewController: NSViewController
//    {
//    @IBOutlet var outlineView:NSOutlineView!
//    @IBOutlet var textView:NSTextView!
//    
//    private var sourceFile = SourceFile()
//    private var projectURL = URL(string: "")
//    private var styles = [TokenStyle]()
//    private var pendingStyles:[TokenStyle] = []
//    private var pendingStringCount:Int = 0
//    private var tokenStream = TokenStream(source:"")
//    private var selectedFile = SourceFile()
//    
//    private var currentSource:String = ""
//    private var currentTokens:[Token] = []
//    private var currentRange:NSRange = NSRange(location: 0,length: 0)
//    
//    override func viewDidLoad()
//        {
//        super.viewDidLoad()
//        TokenStyle.initStyles()
//        self.initOutliner()
//        self.initTextView()
//        }
//    
//    private func initTokenStyles()
//        {
////        styles.append(TokenStyle(type:.keyword,foreground: NSColor.argonPink,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.comment,foreground: NSColor.argonPurple,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.nativeType,foreground: NSColor.argonCoral,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.identifier,foreground: NSColor.argonZomp,font:NSFont.tokenFont))
//////        styles.append(TokenStyle(type:.symbol,foreground: NSColor.argonBlue,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.symbol,foreground: NSColor.argonLawnGreen,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.float,foreground: NSColor.argonCyan,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.string,foreground: NSColor.argonBlue,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.integer,foreground: NSColor.argonGreen,font:NSFont.tokenFont))
////        styles.append(TokenStyle(type:.hashString,foreground: NSColor.argonDeepOrange,font:NSFont.tokenFont))
//        self.textView.selectedTextAttributes = [.backgroundColor:NSColor.argonSizzlingRed,.foregroundColor:NSColor.black]
//        self.textView.markedTextAttributes = [.backgroundColor:NSColor.argonDeepOrange,.foregroundColor:NSColor.black]
//        self.textView.typingAttributes = [.backgroundColor:NSColor.black,.foregroundColor:NSColor.white,.font:NSFont(name: "Menlo",size: 14)]
//        }
//        
//    private func initTextView()
//        {
//        self.textView.backgroundColor = NSColor.black
//        self.textView.delegate = self
//        }
//        
//    private func initOutliner()
//        {
//        let panel = NSOpenPanel()
//        panel.allowedFileTypes = ["argon","arm","arp"]
//        panel.canChooseDirectories = true
//        panel.canChooseFiles = true
//        panel.allowsMultipleSelection = true
//        if panel.runModal() == .cancel
//            {
//            return
//            }
//        self.projectURL = panel.url!
//        let folder = SourceFolder.files(ofPath: self.projectURL!.path)
//        if folder.isExpandable
//            {
//            self.sourceFile = folder
//            self.outlineView.reloadData()
//            }
//        self.textView.lnv_setUpLineNumberView()
//        self.outlineView.rowHeight = 40
//        self.view.window?.windowController?.windowTitle(forDocumentDisplayName: self.projectURL!.path)
//        }
//    }
//    
//extension ArgonBrowserViewController:NSOutlineViewDataSource
//    {
//    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
//        {
//        if item == nil && self.sourceFile.isFolder
//            {
//            return(1)
//            }
//        else if item == nil
//            {
//            return(self.sourceFile.children.count)
//            }
//        return((item as! SourceProvider).children.count)
//        }
//
//    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
//        {
//        if item == nil
//            {
//            return(self.sourceFile)
//            }
//        return((item as! SourceProvider).children[index])
//        }
//
//    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
//        {
//        return((item as! SourceProvider).children.count > 0)
//        }
//    }
//    
//extension ArgonBrowserViewController:NSToolbarDelegate
//    {
//    }
//    
//extension ArgonBrowserViewController
//    {
//    @IBAction
//    func onClassClicked(_ sender:Any?)
//        {
//        }
//        
//    @IBAction
//    func onModuleClicked(_ sender:Any?)
//        {
//        }
//        
//    @IBAction
//    func onMethodClicked(_ sender:Any?)
//        {
//        }
//    
//    @IBAction
//    func onFunctionClicked(_ sender:Any?)
//        {
//        }
//        
//    @IBAction
//    func onSlotClicked(_ sender:Any?)
//        {
//        }
//        
//    @IBAction
//    func onLocalClicked(_ sender:Any?)
//        {
//        }
//        
//    @IBAction
//    func onEnumerationClicked(_ sender:Any?)
//        {
//        }
//    }
//    
//extension ArgonBrowserViewController:NSOutlineViewDelegate
//    {
//    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?,item: Any) -> NSView?
//        {
//        let view = SegmentView(title: (item as! SourceProvider).name, icon: (item as! SourceProvider).image)
//        return(view)
//        }
//        
//    func outlineViewSelectionDidChange(_ notification: Notification)
//        {
//        let row = self.outlineView.selectedRow
//        let item = self.outlineView.item(atRow: row)
//        guard item != nil else
//            {
//            return
//            }
//        let sourceItem = item as! SourceProvider
//        self.selectedFile = item as! SourceFile
//        let source = sourceItem.source
//        self.tokenStream.reset(source:source)
//        let compiler = Compiler()
//        let module = compiler.compile(source: source)
//        let tokens = self.tokenStream.tokens(withComments: true)
//        self.textView.string = source
//        TokenStyle.updateStyle(tokens: tokens, of: self.textView)
//        self.view.window?.setTitleWithRepresentedFilename(selectedFile.path)
//        }
//    }
//
//extension ArgonBrowserViewController:NSTextViewDelegate
//    {
//    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool
//        {
//        let affectedRange = affectedCharRange
//        return(true)
//        }
//        
//    public func textDidChange(_ notification:Notification)
//        {
//        let source = self.textView.attributedString()
//        if source.string == self.currentSource
//            {
//            return
//            }
//        self.currentSource = source.string
//        let tokens = TokenStream(source: self.currentSource).tokens(withComments: true)
//        self.tokenStream.reset(source:source.string)
//        
//        DispatchQueue.main.async
//            {
//            TokenStyle.updateStyle(tokens: tokens, of: self.textView)
//            }
//        }
//    }
