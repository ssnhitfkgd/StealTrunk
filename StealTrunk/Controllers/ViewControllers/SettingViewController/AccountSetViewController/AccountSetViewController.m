//
//  AccountSetViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-8-10.
//
//

#import "AccountSetViewController.h"
#import "AccountDTO.h"


@interface AccountSetViewController ()

@end

@implementation AccountSetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"帐户安全", nil);
    
    self.tableView.backgroundView = [[UIView alloc] init];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:227./255. green:228./255. blue:230./255. alpha:1]];
    
    UILabel *labelTip = [[UILabel alloc] init];
    [labelTip setText:@"当前帐户安全等级：不安全"];
    [labelTip setTextAlignment:NSTextAlignmentCenter];
    [labelTip setFont:[UIFont systemFontOfSize:14]];
    [labelTip sizeToFit];
    
    [self.tableView setTableHeaderView:labelTip];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.footer = NSLocalizedString(@"绑定多个社交帐号可提升账户安全性", nil);
        NSString *reuseIdentifier = @"account_setting";
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"新浪微博", nil);
            
			cell.detailTextLabel.text = [[AccountDTO sharedInstance] sina_user_info].screen_name;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"QQ账号", nil);
            
			cell.detailTextLabel.text = [[AccountDTO sharedInstance] sina_user_info].screen_name;
		}];
    }];

    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.footer = NSLocalizedString(@"建议绑定手机号，并设置密码", nil);
        NSString *reuseIdentifier = @"account_setting";
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"手机帐号", nil);
            
			cell.detailTextLabel.text = NSLocalizedString(@"13718378010", nil);;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"密码设置", nil);
            
			cell.detailTextLabel.text = NSLocalizedString(@"未设置", nil);
		}];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
