//
//  UserHelpViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "UserHelpViewController.h"
#import "ToolSet.h"
#import "UIHelpViewCell.h"

#define kHeigthOfNavigationBar  44
#define kHeightOfTabBar         49


@interface UserHelpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *selectedCellIndexPath;   // 保存已选中的IndexPath
@property (retain, nonatomic) NSArray *titlesArray;                 // 保存标题内容文字
@property (retain, nonatomic) NSArray *subHelpTextArray;            // 保存帮助内容文字
@property (retain, nonatomic) NSArray *subHelpViewArray;            // 保存帮助视图

- (UIView *)cellContentViewAtIndexPath:(NSIndexPath *)indexPath;    // 返回一个UIView加入到cell.contentView中作为cell的内容视图

@end

@implementation UserHelpViewController

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
    [self setNavigationTitle:@"用户帮助"];
    [self setBackNavigationItemTitle:@"返回"];
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.subHelpTextArray = nil;
    self.tableView = nil;
    self.selectedCellIndexPath = nil;
    self.titlesArray = nil;
    self.subHelpViewArray = nil;
    [super dealloc];
}

#pragma mark - getter & setter

- (UITableView *)tableView
{
    if ( !_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.frame) - kHeigthOfNavigationBar) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (NSArray *)titlesArray
{
    if ( !_titlesArray)
    {
            _titlesArray = [[NSArray alloc] initWithObjects:kTitle1, kTitle2, kTitle3, kTitle4, nil];
    
        
    }
    return _titlesArray;
}

- (NSArray *)subHelpTextArray
{
    if ( !_subHelpTextArray)
    {
            _subHelpTextArray = [[NSArray alloc] initWithObjects:Text1,Text2,Text3,Text4, nil];
   }
    return _subHelpTextArray;
}

- (NSArray *)subHelpViewArray
{
    if ( !_subHelpViewArray)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *subHelp in self.subHelpTextArray)
        {
            UIFont *fontOfText = [ToolSet customNormalFontWithSize:14];
            CGSize size = [subHelp sizeWithFont:fontOfText constrainedToSize:CGSizeMake(290, 1500)lineBreakMode:UILineBreakModeCharacterWrap];
            
            // content view
            UIView *helpView = [[UIView alloc]initWithFrame:CGRectMake(0, kTableViewCollapseRowHeight, size.width+35, size.height+20)];
            //        helpView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f]; // 灰黑色
            helpView.backgroundColor = [UIColor whiteColor];
            
            // blue line
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 2, size.height+20-1)];
            line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linecolor"]];
            [helpView addSubview:line];
            [line release];
            
            // text lable
            UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(26, 8, size.width, size.height)];
            [lable setNumberOfLines:INT32_MAX];
            [lable setFont:fontOfText];
            [lable setText:subHelp];
            [lable setBackgroundColor:[UIColor clearColor]];
            [helpView addSubview:lable];
            [lable release];
            
            [array addObject:helpView];
            [helpView release];
        }
        
        
        _subHelpViewArray = [array copy];
    }
    return _subHelpViewArray;
}

#pragma mark - TableView DataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Helpcell";
    
    UIHelpViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UIHelpViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 帮助标题
    UIView *contentView = [cell viewWithTag:kContentViewTag];
    if (contentView)
        [contentView removeFromSuperview];
    contentView = [self cellContentViewAtIndexPath:indexPath];
    contentView.tag = kContentViewTag;
    [cell.contentView addSubview:contentView];
    
    // 帮助内容视图
    cell.subHelpView = [self.subHelpViewArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].isSelected)
    {
        // 当前cell已经是选中状态，则取消选中
        self.selectedCellIndexPath = nil;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];  // 由于使用自定义cell，所以需要调用deselectRowAtIndexPath方法，remove extent view
    }
    else
    {
        self.selectedCellIndexPath = indexPath;
    }
    
    // 重载选中的cell（折叠或者展开）
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    return self.selectedCellIndexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果已选中的indexPath和当前的indexPath相等，则展开cell，即改变cellHeight的高度
	if(self.selectedCellIndexPath != nil && [self.selectedCellIndexPath compare:indexPath] == NSOrderedSame)
    {
        UIView *view = [self.subHelpViewArray objectAtIndex:indexPath.row];
        CGFloat cellHight = roundf(view.frame.size.height + kTableViewCollapseRowHeight);
        
		return cellHight;
    }
	else
    {
        return kTableViewCollapseRowHeight;
    }
}

#pragma mark - extension

- (UIView *)cellContentViewAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kTableViewCollapseRowHeight)];
    
    /*
     //    // cell顶部分割线
     //    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
     //    [cellContentView addSubview:line];
     //    [line release];
     //
     //    // 数字
     //    UIImageView *logo = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 33/2, 33/2)] autorelease];
     //    logo.image = [self.numbersArray objectAtIndex:indexPath.row];
     //    logo.tag = 100;
     //    [cellContentView addSubview:logo];
     */
    
    // 阴影效果背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:cellContentView.frame];
    backgroundImageView.image = [UIImage imageNamed:@"helpCellBackground.png"];
    [cellContentView addSubview:backgroundImageView];
    [backgroundImageView release];
    
    UILabel *title = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 260, 45)] autorelease];
    title.text = [self.titlesArray objectAtIndex:indexPath.row];
    title.font = [ToolSet customBoldFontWithSize:16];
    title.textColor = [UIColor darkGrayColor];
    title.backgroundColor = [UIColor clearColor];
    title.tag = 200;
    [cellContentView addSubview:title];
    
    // 箭头
    UIImageView *indicate = [[[UIImageView alloc]initWithFrame:CGRectMake(285, 14, 33/2, 33/2)] autorelease];
    indicate.image = [UIImage imageNamed:@"closed.png"];
    indicate.tag = kIndicateTag;
    [cellContentView addSubview:indicate];
    
    return [cellContentView autorelease];
}



@end
