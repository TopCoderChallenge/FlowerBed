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
    
    @IBOutlet var label: UILabel?;
    @IBOutlet var imageView: UIImageView?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        imageView?.frame.size = CGSizeMake(50, 50);
        imageView?.image = UIImage(named: "flower");
        imageView?.layer.cornerRadius = 50 / 2;
        imageView?.clipsToBounds = true;
        
        pickerController = ColorPickerController(svPickerView: colorPicker!, huePickerView: self.huePicker!, colorWell: self.colorWell!);
        
        pickerController?.color = UIColor.redColor();
        
        pickerController?.onColorChange = { (color, finished) in
            self.label?.textColor = color;
            self.imageView?.backgroundColor = color;
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}