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
    var flowerRowsView: Dictionary<Int, [UIView]> = Dictionary<Int, [UIView]>();
    var buttons: Dictionary<Int, [UIButton]> = Dictionary<Int, [UIButton]>();
    var subViews: [UIView] = [];
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
        
        self.scrollView?.contentOffset.x = CGFloat(CGFloat(self.state!.currentBedNo) * scrollView!.frame.size.width);
        
        self.scrollView?.pagingEnabled = true;
        self.scrollView?.showsHorizontalScrollIndicator = false;
        self.scrollView?.showsVerticalScrollIndicator = false;
        self.scrollView?.scrollsToTop = false;
        for index in 0..<colors.count {
            self.flowerRowsView[index] = [];
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
            
            if (self.flowerRowsView[index]?.count == 5) {
                addRowButton.alpha = 0;
            }
            else if (self.flowerRowsView[index]?.count == 0) {
                removeRowButton.alpha = 0;
            }
            
            self.buttons[index] = [addRowButton, removeRowButton];
            subView.addSubview(addRowButton);
            subView.addSubview(removeRowButton);
            self.subViews.append(subView);
            self.scrollView?.addSubview(subView);
        }
        
        self.scrollView?.contentSize = CGSizeMake((self.scrollView?.frame.size.width)! * CGFloat(colors.count), self.scrollView!.frame.size.height);
        
        self.pageControl.backgroundColor = UIColor.grayColor();
        self.pageControl.numberOfPages = colors.count;
        self.pageControl.currentPage = (self.state?.currentBedNo)!;
        
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
                let y: Float = paddingHeight + (50 + paddingHeight) * Float(i);
                let view: UIView = UIView(frame: CGRectMake(0, CGFloat(y), width, 50));
                for j in 0..<flowerBed.rows[i].flowers.count {
                    let x = paddingWidth + (50 + paddingWidth) * Float(j);
                    let imageView: UIImageView = UIImageView(image: UIImage(named: flowerBed.rows[i].flowers[j].image));
                    imageView.userInteractionEnabled = true;
                    imageView.frame.origin = CGPointMake(CGFloat(x), 0);
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
                    view.addSubview(imageView);
                }
                self.flowerRowsView[index]?.append(view);
                subView.addSubview(view);
            }
        }
    }
    
    //MARK: - Create Row and Flower Bed
    func buildRow(number: Int) -> FlowerBedRow? {
        var flowers: [Flower] = [];
        for i in 0..<4 {
            let flower: Flower = Flower(no: i, colour: UIColor.clearColor(), img: "flower");
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
        self.performSegueWithIdentifier("selectColor", sender: self);
    }
    
    func scrollPage() {
        let page: Int = Int(self.scrollView!.contentOffset.x / self.scrollView!.frame.size.width);
        self.pageControl.currentPage = page;
    }
    
    func createRow(sender: UIButton) {
        print("create button is clicked");
        if (self.flowerRowsView[(self.state?.currentBedNo)!]?.count == 5) {
            return;
        }
        let count: Int = (self.flowerRowsView[(self.state?.currentBedNo)!]?.count)!;
        sender.alpha = 1;
        self.buttons[(self.state?.currentBedNo)!]![1].alpha = 1;
        let height: CGFloat = self.scrollView!.frame.size.height - 100;
        let paddingHeight: Float = Float(height - CGFloat(5 * 50)) / 6;
        let width: CGFloat = self.scrollView!.frame.size.width;
        let paddingWidth: Float = Float(width - CGFloat(5 * 50)) / 6;
        let y = (paddingHeight + 50) * Float(count) + paddingHeight;
        let view: UIView = UIView(frame: CGRectMake(0, CGFloat(y), width, 50));
        var k: Int = 5 * count + 1;
        for j in 0..<5 {
            let x = paddingWidth + (50 + paddingWidth) * Float(j);
            let imageView: UIImageView = UIImageView(image: UIImage(named: "Flower1"));
            imageView.userInteractionEnabled = true;
            imageView.frame.origin = CGPointMake(CGFloat(x), 0);
            imageView.frame.size = CGSizeMake(50, 50);
            imageView.backgroundColor = UIColor.clearColor();
            imageView.layer.cornerRadius = 50 / 2;
            imageView.clipsToBounds = true;
            imageView.tag = k;
            k += 1;
            let selector: Selector = #selector(self.flowerClicked(_:));
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector);
            imageView.addGestureRecognizer(singleTap);
            view.addSubview(imageView);
        }
        self.flowerRowsView[(self.state?.currentBedNo)!]?.append(view);
        self.subViews[(self.state?.currentBedNo)!].addSubview(view);
        
        let flower1: Flower = Flower(no: 0, colour: UIColor.clearColor(), img: "Flower1");
        let flower2: Flower = Flower(no: 1, colour: UIColor.clearColor(), img: "Flower1");
        let flower3: Flower = Flower(no: 2, colour: UIColor.clearColor(), img: "Flower1");
        let flower4: Flower = Flower(no: 3, colour: UIColor.clearColor(), img: "Flower1");
        let flower5: Flower = Flower(no: 4, colour: UIColor.clearColor(), img: "Flower1");
        let flowers: [Flower] = [flower1, flower2, flower3, flower4,flower5];
        let flowerBedRow: FlowerBedRow = FlowerBedRow(no: count - 1, flowersInfo: flowers);
        
        if (self.state?.flowerBeds.count <= self.state?.currentBedNo) {
            for i in self.state!.flowerBeds.count..<self.state!.currentBedNo + 1 {
                let flowerBed: FlowerBed = FlowerBed(no: i, flowerRows: []);
                self.state?.flowerBeds.append(flowerBed);
            }
        }
        
        self.state?.flowerBeds[(self.state?.currentBedNo)!].rows.append(flowerBedRow);
        self.flowerBeds = (self.state?.flowerBeds)!;
        
        if (self.flowerRowsView[(self.state?.currentBedNo)!]?.count == 5) {
            sender.alpha = 0;
        }
        
        print(self.view);
    }
    
    func removeRow(sender: UIButton) {
        print("remove button is clicked");
        var views: [UIView] = self.flowerRowsView[(self.state?.currentBedNo)!]!;
        sender.alpha = 1;
        self.buttons[(self.state?.currentBedNo)!]![0].alpha = 1;
        if (views.count == 0) {
            sender.alpha = 0;
        }
        else {
            let view: UIView = views[views.count - 1];
            view.removeFromSuperview();
            self.flowerRowsView[(self.state?.currentBedNo)!]?.popLast();
            self.flowerBeds[(self.state?.currentBedNo)!].rows.popLast();
            self.state?.flowerBeds = self.flowerBeds;
            if (self.flowerRowsView[(self.state?.currentBedNo)!]?.count == 0) {
                sender.alpha = 0;
            }
        }
        
    }
    
    //MARK: - Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        self.pageControl.currentPage = page;
        self.state?.currentBedNo = page;
    }

}

