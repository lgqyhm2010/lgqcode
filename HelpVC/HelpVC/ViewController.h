//
//  ViewController.h
//  HelpVC
//
//  Created by lgqyhm on 12-10-26.
//  Copyright (c) 2012年 lgqyhm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>    {
    
    NSMutableArray *expandedIndexes;
}
@property (retain, nonatomic) UITableView *helpTableView;
@property (retain, nonatomic) NSMutableArray *numbersArray;
@property (retain, nonatomic) NSMutableArray *titlesArray;
@property (retain, nonatomic) NSMutableArray *subHelpArray;
@end
