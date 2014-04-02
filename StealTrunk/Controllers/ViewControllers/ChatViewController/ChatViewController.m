//
//  ChatViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-19.
//
//


#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "FileClient.h"
#import "ImagePickerView.h"


//#define USER_MESSAGE_TEXT  1//文本
//#define USER_MESSAGE_AUDIO 2//音频
//#define USER_MESSAGE_IMAGE 3//图片

@implementation ChatViewController
@synthesize bubbleData = _bubbleData;
@synthesize inputView = _inputView;
@synthesize contentView = _contentView;

static ChatViewController* _sharedInstance = nil;

+ (ChatViewController *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[ChatViewController alloc] init];
    }
    return _sharedInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.height = [[UIScreen mainScreen] bounds].size.height - 44;//navibar 高度
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.inputView = [[RichInputView alloc] init];
    self.inputView.top = self.contentView.height-self.inputView.contentView.height;
    self.inputView.delegate = self;
    
    
    bubbleTable = [[UIBubbleTableView alloc] initWithFrame:self.view.frame];
    bubbleTable.backgroundColor = [UIColor whiteColor];
    bubbleTable.height = self.inputView.top;
    bubbleTable.bubbleDataSource = self;
    
    [self.contentView addSubview:bubbleTable];
    [self.contentView addSubview:self.inputView];
    [self.view addSubview:self.contentView];
    
    [SocketDataCommon sharedInstance];
    [[SocketDataCommon sharedInstance] setDelegate:self];
    
    self.bubbleData = [[NSMutableArray alloc] init];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReceiveData:) name:@"RECEIVE_CHAT_DATA" object:nil];
    
//    self.bubbleData = [[NSMutableArray alloc] initWithObjects:
//                  [NSBubbleData initWithData:@"Marge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminalMarge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminalMarge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminalMarge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminalMarge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminalMarge, there's something that I want to ask you, but I'm afraid, because if you say no, it will destroy me and make me a criminal." sendDate:[NSDate dateWithTimeIntervalSinceNow:-300] sendType:BubbleTypeMine messageType:BubbleMessageTypeText],
//                  [NSBubbleData initWithData:@"bubbleSomeone.png" sendDate:[NSDate dateWithTimeIntervalSinceNow:-280] sendType:BubbleTypeMine messageType:BubbleMessageTypeAudio],
//                  [NSBubbleData initWithData:@"Marge... Oh, damn it." sendDate:[NSDate dateWithTimeIntervalSinceNow:0] sendType:BubbleTypeSomeoneElse messageType:BubbleMessageTypeImage],
//  
//                   [NSBubbleData initWithData:@"bubbleSomeone.png" sendDate:[NSDate dateWithTimeIntervalSinceNow:300] sendType:BubbleTypeSomeoneElse messageType:BubbleMessageTypeAudio],
//               
//                  [NSBubbleData initWithData:@"Ohn I wrote jfdasjkfhkjsahajdsfadksjfhadksjfhdkasjfhdksjafhdjkalsfhdjakslfhdaksjlfhdaskfhdkasfhdaksfhdkjasfhdaksjfhkdajfhdkaslfhdaskjfhdask down what I wanted to say on a card.." sendDate:[NSDate dateWithTimeIntervalSinceNow:395]  sendType:BubbleTypeMine messageType:BubbleMessageTypeText],
//                  [NSBubbleData initWithData:@"The stupid thing must have fallen out of my pocket." sendDate:[NSDate dateWithTimeIntervalSinceNow:400]  sendType:BubbleTypeMine messageType:BubbleMessageTypeText],
//                  
//                  nil];

    
    //点击背景，收回键盘
    [bubbleTable addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bubbleTableTap)]];


    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
#warning 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (id)initWithChatToUserID:(NSString*)toUserID
{
    self = [super init];
    if(self)
    {
        chatToUserID = toUserID;
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (NSString*)getChatToUserID
{
    return chatToUserID;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didFinishLoad:(id)objc
{
    if(objc && [objc isKindOfClass:[NSDictionary class]])
    {
        NSArray *array = [objc objectForKey:@"list"];
        for(NSDictionary *dict in array)
        {
            [self reloadBubbleTable:dict];
        }
        
        [bubbleTable reloadData];
        [self scrollTableToBottom:YES];

    }
}

- (void)reloadBubbleTable:(NSDictionary*)messageDict
{
    NSBubbleMessageType bubbleMessageType = [[messageDict objectForKey:@"type"] integerValue];
    NSBubbleSendType bubbleSendType = [[messageDict objectForKey:@"from"] integerValue];
    NSString *content = nil;
    if(bubbleMessageType == BubbleMessageTypeText)
    {
        content = [messageDict objectForKey:@"text"];
    }
    else if(bubbleMessageType == BubbleMessageTypeAudio)
    {
        content = [messageDict objectForKey:@"audio"];
    }
    else if(bubbleMessageType == BubbleMessageTypeImage)
    {
        content = [messageDict objectForKey:@"image"];
    }
    NSString *dateString = [messageDict objectForKey:@"create_time"];
    NSDate *date =  [DateUtil convertTime:dateString];
    long long int dateSinceNow = [[DateUtil convertNumberFromTime:date] longLongValue];
    [_bubbleData addObject:[NSBubbleData initWithData:content sendDate:[NSDate dateWithTimeIntervalSinceNow:dateSinceNow] sendType:bubbleSendType messageType:bubbleMessageType]];
}

- (void)bubbleTableTap
{
    [self.inputView hideKeyboard];
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    if(_bubbleData == nil)
        return 0;
    
    return [_bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleData objectAtIndex:row];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_GROUP_MESSAGE;
}


#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //[bubbleTable addGestureRecognizer:bubbleTavlePanGestureRecognizer];

    // Reduce the size of the text view so that it's not obscured by the keyboard.
    // Animate the resize so that it's in sync with the appearance of the keyboard.

    //faceButton.selected = NO;
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                            self.contentView.top = -keyboardRect.size.height;
                     } completion:^(BOOL finished) {
                         
                     }];       
}


- (void)keyboardWillHide:(NSNotification *)notification {
    //[bubbleTable removeGestureRecognizer:bubbleTavlePanGestureRecognizer];
    NSDictionary* userInfo = [notification userInfo];
    
    // Restore the size of the text view (fill self's view).
    // Animate the resize so that it's in sync with the disappearance of the keyboard.

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //隐藏键盘、显示表情键盘
    if (!self.inputView.text_emojiBtn.selected) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.contentView.top = 0;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

#pragma mark - Chat Delegate
- (void)sendText:(NSString *)text
{
    //
    NSString *token = [[AccountDTO sharedInstance] session_info].token;
    [[FileClient sharedInstance] createUserMessageWithUserToken:token toUserID:chatToUserID message:text file:@"" type:BubbleMessageTypeText cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(didSendDataSuccessed:) selectorError:@selector(didSendDataFailed:) progressSelector:nil];
    
    NSDate *date = [NSDate date];
    long long int dateSinceNow = [[DateUtil convertNumberFromTime:date] longLongValue];
    
    [_bubbleData addObject:[NSBubbleData initWithData:text sendDate:[NSDate dateWithTimeIntervalSinceNow:dateSinceNow] sendType:BubbleTypeMine messageType:BubbleMessageTypeText]];
    [bubbleTable reloadData];
}

- (void)sendVoice:(NSString *)voiceUrl
{
    NSString *token = [[AccountDTO sharedInstance] session_info].token;
    
     [[FileClient sharedInstance] createUserMessageWithUserToken:token toUserID:chatToUserID message:@"" file:voiceUrl type:BubbleMessageTypeAudio cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(didSendDataSuccessed:) selectorError:@selector(didSendDataFailed:) progressSelector:@selector(didSendDataProgress:)];
    
     NSDate *date = [NSDate date];
     long long int dateSinceNow = [[DateUtil convertNumberFromTime:date] longLongValue];
     
     [_bubbleData addObject:[NSBubbleData initWithData:voiceUrl sendDate:[NSDate dateWithTimeIntervalSinceNow:dateSinceNow] sendType:BubbleTypeMine messageType:BubbleMessageTypeAudio]];
     [bubbleTable reloadData];
}

- (void)viewHeightChange:(CGFloat)diff
{
    bubbleTable.height += diff;//height change
}

- (void)showEmojiKeybord:(BOOL)show
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                        
                         self.contentView.top = show?-self.inputView.emojiKeyboard.height:0;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}


#pragma mark - Delegate for data request
- (void)socketReceiveData:(NSDictionary*)data
{
    //接受聊天返回  dict
    if(data && [data isKindOfClass:[NSDictionary class]])
    {
        id messageDict = [data objectForKey:@"message"];
        [self reloadBubbleTable:messageDict];
        [bubbleTable reloadData];

        [self scrollTableToBottom:YES];
    }
}

- (void)scrollTableToBottom:(BOOL)animated {
     NSInteger sections = [bubbleTable numberOfSections];
     if (sections < 1) return;
     NSInteger rows = [bubbleTable numberOfRowsInSection:sections - 1];
     if (rows < 1) return;
     
     NSIndexPath *ip = [NSIndexPath indexPathForRow:rows - 1 inSection:sections - 1];
     
     [bubbleTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)didSendDataSuccessed:(NSData*)data
{
    id obj = [self transitionData:data];
    
    if(obj && [obj isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"发送成功");
        
    }
    else
    {
        [self didSendDataFailed:data];
    }
//    {
//        "code": 0,
//        "env": "dev",
//        "data": {
//            "id": "10002-22",
//            "from": 2,
//            "type": 1,
//            "text": "测试",
//            "audio": null,
//            "image": null,
//            "create_time": "2013-07-30 23:31:45"
//        }
//    }
    
}

- (void)didSendDataProgress:(NSNumber *)progress
{
    //进度条
}

- (void)didSendDataFailed:(NSData*)data
{
    NSLog(@"发送失败");
}
@end
