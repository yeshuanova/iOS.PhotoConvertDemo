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
    @IBOutlet weak var take_photo_lib_btn: UIBarButtonItem!
    @IBOutlet weak var clear_btn: UIBarButtonItem!
    @IBOutlet weak var conv_btn: UIBarButtonItem!
    
    var image_picker : UIImagePickerController!
    var photo_src : UIImage!
    var photo_edit : UIImage!
    var show_type : ShowType = .Origin
    
    enum ShowType : CustomStringConvertible {
        case Origin
        case Grayscale
        
        var description : String {
            switch self {
            case .Origin: return "Origin";
            case .Grayscale: return "Grayscale";
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.sharedApplication().statusBarHidden = true;
        
        image_picker = UIImagePickerController();
        image_picker.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    @IBAction func takePhoto(sender: UIBarButtonItem) {
        image_picker.sourceType = UIImagePickerControllerSourceType.Camera;
        presentViewController(image_picker, animated: true, completion: nil);
    }

    @IBAction func takePhotoFromLib(sender: UIBarButtonItem) {
        image_picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        presentViewController(image_picker, animated: true, completion: nil);
    }
    
    @IBAction func clearPhoto(sender: UIBarButtonItem) {
        photo_src = nil;
        photo_edit = nil;
        photo_view.image = nil;
    }
    
    @IBAction func openSwitchPicker(sender: UIBarButtonItem) {
        
        if (nil == self.photo_src) {
            print("Photo doesn't exist!");
            return;
        }
        
        let alert_cont = UIAlertController(title: "Convert Style", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        let act_cancel_btn : UIAlertAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.Cancel) { action -> Void in
            
        };
        
        let origin_action: UIAlertAction = UIAlertAction(title: "Origin", style: UIAlertActionStyle.Default) { action -> Void in
            print("Click original action button");
            self.setPhotoWithType(ShowType.Origin);
        };
        
        let gray_action: UIAlertAction = UIAlertAction(title: "Grayscale", style:UIAlertActionStyle.Default) { action -> Void in
            print("Click grayscale action button");
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
        
        print("Show \(type.description) image");
        
        switch type {
        case .Origin:
            self.photo_view.image = self.photo_src;
            self.showUIImageInfo(self.photo_src);
        case .Grayscale:
            self.photo_edit = OCV_Wrapper.ocvGrayConvert(self.photo_src);
            self.photo_view.image = self.photo_edit;
            showUIImageInfo(self.photo_edit);
        default:
            print("Not exist type");
        }
        
    }
    
    func showUIImageInfo(img:UIImage!) {
        if nil != img {
            print("Photo, width: \(img.size.width), height: \(img.size.height), orientation: \(img.imageOrientation.rawValue) ");
        }
    }

    func normalizedImage(image:UIImage!) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.Up) {
            return image;
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.drawInRect(rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        picker.dismissViewControllerAnimated(true, completion: nil);
        photo_src = info[UIImagePickerControllerOriginalImage] as? UIImage;
        photo_src = normalizedImage(photo_src); // Fix photo orientation for image conversion.
        setPhotoWithType(self.show_type);
    }
    
}
