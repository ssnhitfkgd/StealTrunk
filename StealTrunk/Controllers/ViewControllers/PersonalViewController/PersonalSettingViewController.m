//
//  PersonalSettingViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "PersonalSettingViewController.h"
#import "MaskAvatarCamera.h"
#import "FileClient.h"
#import "GMGridView.h"

@interface PersonalSettingViewController ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewActionDelegate>

@property (nonatomic, strong) Monstea_user_info *userInfo;
@property (nonatomic, strong) GMGridView *gmGridView;
@property (nonatomic, strong) NSMutableArray *currentData;


@end

@implementation PersonalSettingViewController
@synthesize userInfo = _userInfo;
@synthesize gmGridView = _gmGridView;
@synthesize currentData = _currentData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"编辑资料", nil);
        
        //set data
        self.currentData = [NSMutableArray array];
        for (int i = 0; i < 9; i ++)
        {
            [self.currentData addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.backgroundView = [[UIView alloc] init];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    /////////////////////////////////////photo wall ->START
    UIView *photoWall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320+24)];
    photoWall.backgroundColor = [UIColor darkGrayColor];
    
    //GMGridView
    NSInteger spacing = 5;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    gmGridView.backgroundColor = [UIColor clearColor];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.mainSuperView = self.navigationController.view;
    
    //
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    tipLabel.top = _gmGridView.bottom;
    tipLabel.textAlignment = UITextAlignmentCenter;
    tipLabel.text = NSLocalizedString(@"点击更换照片，拖拽更改顺序", nil);
    tipLabel.font = [UIFont systemFontOfSize:14.0f];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor whiteColor];
    
    [photoWall addSubview:gmGridView];
    [photoWall addSubview:tipLabel];
    [self.tableView setTableHeaderView:photoWall];
    /////////////////////////////////////photo wall <-END
    
    //取消按钮
    /* 移到viewDidAppear中了
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancleBtn.frame = CGRectMake(0, 0, 50, 29);
    [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = cancleItem;
    */
     
    //保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(0, 0, 50, 29);
    [saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    self.userInfo = [[AccountDTO sharedInstance] monstea_user_info];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setCells];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //取消按钮 (与BaseNavi的left按钮冲突，所以移到viewDidAppear中)
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancleBtn.frame = CGRectMake(0, 0, 50, 29);
    [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = cancleItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCells{
    [self removeAllSections];
    
    //sections
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = 80;
            
            KKAvatarView *avatar = [KKAvatarView creatWithSize:60];
            [avatar setUserInfo:self.userInfo EnableTap:NO];
            avatar.left = 220;
            avatar.top = 10;
            [cell addSubview:avatar];
            
			cell.textLabel.text = NSLocalizedString(@"头像", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
            MaskAvatarCamera *camera = [[MaskAvatarCamera alloc] init];
            camera.delegate = self;
            
			[self presentViewController:camera animated:YES completion:^{ }];
		}];
    }];
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"nameCell";
            
			cell.textLabel.text = NSLocalizedString(@"名字", nil);
            cell.detailTextLabel.text = self.userInfo.user_name;
            
		} whenSelected:^(NSIndexPath *indexPath) {
			
            SimpleTextViewController *inputVC = [[SimpleTextViewController alloc] initWithText:self.userInfo.user_name Type:TextTypeUserName];
            inputVC.delegate = self;
            [self.navigationController pushViewController:inputVC animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ageCell";
            
			cell.textLabel.text = NSLocalizedString(@"年龄", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",self.userInfo.age,self.userInfo.constellation];
            
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"bloodCell";
            
			cell.textLabel.text = NSLocalizedString(@"血型", nil);
            cell.detailTextLabel.text = self.userInfo.blood;
            
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"signCell";
            
			cell.textLabel.text = NSLocalizedString(@"签名", nil);
            cell.detailTextLabel.text = self.userInfo.user_sign;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.numberOfLines = 0;
            
            
            //计算文字高度
            staticContentCell.cellHeight = [self.userInfo.user_sign heightWithFont:[UIFont systemFontOfSize:16.0] constrainedWidth:200 lineBreakMode:UILineBreakModeWordWrap];
            if (staticContentCell.cellHeight < 44) {
                staticContentCell.cellHeight = 44;
            }
            
		} whenSelected:^(NSIndexPath *indexPath) {
			
            SimpleTextViewController *inputVC = [[SimpleTextViewController alloc] initWithText:self.userInfo.user_sign Type:TextTypeSignText];
            inputVC.delegate = self;
            [self.navigationController pushViewController:inputVC animated:YES];
            
		}];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Actions
- (void)cancleBtnPress:(id)sender{
    UIAlertView *cancleAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:NSLocalizedString(@"放弃对资料的修改?", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"继续编辑", nil)
                                                otherButtonTitles:NSLocalizedString(@"放弃", nil), nil];
    cancleAlert.tag = 1000;
    
    [cancleAlert show];
}

- (void)saveBtnPress:(id)sender{
    
    self.userInfo.gender = 2;//4test
    
    [[FileClient sharedInstance] updateMyProfile:self.userInfo
                                          avatar:nil
                                        delegate:self
                                        selector:@selector(saveRequestEnd:)
                                   selectorError:@selector(requestError2:)
                                progressSelector:nil];
    
}

#pragma mark - Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1000:
        {
            if (buttonIndex==1) {
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)alreadyUpdateAvatar:(NSString *)avatar
{
    self.userInfo.avatar = avatar;
}

- (void)returnText:(NSString *)str Type:(TextType)type
{
    switch (type) {
        case TextTypeUserName:
        {
            self.userInfo.user_name = str;
        }
            break;
        case TextTypeSignText:
        {
            self.userInfo.user_sign = str;
        }
            break;
        default:
            break;
    }
}

#pragma mark - NetWork
- (void)saveRequestEnd:(NSData *)data
{
    id realData = [self requestDidFinishLoad2:data];
    if (realData) {
        
    }
}

- (id)requestDidFinishLoad2:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0){
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue]){
            //success!
            id realData = [[json_string JSONValue]  objectForKey:@"data"];
            return realData;
            
        }else{
            [self requestError2:[[json_string JSONValue]  objectForKey:@"data"]];
        }
    }else{
        [self requestError2:@"json is null"];
    }
    
    return nil;
}

- (void)requestError2:(NSString *)error
{
    [SVProgressHUD showErrorWithStatus:error];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(100, 100);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor redColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 0;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{

}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    self.tableView.scrollEnabled = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    self.tableView.scrollEnabled = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

//////////////////////////////////////////////////////////////

@end
