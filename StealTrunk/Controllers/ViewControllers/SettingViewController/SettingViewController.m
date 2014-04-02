//
//  settingViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-19.
//
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "BlockListViewController.h"
#import "KLSwitch.h"
#import "MessageSetViewController.h"
#import "AccountDTO.h"
#import "AccountSetViewController.h"
#import "SVWebViewController.h"

#define kGreenColor [UIColor colorWithRed:154/255.0 green: 203/255.0 blue: 66/255.0 alpha: 1.0]
#define kBlueColor [UIColor colorWithRed:129/255.0 green: 198/255.0 blue: 221/255.0 alpha: 1.0]
#define kYellowColor [UIColor colorWithRed:233/255.0 green: 182/255.0 blue: 77/255.0 alpha: 1.0]
#define kOrangeColor [UIColor colorWithRed:288/255.0 green: 135/255.0 blue: 67/255.0 alpha: 1.0]
#define kRedColor [UIColor colorWithRed:158/255.0 green: 59/255.0 blue: 51/255.0 alpha: 1.0]

@interface SettingViewController ()
@end

@implementation SettingViewController

static SettingViewController* _sharedInstance = nil;

+ (id)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[SettingViewController alloc] init];
        }
    }
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"设置", nil);
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self parseSetting];
    [self initTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(settingDict)
    {
        NSString *plistPath = [self getPlist];
        [settingDict writeToFile:plistPath atomically:YES];
    }
    
}

- (NSString*)getPlist
{
    NSString *filePath = [FileUtil getBasePath];
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_setting.plist", [[AccountDTO sharedInstance] monstea_user_info].user_id]];
    return plistPath;
}

- (void)createPlist
{

    NSString *plistPath = [self getPlist];
   
    if(![FileUtil isExist:plistPath])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSDictionary *functionDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"music", @"1", @"effect", @"1", @"like_auto_sns", @"1", @"comment_auto_sns",  nil];
        NSDictionary *accountBindDict = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"phone_number", @"10000", @"sina", @"1", @"qq", nil];
        NSDictionary *newMsgNoticeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"night_alone",@"1", @"new_msg",@"1", @"friend_invite",@"1", @"chat", nil];
        NSDictionary *accountSetDict = [NSDictionary dictionaryWithObjectsAndKeys:newMsgNoticeDict, @"new_msg_notice", @"1", @"secure", nil];

        NSMutableDictionary *setDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:functionDict, @"functionDict", accountBindDict, @"accountBindDict", accountSetDict, @"accountSetDict", nil];
        [setDict writeToFile:plistPath atomically:YES];
    }

}


- (void)parseSetting
{
    NSString *plistPath = [self getPlist];
    
    if(![FileUtil isExist:plistPath])
    {
        [self createPlist];
    }
    
    settingDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    id functionDict = [settingDict objectForKey:@"functionDict"];
    self.music = [[functionDict objectForKey:@"music"] boolValue];
    self.effect = [[functionDict objectForKey:@"effect"] boolValue];
    self.like_auto_sns = [[functionDict objectForKey:@"like_auto_sns"] boolValue];
    self.comment_auto_sns = [[functionDict objectForKey:@"comment_auto_sns"] boolValue];
    id accountSetDict = [[settingDict objectForKey:@"accountSetDict"] objectForKey:@"new_msg_notice"];
    
    self.night_alone = [[accountSetDict objectForKey:@"night_alone"] boolValue];
    self.new_msg = [[accountSetDict objectForKey:@"new_msg"] boolValue];
    self.friend_invite = [[accountSetDict objectForKey:@"friend_invite"] boolValue];
    self.chat = [[accountSetDict objectForKey:@"chat"] boolValue];
}


- (void)initTableView
{
    self.tableView.backgroundView = [[UIView alloc] init];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:227./255. green:228./255. blue:230./255. alpha:1]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:RGB(228, 228, 228)];

    
    if(!settingDict)
    {
        [self parseSetting];
    }

	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = NSLocalizedString(@"功能设置", nil);
        NSString *reuseIdentifier = @"setting";
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[settingDict objectForKey:@"functionDict"]];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = reuseIdentifier;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"音乐", nil);
            
            KLSwitch *musiceModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [musiceModeSwitch setOnTintColor: kGreenColor];
            [musiceModeSwitch setOn: [[dict objectForKey:@"music"] boolValue]
                           animated: NO];
            [musiceModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d", isOn] forKey:@"music"];
                [settingDict setObject:dict forKey:@"functionDict"];

            }];
            
			cell.accessoryView = musiceModeSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = reuseIdentifier;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"音效", nil);
            
            KLSwitch *audioModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [audioModeSwitch setOnTintColor: kGreenColor];
            [audioModeSwitch setOn: [[dict objectForKey:@"effect"] boolValue]
                          animated: NO];
            [audioModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d", isOn] forKey:@"effect"];
                [settingDict setObject:dict forKey:@"functionDict"];

            }];
            
			cell.accessoryView = audioModeSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = reuseIdentifier;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"喜欢时自动同步到SNS", nil);
            
            KLSwitch *snsModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [snsModeSwitch setOnTintColor: kGreenColor];
            [snsModeSwitch setOn: [[dict objectForKey:@"like_auto_sns"] boolValue]
                        animated: NO];
            [snsModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d", isOn] forKey:@"like_auto_sns"];
                [settingDict setObject:dict forKey:@"functionDict"];

            }];
            
			cell.accessoryView = snsModeSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = reuseIdentifier;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"评论时自动同步到SNS", nil);
            
            KLSwitch *snsModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [snsModeSwitch setOnTintColor: kGreenColor];
            [snsModeSwitch setOn: [[dict objectForKey:@"comment_auto_sns"] boolValue]
                        animated: NO];
            [snsModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d", isOn] forKey:@"comment_auto_sns"];
                [settingDict setObject:dict forKey:@"functionDict"];

            }];
            
			cell.accessoryView = snsModeSwitch;
		}];
	}];
    
    
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = NSLocalizedString(@"帐号绑定", nil);
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            [view setBackgroundColor:[UIColor blackColor]];
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			cell.textLabel.text = NSLocalizedString(@"手机号", nil);
			[cell.detailTextLabel addSubview:view];
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"DetailTextCell";
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.text = NSLocalizedString(@"新浪微博", nil);
            
			cell.detailTextLabel.text = [[AccountDTO sharedInstance] sina_user_info].screen_name;
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            [view setBackgroundColor:[UIColor blackColor]];
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			cell.textLabel.text = NSLocalizedString(@"QQ帐号", nil);
			[cell.detailTextLabel addSubview:view];
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
	}];
	
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = NSLocalizedString(@"帐号设置", nil);
        //NSMutableDictionary *dict = [[settingDict objectForKey:@"accountSetDict"] objectForKey:@"new_msg_notice"];

		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell";
			cell.textLabel.text = NSLocalizedString(@"新消息通知", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            MessageSetViewController *messageSetViewController = [[MessageSetViewController alloc] initWithMsgDict:settingDict];
            [self.navigationController pushViewController:messageSetViewController animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            [view setBackgroundColor:[UIColor blackColor]];
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"帐号安全", nil);
			cell.detailTextLabel.text = NSLocalizedString(@"不安全", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
			AccountSetViewController *accountSetViewController = [[AccountSetViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:accountSetViewController animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"黑名单", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            BlockListViewController *blockListControl = [[BlockListViewController alloc] init];
            [self.navigationController pushViewController:blockListControl animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 60, 42)];
            [button setTitle:NSLocalizedString(@"搬家", nil) forState:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor yellowColor]];
			cell.textLabel.text = NSLocalizedString(@"农场位置", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = button;
		} ];
        
	}];
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = NSLocalizedString(@"其他", nil);
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"系统公告", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com"];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            [self.navigationController pushViewController:webViewController animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            [view setBackgroundColor:[UIColor blackColor]];
			cell.textLabel.text = NSLocalizedString(@"意见反馈", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
			
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"前往AppStore评论我们", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
#warning apple 前往AppStore评论我们
            NSURL *URL = [NSURL URLWithString:@"www.apple.com"];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            [self.navigationController pushViewController:webViewController animated:YES];
			//TODO
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"用户帮助", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
#warning apple 前往AppStore评论我们
            NSURL *URL = [NSURL URLWithString:@"www.ali.com"];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            [self.navigationController pushViewController:webViewController animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"制作人名单", nil);
		} whenSelected:^(NSIndexPath *indexPath) {
#warning apple 前往AppStore评论我们
            NSURL *URL = [NSURL URLWithString:@"www.google.com"];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            [self.navigationController pushViewController:webViewController animated:YES];
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor colorWithRed:227./255. green:228./255. blue:230./255. alpha:1];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
			cell.textLabel.text = NSLocalizedString(@"                       退出帐号", nil);
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor redColor]];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            [[AppController shareInstance] logout];
		}];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
