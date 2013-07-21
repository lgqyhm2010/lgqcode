//
//  GuidePhotoViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-21.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "GuidePhotoViewController.h"

@interface GuidePhotoViewController ()<UIScrollViewDelegate>
{
    EntryType entryType;
}

@property (nonatomic,retain) UIScrollView *guidePhoto;

@end

@implementation GuidePhotoViewController

#pragma mark view lifestyle

- (id)initWithEntryType:(EntryType)type
{
    if (self==[super init]) {
        entryType = type;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
