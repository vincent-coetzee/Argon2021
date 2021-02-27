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
        self.initSourceView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSourceView()
        {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.source = self.sourceFile.source
        self.scrollView.documentView = self.textView
        self.textView.isVerticallyResizable = true
        self.textView.isHorizontallyResizable = false
        self.textView.autoresizingMask = [.width]
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasHorizontalScroller = true
        self.scrollView.contentView.scroll(to:.zero)
        self.textView.delegate = self
        self.textView.awakeFromNib()
        self.textView.gutterForegroundColor = NSColor.white
        self.textView.gutterBackgroundColor = NSColor.black
        self.textView.addAnnotation(LineAnnotation(line:25,icon:NSImage(named:"AnnotationWarning")!))
        self.textView.addAnnotation(LineAnnotation(line:79,icon:NSImage(named:"AnnotationError")!))
        self.textView.addAnnotation(LineAnnotation(line:111,icon:NSImage(named:"AnnotationSyntax")!))
        self.textView.addAnnotation(LineAnnotation(line:207,icon:NSImage(named:"AnnotationMissing")!))
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.textView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.textView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true

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
