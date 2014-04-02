//
//  MessageSetViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-8-5.
//
//

#import "MessageSetViewController.h"
#import "KLSwitch.h"

#define kGreenColor [UIColor colorWithRed:144/255.0 green: 202/255.0 blue: 119/255.0 alpha: 1.0]
#define kBlueColor [UIColor colorWithRed:129/255.0 green: 198/255.0 blue: 221/255.0 alpha: 1.0]
#define kYellowColor [UIColor colorWithRed:233/255.0 green: 182/255.0 blue: 77/255.0 alpha: 1.0]
#define kOrangeColor [UIColor colorWithRed:288/255.0 green: 135/255.0 blue: 67/255.0 alpha: 1.0]
#define kRedColor [UIColor colorWithRed:158/255.0 green: 59/255.0 blue: 51/255.0 alpha: 1.0]


@interface MessageSetViewController ()

@end

@implementation MessageSetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMsgDict:(NSDictionary*)dict
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        mutableMsgDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = NSLocalizedString(@"消息设置", nil);
    
    self.tableView.backgroundView = [[UIView alloc] init];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:227./255. green:228./255. blue:230./255. alpha:1]];
    
    NSMutableDictionary *dict = [[mutableMsgDict objectForKey:@"accountSetDict"] objectForKey:@"new_msg_notice"];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.footer = NSLocalizedString(@"需要前往iPhone得“设置”>“通知”，找到应用\r\n程序“xx”进行更改", nil);
        NSString *reuseIdentifier = @"new_msg_setting";
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"接受新消息通知", nil);
            
			cell.detailTextLabel.text = NSLocalizedString(@"已经开启", nil);
		}];
    }];
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        NSString *reuseIdentifier = @"setting";
        section.footer = NSLocalizedString(@"夜间收到消息手机不会震动、不会发出声音。\r\n夜间免打扰时段为：22:00！8:00", nil);

        //@"1", @"night_alone",@"1", @"new_msg",@"1", @"friend_invite",@"1", @"chat"

		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = reuseIdentifier;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = NSLocalizedString(@"夜间勿扰", nil);
            
            KLSwitch *musiceModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [musiceModeSwitch setOnTintColor: kGreenColor];
            [musiceModeSwitch setOn: [[dict objectForKey:@"night_alone"] boolValue]
                           animated: NO];
            [musiceModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"night_alone"];
                [[mutableMsgDict objectForKey:@"accountSetDict"] setObject:dict forKey:@"night_alone"];
            }];
            
			cell.accessoryView = musiceModeSwitch;
		}];
    }];
     
        
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        NSString *reuseIdentifier = @"setting";
        section.footer = NSLocalizedString(@"关闭通知不会收到消息", nil);
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"新消息", nil);
            
            KLSwitch *musiceModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [musiceModeSwitch setOnTintColor: kGreenColor];
            [musiceModeSwitch setOn: [[dict objectForKey:@"new_msg"] boolValue]
                           animated: NO];
            [musiceModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"new_msg"];
                [[mutableMsgDict objectForKey:@"accountSetDict"] setObject:dict forKey:@"new_msg"];
            }];
            
            cell.accessoryView = musiceModeSwitch;
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"好友申请", nil);
            
            KLSwitch *musiceModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [musiceModeSwitch setOnTintColor: kGreenColor];
            [musiceModeSwitch setOn: [[dict objectForKey:@"friend_invite"] boolValue]
                           animated: NO];
            [musiceModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"friend_invite"];
                [[mutableMsgDict objectForKey:@"accountSetDict"] setObject:dict forKey:@"friend_invite"];
            }];
            
            cell.accessoryView = musiceModeSwitch;
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            
            staticContentCell.reuseIdentifier = reuseIdentifier;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"新私信", nil);
            
            KLSwitch *musiceModeSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            [musiceModeSwitch setOnTintColor: kGreenColor];
            [musiceModeSwitch setOn: [[dict objectForKey:@"chat"] boolValue]
                           animated: NO];
            [musiceModeSwitch setDidChangeHandler:^(BOOL isOn) {
                [dict setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"chat"];
                [[mutableMsgDict objectForKey:@"accountSetDict"] setObject:dict forKey:@"chat"];
            }];
            
            cell.accessoryView = musiceModeSwitch;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
