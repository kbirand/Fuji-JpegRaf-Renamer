import Cocoa

class dropView: NSView {

    var filePath: String?
    let expectedExt = ["MOV","MP4"]  //file extensions allowed for Drag&Drop (example: "jpg","png","docx", etc..)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        //self.layer?.backgroundColor = NSColor.gray.cgColor
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer!.borderColor = CGColor(gray: 1, alpha: 0.2)
        self.layer!.masksToBounds = true;
        self.layer!.cornerRadius = 10.0;
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            //self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            return .copy
            //return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        //self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        //self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!!
        self.filePath = path
//        Swift.print("FilePath: \(path)")
        let dataDict:[String: String] = ["filePath": path]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadAsset"), object: nil, userInfo: dataDict)
        return true
    }
}
