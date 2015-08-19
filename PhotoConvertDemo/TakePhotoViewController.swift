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
        
        println("Show \(type.description) image");
        
        switch type {
        case .Origin:
            self.photo_view.image = self.photo_src;
            println("photo_src info");
            self.showUIImageInfo(self.photo_src);
        case .Grayscale:
            self.photo_edit = OCV_Wrapper.ocvGrayConvert(self.photo_src);
            self.photo_view.image = self.photo_edit;
            
            println("photo_edit info");
            showUIImageInfo(self.photo_edit);
        default:
            println("Not exist type");
        }
        
        println("photo_view info");
        showUIImageInfo(self.photo_view.image);
    }
    
    func showUIImageInfo(img:UIImage!) {
        if nil != img {
            println("Photo, width: \(img.size.width), height: \(img.size.height), orientation: \(img.imageOrientation.rawValue) ");
        }
    }

    func normalizedImage(image:UIImage!) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.Up) {
            return image;
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.drawInRect(rect)
        
        var normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        picker.dismissViewControllerAnimated(true, completion: nil);
        photo_src = info[UIImagePickerControllerOriginalImage] as? UIImage;
        photo_src = normalizedImage(photo_src); // Fix photo orientation for image conversion.
        setPhotoWithType(self.show_type);
    }
    
}
