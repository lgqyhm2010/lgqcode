//
//  ViewController.m
//  HelpVC
//
//  Created by lgqyhm on 12-10-26.
//  Copyright (c) 2012年 lgqyhm. All rights reserved.
//

#import "ViewController.h"

#define Text1   @"“彩云通讯录”是结合中国移动彩云存储平台推出的免费的优质个人信息管理服务。除了拥有便捷的联系人管理功能外，还提供手机客户端、WEB端、WAP端的联系人数据的备份管理服务。"
#define Text2   @"一方面，彩云通讯录优化了系统自带通讯录的功能，使其更加适应中国人使用习惯。\n另一方面，彩云通讯录提供了一些实用的特色功能，例如：通过拨号盘进行智能联系人搜索，合并重复联系人，支持全字段联系人数据同步等等。"
#define Text3   @"因为iOS6增加了权限控制，APP需要获取用户的同意，才能访问到通讯录数据，您可以通过设置->隐私->通讯录中开启彩云通讯录获取通讯录资料的权限，这样即可避免出现无法读取联系人信息以及备份不正常的情况。"
#define Text4   @"彩云通讯录可以通过拨号盘的T9拼音搜索，按照按键上的拼音以T9拼音(以及英文)的规则组合搜索，得出电话号码结果集合。例如，要寻找“李晓明”这个联系人，这个名字的首字母是“LXM”，我们只需在拨号盘上输入对应的数字“596”，李晓明这个联系人就能显示在搜索结果中了。"
#define Text5   @"在导航条中选择同步进入同步界面，我们提供三种不同的同步方式，分别针对三种不同的使用需求。请根据您的实际情况选择相应的同步方式。"
#define Text6   @"合并通讯录：网络通讯录与手机通讯录相互补充，合并，最大限度地保证联系人数据安全。\n上传通讯录：将会把手机通讯录上传到网络端，原网络通讯录将会被覆盖，网络通讯录与手机通讯录将会以手机通讯录为基准保持一致。\n下载通讯录：将会把网络通讯录下载到手机端，原手机端通讯录将会被覆盖，网络通讯录与手机通讯录将会以网络通讯录为基准保持一致。"
#define Text7   @"彩云通讯录提供了合并重复联系人的功能，在联系人列表“按menu菜单>合并联系人”或者“点击更多模块>合并联系人”都能进入合并联系人界面。\n合并联系人分为三步，首先先筛选出资料完全一样的联系人，对这些联系人您可以放心一键智能合并。\n然后我们会筛选出仅姓名重复的联系人，你需要对这些联系人进行一个个手动合并。\n最后我们会筛选出仅号码重复的联系人，您对这些联系人进行手动合并后即成功合并了所有重复的联系人。"

@interface ViewController ()

@end

@implementation ViewController
@synthesize titlesArray = _titlesArray,numbersArray = _numbersArray,helpTableView = _helpTableView,subHelpArray = _subHelpArray;

-(UIFont *)customNormalFontWithSize:(CGFloat) fontsize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontsize];
    //return [UIFont fontWithName:@"MarkerFelt-Thin" size:fontsize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"帮助说明";
	// Do any additional setup after loading the view, typically from a nib.
    UITableView  *tView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];
    //    tView.backgroundColor = [UIColor blackColor];
    tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tView.delegate = self;
    tView.dataSource = self;
    self.helpTableView = tView;
    [tView release];
    [self.view addSubview:self.helpTableView];
    NSMutableArray *narray = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"number%d",i+1]];
        [narray addObject:img];
    }
    self.numbersArray = narray;
    self.titlesArray = [NSMutableArray arrayWithObjects:@"什么是彩云通讯录？",@"彩云通讯录有什么功能？",@"为什么IOS6系统下无法获取联系人数据？",@"如何使用快捷搜索联系人",@"如何同步通讯录到网络",@"不同同步方式之间的区别是什么？",@"联系人有很多重复怎么办？", nil];
    self.subHelpArray = [NSMutableArray arrayWithObjects:Text1,Text2,Text3,Text4,Text5,Text6,Text7, nil];
    expandedIndexes = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.titlesArray.count; i++) {
         NSNumber *expanded = [NSNumber numberWithBool:NO];
        [expandedIndexes addObject:expanded];
    }

}

- (NSMutableArray *)subHelpView {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *subHelp in self.subHelpArray){
        CGSize size = [subHelp sizeWithFont:[self customNormalFontWithSize:12] constrainedToSize:CGSizeMake(290, 1500)lineBreakMode:UILineBreakModeCharacterWrap];
        UIView *helpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+35, size.height+20)];
        helpView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 2, size.height+20-1)];
        line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linecolor"]];
        [helpView addSubview:line];
        [line release];
        
        UILabel *labl =[[UILabel alloc]initWithFrame:CGRectMake(26, 8, size.width, size.height)];
        [labl setNumberOfLines:0];
        [labl setFont:[self customNormalFontWithSize:12]];
        [labl setBackgroundColor:[UIColor clearColor]];
        [labl setText:subHelp];
        [helpView addSubview:labl];
        [labl release];
        [array addObject:helpView];
        [helpView release];
        
    }
    return array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc   {
    
    [_titlesArray release];
    [_helpTableView release];
    [_numbersArray release];
    [_subHelpArray release];
    [super dealloc];
}

#pragma mark TableView DataSource && Delegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   {
    BOOL expanded;
    for (NSNumber *expand in expandedIndexes)   {
        if ([expand boolValue])
            expanded = YES;
    }
    if (expanded) {
        return self.titlesArray.count;
    }else
        return self.titlesArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger expandIndex;
    for (NSNumber *expand in expandedIndexes)   {
        if ([expand boolValue])
            expandIndex = [expandedIndexes indexOfObject:expand];
            
            }
    if (indexPath.row == expandIndex + 1) {
        UIView *subView = [[self subHelpView]objectAtIndex:expandIndex];
        return subView.frame.size.height;
    }else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *cellIndetifier = @"cellIndetifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier]autorelease];
    }
    NSInteger expandIndex;
    for (NSNumber *expand in expandedIndexes)   {
        if ([expand boolValue])
            expandIndex = [expandedIndexes indexOfObject:expand];
        
    }
    
    if (indexPath.row == expandIndex + 1 || expandIndex == 6) {
        UIView *subView = [[self subHelpView]objectAtIndex:expandIndex];
        [cell.contentView addSubview:subView];
    }else   {
        UIImageView *logo = (UIImageView *)[cell.contentView viewWithTag:100];
        if (logo)
            [logo removeFromSuperview];
        logo = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 33/2, 33/2)] autorelease];
        logo.image = [self.numbersArray objectAtIndex:indexPath.row];
        logo.tag = 100;
        [cell.contentView addSubview:logo];
        
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:200];
        if (title)
            [title removeFromSuperview];
        title = [[[UILabel alloc] initWithFrame:CGRectMake(32, 0, 260, 45)] autorelease];
        title.text = [self.titlesArray objectAtIndex:indexPath.row];
        title.font = [self customNormalFontWithSize:14];
        title.backgroundColor = [UIColor clearColor];
        title.tag = 200;
        [cell.contentView addSubview:title];
        
        UIImageView *indicate = (UIImageView *)[cell.contentView viewWithTag:1000];
        if (indicate)
            [indicate removeFromSuperview];
        indicate = [[[UIImageView alloc]initWithFrame:CGRectMake(285, 14, 33/2, 33/2)]autorelease];
        if (indexPath.row == expandIndex)
            indicate.image = [UIImage imageNamed:@"opened.png"];
        else
        indicate.image = [UIImage imageNamed:@"closed.png"];
        indicate.tag = 1000;
        [cell.contentView addSubview:indicate];
        NSInteger newRow = indexPath.row>=expandIndex && expandIndex?indexPath.row - 1:indexPath.row;
        if (newRow%2 == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkbottom.png"]];
        }else
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom.png"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [expandedIndexes removeObjectAtIndex:indexPath.row];
    NSNumber *select = [NSNumber numberWithBool:YES];
    [expandedIndexes insertObject:select atIndex:indexPath.row];
    [self.helpTableView beginUpdates];
//    [self.helpTableView reloadData];

//    [self viewWillAppear:YES];
//    [self viewDidAppear:YES];
    [self.helpTableView endUpdates];
//    [self.helpTableView reloadData];
}

@end
