//
//  ViewController.swift
//  Fuji Renamer
//
//  Created by Koray Birand on 21.06.2020.
//  Copyright © 2020 Koray Birand. All rights reserved.
//

import Cocoa
import ImageIO

class capturesObject : NSObject {
    
    var filename : String?
    var createDate : NSDate?

    
}




class ViewController: NSViewController {
    
    @IBOutlet weak var dropedTarget: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var execButton: NSButton!
    
    var jpgs  = [capturesObject]()
    var raws  = [capturesObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(self.loadAsset),
               name: Notification.Name("loadAsset"),
               object: nil)
           
        //getRAFS()
        // Do any additional setup after loading the view.
    }
    
     @objc func loadAsset(_ notification: NSNotification) {
        
        jpgs.removeAll()
        raws.removeAll()
    
        let dict = notification.userInfo! as NSDictionary
        let filePath = dict["filePath"]
        dropedTarget.stringValue = filePath! as! String + "/"
        
        
            let myPath = filePath!
        let files = try! FileManager.default.contentsOfDirectory(atPath: myPath as! String)
        
            
            for items in files {
                let file : URL = URL(string: items)!
              
        
                if file.pathExtension == "JPG" {
                    let newJpgs = capturesObject()
                    let attrs = try! FileManager.default.attributesOfItem(atPath: myPath as! String + "/" + file.path) as NSDictionary
                        
                    newJpgs.filename = file.path
                    newJpgs.createDate = attrs[FileAttributeKey.creationDate] as? NSDate
                    
                    jpgs.append(newJpgs)

                    
                }
                
                if file.pathExtension == "RAF" {
                    let newRaws = capturesObject()
                    let attrs = try! FileManager.default.attributesOfItem(atPath: myPath as! String + "/" + file.path) as NSDictionary
                    
                    newRaws.filename = file.path
                    newRaws.createDate = attrs[FileAttributeKey.creationDate] as? NSDate
                    raws.append(newRaws)
                }
            }
            
            
            jpgs.sort { (($0.filename)?.compare($1.filename!))! == .orderedAscending }
            raws.sort { (($0.filename)?.compare($1.filename!))! == .orderedAscending }
            
        status.stringValue = "\(jpgs.count.description) jpgs and \(raws.count.description) raws found."
        
        if jpgs.count == raws.count {
            execButton.isEnabled = true
        }
        
    }
    
    
    func getRAFS() {
        
        let myPath = dropedTarget.stringValue
        let path = NSString(string: myPath)
        let newpath = path.deletingLastPathComponent + "/" + path.lastPathComponent + "_Raf"
        var counter = 0
                
        if jpgs.count == raws.count {
            for items in jpgs {
                let name = items.filename!
                let newName = path.appendingPathComponent(name) as NSString
                let targetNameWithoutExtension : NSString = ((newName.deletingPathExtension) as NSString).lastPathComponent as NSString
                if !FileManager.default.fileExists(atPath: newpath) {
                    try! FileManager.default.createDirectory(at: URL(fileURLWithPath: newpath), withIntermediateDirectories: false)
                }

                
                let sourceFile = URL(fileURLWithPath: myPath + "\(raws[counter].filename!)")
                let targetFile = URL(fileURLWithPath: newpath + "/" + targetNameWithoutExtension.description + ".RAF")
                
                if FileManager.default.fileExists(atPath: targetFile.path){
                                   do{
                                    try FileManager.default.removeItem(atPath: targetFile.path)
                                   } catch let error {
                                       print("error occurred, here are the details:\n \(error)")
                                   }
                               }
                try! FileManager.default.copyItem(at: sourceFile, to: targetFile)
                
                counter = counter + 1
            }
            
            execButton.isEnabled = false
            status.stringValue = ""
            dropedTarget.stringValue = ""
            
            
        }
        
        

        
        
        
    }

    @IBAction func execute(_ sender: Any) {
        getRAFS()
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

