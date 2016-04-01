//
//  State.swift
//  FlowerBed
//
//  Created by 侯 翔 on 2016/03/30.
//  Copyright © 2016年 HX Studio. All rights reserved.
//

import Foundation
import UIKit

struct Flower {
    var color: UIColor;
    var image: UIImage;
    var number: Int;
    
    init(no: Int, colour: UIColor, img: UIImage) {
        number = no;
        color = colour;
        image = img;
    }
}

struct FlowerBedRow {
    var flowers: [Flower];
    var number: Int;
    
    init(no: Int, flowersInfo: [Flower]) {
        number = no;
        flowers = flowersInfo;
    }
}

struct FlowerBed {
    var number: Int;
    var rows: [FlowerBedRow];
    
    init(no: Int, flowerRows: [FlowerBedRow]) {
        number = no;
        rows = flowerRows;
    }
}

//private var xoInfo: Flower?;
//extension UIImageView {
//    var info: Flower {
//        get {
//            return (objc_getAssociatedObject(self, &xoInfo) as? Flower)!;
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &xoInfo, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
//        }
//    }
//}

class State
{
    static var state: State? = nil;
    
    static func instance() -> State {
        if (state == nil) {
            state = State();
        }
        return state!;
    }
    
    var flowerBeds: [FlowerBed] = [];
    
    var currentBedNo: Int = 0;
    var selectedFlowerNo: Int = 0;
    var selectedFlowerBedRow: Int = 0;
    var selectedFlowerIndex: Int = 0;
    
    func build() {
        let flower1: Flower = Flower(no: 0, colour: UIColor.blueColor(), img: UIImage(named: "Flower1")!);
        let flower2: Flower = Flower(no: 1, colour: UIColor.clearColor(), img: UIImage(named: "Flower1")!);
        let flower3: Flower = Flower(no: 2, colour: UIColor.redColor(), img: UIImage(named: "Flower2")!);
        let flower4: Flower = Flower(no: 3, colour: UIColor.yellowColor(), img: UIImage(named: "Flower1")!);
        let flower5: Flower = Flower(no: 4, colour: UIColor.redColor(), img: UIImage(named: "Flower3")!);
        let flowers: [Flower] = [flower1, flower2, flower3, flower4,flower5];
        
        let flowerBedRow1: FlowerBedRow = FlowerBedRow(no: 0, flowersInfo: flowers);
        let flowerBedRow2: FlowerBedRow = FlowerBedRow(no: 1, flowersInfo: flowers);
        let flowerBedRow3: FlowerBedRow = FlowerBedRow(no: 2, flowersInfo: flowers);
        let flowerBedRow4: FlowerBedRow = FlowerBedRow(no: 3, flowersInfo: flowers);
        let flowerBedRow5: FlowerBedRow = FlowerBedRow(no: 4, flowersInfo: flowers);
        let flowerBedRows: [FlowerBedRow] = [flowerBedRow1, flowerBedRow2, flowerBedRow3, flowerBedRow4, flowerBedRow5];
        
        let flowerBed: FlowerBed = FlowerBed(no: 0, flowerRows: flowerBedRows);
        
        self.flowerBeds.append(flowerBed);
    }
    
    func calFlowerPosition() {
        if (selectedFlowerNo > 0) {
            let row: Int = (25 - selectedFlowerNo) / 5;
            selectedFlowerBedRow = 5 - row;
            selectedFlowerIndex = 5 - (selectedFlowerBedRow * 5 - selectedFlowerNo) - 1;
        }
    }
    
}