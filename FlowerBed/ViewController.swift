//
//  ViewController.swift
//  FlowerBed
//
//  Created by 侯 翔 on 2016/03/29.
//  Copyright © 2016年 HX Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate
{
    
    @IBOutlet var scrollView: UIScrollView?;
    @IBOutlet var pageControl: UIPageControl!;
    var colors: [UIColor] = [UIColor.clearColor(), UIColor.clearColor(), UIColor.clearColor(), UIColor.clearColor(), UIColor.clearColor(), UIColor.clearColor()];
    var frame: CGRect = CGRectMake(0, 0, 0, 0);
    var flowerBeds: [FlowerBed] = [];
    var state: State? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.scrollView?.delegate = self;
        
        self.state = State.instance();
        self.state?.build();
        
        self.flowerBeds = (self.state?.flowerBeds)!;
        
//        let x: Int = Int(20 / 4.1);
//        print(x);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.scrollView?.pagingEnabled = true;
        self.scrollView?.showsHorizontalScrollIndicator = false;
        self.scrollView?.showsVerticalScrollIndicator = false;
        self.scrollView?.scrollsToTop = false;
        for index in 0..<colors.count {
            let addRowButton: UIButton = UIButton(type: UIButtonType.ContactAdd);
            addRowButton.layer.cornerRadius = 20;
            addRowButton.frame.origin = CGPointMake(100, 0);
            addRowButton.addTarget(self, action: #selector(self.createRow(_:)), forControlEvents: UIControlEvents.TouchUpInside);
            
            let removeRowButton: UIButton = UIButton(frame: CGRectMake(200, 0, 25, 25));
            removeRowButton.setImage(UIImage(named: "TrashIcon"), forState: UIControlState.Normal);
            removeRowButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit;
            removeRowButton.imageView?.layer.cornerRadius = 12.5;
            removeRowButton.imageView?.clipsToBounds = true;
            removeRowButton.addTarget(self, action: #selector(self.removeRow(_:)), forControlEvents: UIControlEvents.TouchUpInside);
            
            frame.origin.x = self.scrollView!.frame.size.width * CGFloat(index);
            frame.size = self.scrollView!.frame.size;
            
            let subView: UIView = UIView(frame: self.frame);
            subView.backgroundColor = colors[index];
            
            self.addToView(subView, index: index);
            
            subView.addSubview(addRowButton);
            subView.addSubview(removeRowButton);
            self.scrollView?.addSubview(subView);
        }
        
        self.scrollView?.contentSize = CGSizeMake((self.scrollView?.frame.size.width)! * CGFloat(colors.count), self.scrollView!.frame.size.height);
        
        self.pageControl.backgroundColor = UIColor.grayColor();
        self.pageControl.numberOfPages = colors.count;
        self.pageControl.currentPage = 0;
        
        self.pageControl.addTarget(self, action: #selector(self.pageChanged), forControlEvents: UIControlEvents.ValueChanged);
        
//        let swipeGestureLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.scrollPage));
//        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.Left;
//        self.view.addGestureRecognizer(swipeGestureLeft);
//        
//        let swipeGestureRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.scrollPage));
//        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.Right;
//        self.view.addGestureRecognizer(swipeGestureRight);
    }
    
    //MARK: - Add to view
    func addToView(subView: UIView, index: Int) {
        let width: CGFloat = self.scrollView!.frame.size.width;
        let paddingWidth: Float = Float(width - CGFloat(5 * 50)) / 6;
        let height: CGFloat = self.scrollView!.frame.size.height - 100;
        let paddingHeight: Float = Float(height - CGFloat(5 * 50)) / 6;
        
        var k: Int = 1;
        if (self.flowerBeds.count - 1 >= index) {
            let flowerBed: FlowerBed = self.flowerBeds[index];
            for i in 0..<flowerBed.rows.count {
                let y = paddingHeight + (50 + paddingHeight) * Float(i);
                for j in 0..<flowerBed.rows[i].flowers.count {
                    let x = paddingWidth + (50 + paddingWidth) * Float(j);
                    let imageView: UIImageView = UIImageView(image: flowerBed.rows[i].flowers[j].image);
                    imageView.userInteractionEnabled = true;
                    imageView.frame.origin = CGPointMake(CGFloat(x), CGFloat(y));
                    imageView.frame.size = CGSizeMake(50, 50);
                    imageView.backgroundColor = flowerBed.rows[i].flowers[j].color;
                    imageView.layer.cornerRadius = 50 / 2;
                    imageView.clipsToBounds = true;
                    imageView.tag = k;
                    k += 1;
                    //let selector: Selector = Selector(self.flowerClicked(flowerBed.rows[i].flowers[j]));
                    let selector: Selector = #selector(self.flowerClicked(_:));
                    let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector);
                    imageView.addGestureRecognizer(singleTap);
                    subView.addSubview(imageView);
                }
            }
        }
    }
    
    //MARK: - Create Row and Flower Bed
    func buildRow(number: Int) -> FlowerBedRow? {
        var flowers: [Flower] = [];
        for i in 0..<4 {
            let flower: Flower = Flower(no: i, colour: UIColor.clearColor(), img: UIImage(named: "flower")!);
            flowers.append(flower);
        }
        let flowerBedRow: FlowerBedRow = FlowerBedRow(no: number, flowersInfo: flowers);
        return flowerBedRow;
    }
    
    func addInFlowerBed(number: Int, row: FlowerBedRow) -> FlowerBed {
        var flowerBed: FlowerBed = self.flowerBeds[number];
        var no: Int = 0;
        if (flowerBed.rows.count < 5 && flowerBed.rows.count > 0) {
            no = flowerBed.rows.count - 1
        }
        
        if (flowerBed.rows.count < 5) {
            let flowerBedRow: FlowerBedRow = self.buildRow(no)!;
            flowerBed.rows.append(flowerBedRow);
        }
        
        return flowerBed;
    }
    
    func pageChanged(sender: UIPageControl) {
        var frame: CGRect = (self.scrollView?.frame)!;
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage);
        self.scrollView?.scrollRectToVisible(frame, animated: true);
    }
    
    func flowerClicked(sender: UITapGestureRecognizer) {
        print(sender.view);
        self.state?.selectedFlowerNo = (sender.view as! UIImageView).tag;
        print("No." + String(self.state?.selectedFlowerNo) + "flower is clicked!!!");
        self.state?.calFlowerPosition();
        print("Clicked Flower position is Row : " + String(self.state?.selectedFlowerBedRow) + " index : " + String(self.state?.selectedFlowerIndex));
    }
    
    func scrollPage() {
        let page: Int = Int(self.scrollView!.contentOffset.x / self.scrollView!.frame.size.width);
        self.pageControl.currentPage = page;
    }
    
    func createRow(sender: UIButton) {
        print("create button is clicked");
        self.viewDidAppear(true);
    }
    
    func removeRow(sender: UIButton) {
        print("remove button is clicked");
    }
    
    //MARK: - Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        self.pageControl.currentPage = page;
    }

}

