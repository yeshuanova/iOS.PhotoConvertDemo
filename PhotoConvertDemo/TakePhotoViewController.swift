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
    
    var image_picker : UIImagePickerController!
    var photo_src : UIImage!
    var photo_edit : UIImage!
    
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
    
    @IBAction func clearPhoto(sender: UIBarButtonItem) {
        photo_view.image = photo_src;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        picker.dismissViewControllerAnimated(true, completion: nil);
        
        photo_src = info[UIImagePickerControllerOriginalImage] as? UIImage;
        photo_edit = info[UIImagePickerControllerEditedImage] as? UIImage;
        
//        photo_edit = OCV_Wrapper.ocvGrayConvert(photo_src);
//        photo_view.image = photo_edit;
        
    }
    
    
}
