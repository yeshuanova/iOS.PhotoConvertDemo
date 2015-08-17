//
//  TakePhotoViewController.swift
//  PhotoConvertDemo
//
//  Created by Peter.Li on 2015/8/14.
//  Copyright (c) 2015年 Peter.Li. All rights reserved.
//

import UIKit

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photo_view: UIImageView!
    @IBOutlet weak var take_photo_btn: UIBarButtonItem!
    @IBOutlet weak var clear_btn: UIBarButtonItem!
    @IBOutlet weak var conv_btn: UIBarButtonItem!
    
    var image_picker : UIImagePickerController!
    var photo_src : UIImage!
    var photo_edit : UIImage!
    var show_type : ShowType = .Origin
    
    enum ShowType : Printable {
        case Origin
        case Grayscale
        case Binary
        case Smooth
        
        var description : String {
            switch self {
            case .Origin: return "Origin";
            case .Grayscale: return "Grayscale";
            case .Binary: return "Binary";
            case .Smooth: return "Smooth";
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        image_picker = UIImagePickerController();
        image_picker.delegate = self;
        image_picker.sourceType = UIImagePickerControllerSourceType.Camera;
        image_picker.allowsEditing = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(sender: UIBarButtonItem) {
        presentViewController(image_picker, animated: true, completion: nil);
    }

    @IBAction func resetPhoto(sender: UIBarButtonItem) {
        photo_view.image = photo_src;
    }
    
    @IBAction func openSwitchPicker(sender: UIBarButtonItem) {
        
        if (nil == self.photo_src) {
            println("Photo doesn't exist!");
            return;
        }
        
        let alert_cont = UIAlertController(title: "Convert Style", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        let act_cancel_btn : UIAlertAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.Cancel) { action -> Void in
            
        };
        
        let origin_action: UIAlertAction = UIAlertAction(title: "Origin", style: UIAlertActionStyle.Default) { action -> Void in
            println("Click original action button");
            self.setPhotoWithType(ShowType.Origin);
        };
        
        let gray_action: UIAlertAction = UIAlertAction(title: "Grayscale", style:UIAlertActionStyle.Default) { action -> Void in
            println("Click grayscale action button");
            self.setPhotoWithType(ShowType.Grayscale);
        };
        
        alert_cont.addAction(act_cancel_btn);
        alert_cont.addAction(origin_action);
        alert_cont.addAction(gray_action);
        
        self.presentViewController(alert_cont, animated: true, completion: nil);
    }
    
    func setPhotoWithType(type:ShowType) {
        
        self.show_type = type;
        self.conv_btn.title = show_type.description;
        
        switch type {
        case .Origin:
            self.photo_view.image = self.photo_src;
        case .Grayscale:
            self.photo_edit = OCV_Wrapper.ocvGrayConvert(self.photo_src);
            self.photo_view.image = self.photo_edit;
        default:
            println("Not exist type");
        }
        
        if let img = self.photo_view.image {
            println("Photo, width : \(img.size.width), height : \(img.size.height)" );
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        picker.dismissViewControllerAnimated(true, completion: nil);
        
        photo_src = info[UIImagePickerControllerOriginalImage] as? UIImage;
        photo_edit = info[UIImagePickerControllerEditedImage] as? UIImage;
        
        setPhotoWithType(self.show_type);
//        self.photo_edit = OCV_Wrapper.ocvGrayConvert(self.photo_src);
//        self.photo_view.image = self.photo_edit;
    }
    
}
