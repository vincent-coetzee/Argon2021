//
//  SourceItemFileEditorCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Cocoa

public class SourceFileItemEditorCell:ItemEditorCell,NSTextViewDelegate
    {
    private let sourceFile:ArgonFile
    @IBOutlet
    private var textView:ArgonSourceTokenizingTextView! = ArgonSourceTokenizingTextView(frame:.zero)
    private let scrollView = NSScrollView(frame:.zero)
    
    override init(item:EditableItem)
        {
        self.sourceFile = item as! ArgonFile
        super.init(item:item)
        self.initTextField()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTextField()
        {
        self.addSubview(self.scrollView)
        self.textView.source = self.sourceFile.source
        self.scrollView.documentView = self.textView
        self.textView.isVerticallyResizable = true
        self.textView.isHorizontallyResizable = true
        self.textView.autoresizingMask = [.width]
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasHorizontalScroller = true
        self.scrollView.contentView.scroll(to:.zero)
        self.textView.delegate = self
        self.textView.awakeFromNib()
        self.textView.gutterForegroundColor = NSColor.white
        self.textView.gutterBackgroundColor = NSColor.black
        self.textView.addCartouche(icon:NSImage(named:"CartoucheWarning")!,at:25)
        self.textView.addCartouche(icon:NSImage(named:"CartoucheError")!,at:84)
        self.textView.addCartouche(icon:NSImage(named:"CartoucheSyntax")!,at:147)
        self.textView.addCartouche(icon:NSImage(named:"CartoucheMissing")!,at:12)
        }
        
    public func textDidChange(_ notfication:Notification)
        {
        self.sourceFile.source = self.textView.source
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.bounds
        self.scrollView.frame = rect
        }
    }
