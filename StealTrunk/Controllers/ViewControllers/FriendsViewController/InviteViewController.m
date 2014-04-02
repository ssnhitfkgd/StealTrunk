//
//  InviteViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import "InviteViewController.h"
#import "InviteListViewController.h"
#import "InviteDetailViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"邀请好友", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 77+44)];
    headerView.backgroundColor = [UIColor yellowColor];
    
    UIImageView *inviteDesc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite-desc"]];
    inviteDesc.frame = CGRectMake(0, 0, 320, 77);
    
    UIButton *copyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyCodeBtn.frame = CGRectMake(0, 0, 160, 44);
    copyCodeBtn.bottom = headerView.height;
    copyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    copyCodeBtn.backgroundColor = BenGreen;
    [copyCodeBtn setTitle:NSLocalizedString(@"拷贝邀请码",nil) forState:UIControlStateNormal];
    [copyCodeBtn addTarget:self action:@selector(copyCodeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *inviteDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteDetailBtn.frame = copyCodeBtn.frame;
    inviteDetailBtn.left = copyCodeBtn.right;
    inviteDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    inviteDetailBtn.backgroundColor = BenGreen;
    [inviteDetailBtn setTitle:NSLocalizedString(@"邀请详情", nil) forState:UIControlStateNormal];
    [inviteDetailBtn addTarget:self action:@selector(inviteDetailBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
    separator.backgroundColor = RGB246;
    separator.centerX = headerView.width/2.0;
    separator.top = copyCodeBtn.top;
    
    [headerView addSubview:inviteDesc];
    [headerView addSubview:copyCodeBtn];
    [headerView addSubview:inviteDetailBtn];
    [headerView addSubview:separator];
    
    [self.tableView setTableHeaderView:headerView];
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        //section.title = NSLocalizedString(@"帐号绑定", nil);
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath)
        {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			cell.textLabel.text = NSLocalizedString(@"邀请新浪微博好友", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
			
            InviteListViewController *inviteListVC = [[InviteListViewController alloc] init];
            [self.navigationController pushViewController:inviteListVC animated:YES];
            
		}];
        
        if ([WXApi isWXAppInstalled]) {
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath)
             {
                 staticContentCell.cellStyle = UITableViewCellStyleValue1;
                 cell.textLabel.text = NSLocalizedString(@"邀请微信好友", nil);
             } whenSelected:^(NSIndexPath *indexPath) {
                 
             }];
        }
        
#warning 判断，有无装QQ
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath)
         {
             staticContentCell.cellStyle = UITableViewCellStyleValue1;
             cell.textLabel.text = NSLocalizedString(@"邀请QQ好友", nil);
         } whenSelected:^(NSIndexPath *indexPath) {
             
         }];
	}];

    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {

        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"DetailTextCell";
            
			cell.textLabel.text = NSLocalizedString(@"分享邀请码到微信朋友圈", nil);
			cell.detailTextLabel.text = @"xxx";
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
	}];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath)
         {
             staticContentCell.cellStyle = UITableViewCellStyleValue1;
             cell.textLabel.text = NSLocalizedString(@"前往AppStore填写评价", nil);
         } whenSelected:^(NSIndexPath *indexPath) {
             
         }];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)copyCodeBtnPress:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSString *pastStr = [[AccountDTO sharedInstance] monstea_user_info].user_id;
    
    pasteboard.string = pastStr;
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"邀请码已拷贝到粘贴板", nil)];
}

- (void)inviteDetailBtnPress:(id)sender
{
    [self.navigationController pushViewController:[[InviteDetailViewController alloc] init] animated:YES];
}

@end
