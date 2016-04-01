//
//  ColorPickerViewController.swift
//  FlowerBed
//
//  Created by 侯 翔 on 2016/03/30.
//  Copyright © 2016年 HX Studio. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerViewController: UIViewController
{
    @IBOutlet var colorWell: ColorWell?;
    @IBOutlet var colorPicker: ColorPicker?;
    @IBOutlet var huePicker: HuePicker?;
    var pickerController: ColorPickerController?;
    
    @IBOutlet var segmentedControl: UISegmentedControl?;
    @IBOutlet var imageView1: UIImageView?;
    @IBOutlet var imageView2: UIImageView?;
    @IBOutlet var imageview3: UIImageView?;
    
    var imageView: UIImageView?;
    var state: State?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        state = State.instance();
        
        self.colorWell?.alpha = 0;
        segmentedControl?.addTarget(self, action: #selector(self.segmentedControlViewChange(_:)), forControlEvents: UIControlEvents.ValueChanged);
        let i: Int = 1;
        if (i == 1) {
            
        }
        
        switch (self.segmentedControl!.selectedSegmentIndex) {
        case 0:
            imageView = imageView1;
            break
        case 1:
            imageView = imageView2;
            break;
        case 2:
            imageView = imageview3;
            break;
        default:
            imageView = imageView1;
            break;
        }
        
        if (imageView?.backgroundColor == nil) {
            imageView?.backgroundColor = UIColor.clearColor();
        }
        
        pickerController = ColorPickerController(svPickerView: colorPicker!, huePickerView: self.huePicker!, colorWell: self.colorWell!);
        
        pickerController?.color = UIColor.redColor();
        
        pickerController?.onColorChange = { (color, finished) in
            self.imageView?.backgroundColor = color;
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func segmentedControlViewChange(sender: UISegmentedControl) {
        let color: UIColor = (imageView?.backgroundColor)!;
        imageView?.backgroundColor = UIColor.clearColor();
        switch (self.segmentedControl!.selectedSegmentIndex) {
        case 0:
            imageView = imageView1;
            break
        case 1:
            imageView = imageView2;
            break;
        case 2:
            imageView = imageview3;
            break;
        default:
            imageView = imageView1;
            break;
        }
        imageView?.backgroundColor = color;
    }
    
    //MARK: - IBAction
    @IBAction func setColorAndType(sender: UIButton) {
        var imgName: String = "Flower1";
        switch (self.segmentedControl!.selectedSegmentIndex) {
        case 0:
            imgName = "Flower1";
            break
        case 1:
            imgName = "Flower2";
            break;
        case 2:
            imgName = "Flower3";
            break;
        default:
            imgName = "Flower1";
            break;
        }
        state?.setFlower(imgName, flowerColor: (imageView?.backgroundColor)!)
        self.performSegueWithIdentifier("setColor", sender: self);
    }
    
    
}