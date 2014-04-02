//
//  ChatListViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "ChatListViewController.h"
#import "ChatListCell.h"
#import "ChatDto.h"
#import "ChatViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"私信", nil);
        
        self.enableHeader = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReceiveData:) name:@"RECEIVE_CHAT_DATA" object:nil];
    

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SocketDataCommon sharedInstance] setDelegate:self];
}
- (void)socketReceiveData:(NSDictionary *)data
{
    //接受聊天返回  dict
    if(data && [data isKindOfClass:[NSDictionary class]])
    {
        id userObj = [data objectForKey:@"user"];
        if(userObj && [userObj isKindOfClass:[NSDictionary class]])
        {
            id userID = [userObj objectForKey:@"id"];
            if(userID && [userID isKindOfClass:[NSString class]])
            {
                id userMsgCount = [[NSUserDefaults standardUserDefaults] objectForKey:userID];
                //if(userMsgCount)
                {
                    //保存数据到本地 做列表消息数提示用
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",userMsgCount?([userMsgCount intValue]+1):1] forKey:userID];
                }
            }
        }
        [self.tableView reloadData];
        //[messageDict objectForKey:@"userid"]
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [ChatListCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_GROUP_CHAT;
}

- (void)didFinishLoad:(id)obj
{
    NSDictionary *rootDic = (NSDictionary *)obj;
    NSArray *eggs = [rootDic objectForKey:@"list"];
    [super didFinishLoad:eggs];
}

#pragma tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatListCell *chatListCell = (ChatListCell*)[tableView cellForRowAtIndexPath:indexPath];
    id userID = [chatListCell getChatToUserID];
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithChatToUserID:userID];

    chatViewController.title = [chatListCell getChatToUserName];
    [self.navigationController pushViewController:chatViewController animated:YES];
    #warning 设置消息数字 设置后清空本地纪录
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userID];
    }
    //((ChatDto*)chatListCell.cellView.chatInfo).chatMessage.chat_id
    
}

@end
