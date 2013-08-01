//
//  SendWishViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-8-1.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SendWishViewController.h"

#define KToolBarHeight 44
#define KPickerTag  1000
#define KPlaceHolderTag 1001

@interface SendWishViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITextView *contentView;
@property (nonatomic,strong) UIView *toolBar;


@end

@implementation SendWishViewController

#pragma mark getter

- (UITextView *)contentView
{
    if (!_contentView) {
        CGFloat height = CGRectGetHeight(self.view.frame) - 44-KToolBarHeight;
        _contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
        _contentView.delegate = self;
        _contentView.backgroundColor = [UIColor blueColor];
        UILabel *placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 320, 20)];
        placeHolder.tag = KPlaceHolderTag;
        placeHolder.text = @"请输入祝福";
        placeHolder.font = [UIFont systemFontOfSize:12];
        placeHolder.textColor = [UIColor lightGrayColor];
        placeHolder.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:placeHolder];
    }
    return _contentView;
}




- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame), 320, KToolBarHeight)];
        [_toolBar setBackgroundColor:[UIColor yellowColor]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"选择" forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, 0, KToolBarHeight, KToolBarHeight);
        btn.tag = KPickerTag;
        [btn addTarget:self action:@selector(pickerImgView) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:btn];
    }
    return _toolBar;
}

- (void)pickerImgView
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片", nil];
    [sheet showInView:self.view];
}


- (void)showKeyBoard:(NSNotification *)not
{
    NSDictionary *dataDic = [not userInfo];
    NSValue *rect = dataDic[UIKeyboardFrameEndUserInfoKey];
    CGRect keyBord;
    [rect getValue:&keyBord];
    __block CGFloat height =CGRectGetHeight(self.view.frame)-KToolBarHeight- keyBord.size.height;
    __block SendWishViewController *vc = self;
    [UIView animateWithDuration:0.0 animations:^{
        [vc.contentView setFrame:CGRectMake(0, 0, 320, height)];
        [vc.toolBar setFrame:CGRectMake(0, height, 320, KToolBarHeight)];
    }];
}

- (void)sendWish
{
    
}

- (void)backClick
{
    [self dismissModalViewControllerAnimatedMy:YES];
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
    
    [self setNavigationItemNormalImage:@"send_icon_normal.png" HightImage:@"send_icon_pressed.png" selector:@selector(sendWish) isRight:YES];
    [self setBackNavigationItemTitle:@"返回" selector:@selector(backClick)];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.toolBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark actionsheet delegate

typedef NS_ENUM(NSInteger, ActionSheetIndex){
    IndexCamera,
    IndexAlbum
};

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case IndexCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagPickerVC = [[UIImagePickerController alloc]init];
                imagPickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagPickerVC.delegate = self;
                [self presentModalViewController:imagPickerVC animated:YES];
            }
            //                [Notification showMsgConfirm:self title:KMsgDefault message:KNotSuppor tag:1];
        }
            break;
        case IndexAlbum:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagPickerVC = [[UIImagePickerController alloc]init];
                imagPickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagPickerVC.delegate = self;
                [self presentModalViewController:imagPickerVC animated:YES];
                
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark uiimagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
    //    [self.personImage setImage:pickerImage forState:UIControlStateNormal];
    //    imgeData = [UIImageJPEGRepresentation(pickerImage, 0.2)copy];
    UIButton *btn =(UIButton *) [self.toolBar viewWithTag:KPickerTag];
    [btn setImage:pickerImage forState:UIControlStateNormal];
}

#pragma mark textview delegate

- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *placeHolder = (UILabel *)[textView viewWithTag:KPlaceHolderTag];
    if ([textView hasText]) {
        placeHolder.hidden = YES;
    }else
        placeHolder.hidden = NO;
}


@end
