//
//  SearchViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-11.
//
//

#import "SearchViewController.h"
#import "FileClient.h"
#import "AccountDTO.h"
#import "GRAlertView.h"
#import "NameCardViewController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchField = _searchField;
@synthesize searchBtn = _searchBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"搜索好友", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 300, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    
    UIImageView *searchBack = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"textField-search"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    searchBack.frame = CGRectMake(0, 0, 300, 44);
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    self.searchField.backgroundColor = [UIColor clearColor];
    self.searchField.placeholder = NSLocalizedString(@"输入号码", nil);
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchField.keyboardType = UIKeyboardTypeNumberPad;
    self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchField.textAlignment = UITextAlignmentCenter;
    self.searchField.font = [UIFont systemFontOfSize:14.0f];
    self.searchField.delegate = self;
    
    [searchView addSubview:searchBack];
    [searchView addSubview:self.searchField];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(0, 0, 320, 44);
    self.searchBtn.top = searchView.bottom + 40;
    self.searchBtn.backgroundColor = BenGreen;
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchBtn setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.searchBtn addTarget:self action:@selector(searchBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchView];
    [self.view addSubview:self.searchBtn];
    
    [self.searchField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)searchBtnPress:(id)sender
{
    NSString *searchID = self.searchField.text;
    
    if (searchID && searchID.length>0) {
        //判断是否是纯数字
        FileClient *client = [FileClient sharedInstance];
        
        NSString *token = [[AccountDTO sharedInstance] session_info].token;
        
        [client getUserProfileWithUserToken:token
                                     userID:searchID
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                   delegate:self
                                   selector:@selector(requestDidFinishLoad:)
                              selectorError:@selector(requestError:)];
    }
}

#pragma mark - Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)requestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue])
        {
            NSDictionary *dict = [[json_string JSONValue]  objectForKey:@"data"];
            if(dict)
            {
                //解析
                Monstea_user_info *userInfo = [[Monstea_user_info alloc] init];
                [userInfo parseWithDic:dict];

                
                [self.searchField resignFirstResponder];
                
                [self presentPopupViewController:[NameCardViewController creatWithUserID:userInfo.user_id Popup:YES] animationType:MJPopupViewAnimationSlideTopBottom dismissed:^{
                    [self.searchField becomeFirstResponder];
                }];
            }
            else
            {
                [self requestError:nil];
            }
        }
        else
        {
            NSDictionary *dataDic = [NSDictionary dictionaryWithObject:[[json_string JSONValue]  objectForKey:@"data"] forKey:@"reason"];
            
            NSError *error = [NSError errorWithDomain:@"monstea" code:1 userInfo:dataDic];
            [self requestError:error];
        }
    }
    
    else {
        [self requestError:nil];
    }
}

- (void)requestError:(NSError *)error {
    NSString *errorReason = [error.userInfo objectForKey:@"reason"];
    
    GRAlertView *showErrorInfo = [[GRAlertView alloc] initWithTitle:@"ERROR"
                                                           message:errorReason
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
    showErrorInfo.style = GRAlertStyleWarning;
    [showErrorInfo setImage:@"alert.png"];
    [showErrorInfo show];
}

@end
