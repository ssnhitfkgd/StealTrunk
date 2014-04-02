//
//  GuideViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-6-30.
//
//
#import "URBSegmentedControl.h"
#import "AccountDTO.h"
#import "GuideViewController.h"
#import "GetNearbyPlacesViewController.h"
#import "GRAlertView.h"
#import "FileClient.h"
#import "AccountDTO.h"
#import "AppDelegate.h"

#define middSpace  10

@interface GuideViewController ()
{
    int nPageIndex;
    id delegate;
    URBSegmentedControl *control;
    UITextField *textFieldAge;
    UITextField *textFieldBlood;
    UITextField *textFieldName;
    UIImageView *imageView;
    UIButton *locationButton;
}


- (id)initPageIndex:(int)pageIndex;
- (void)setDelegate:(id)_delegate;
- (void)createSubView;
- (void)nextBtnTape:(UIButton*)sender;
@end

@implementation GuideViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
}

- (void)setDelegate:(id)_delegate
{
    delegate = _delegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initPageIndex:(int)pageIndex
{
    self = [super init];
    if (self) {
        nPageIndex = pageIndex;
        [self createSubView];
        [self.navigationItem setHidesBackButton:YES];

        // Initialization code
    }
    return self;
}

- (void)createSubView
{
    self.view.userInteractionEnabled = YES;
    if(nPageIndex == 1)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 165, 165)];
        imageView.centerX = self.view.centerX;
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:165/2];
        imageView.layer.borderWidth = 5.;
        [imageView.layer setBorderColor:[UIColor yellowColor].CGColor];
        [self.view addSubview:imageView];
        
        
        UIScrollView *scroller  =[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, imageView.bottom + 10 ,self.view.width, 170)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0., 0., screenSize().width, scroller.height - 20)];
        for(int i = 0; i < 2;i++)
        {
            for (int j = 0; j < 4; j++)
            {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + j*10 + j*68, i*68 + 10*i, 68, 68)];
                [imageView setBackgroundColor:[UIColor blackColor]];
                [view addSubview:imgView];
            }
        }

        
        [scroller addSubview:view];
        scroller.pagingEnabled = YES;
        scroller.showsVerticalScrollIndicator = NO;
        scroller.showsHorizontalScrollIndicator = NO;
        scroller.delegate = self;
        scroller.contentSize = CGSizeMake(self.view.width * 2, 170);
        [self.view addSubview:scroller];
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setTag:1];
        pageControl.frame = CGRectMake(0, scroller.height - 20, self.view.width, 20);
        pageControl.numberOfPages = 2;
        pageControl.currentPage = 0;
        [scroller addSubview:pageControl];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(scroller.left, 0, scroller.width, 44.)];
        [button addTarget:self action:@selector(nextBtnTape:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        button.bottom = screenSize().height - 20;
        button.backgroundColor = [UIColor colorWithRed:120./255. green:196./255. blue:44./255. alpha:1.];
        button.tag = nPageIndex;
        [self.view addSubview:button];
    }
    else if(nPageIndex == 2)
    {
        
        [[MapViewLocation shareInstance] startWithDelegate:(id)self];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        [label setNumberOfLines:2];
        label.centerX = self.view.centerX;
        [label setText:@"设定农场位置侯，将能在游戏内获取到当地的天气信息，也能帮助您找到附近的好友"];
        [self.view addSubview:label];
        
        
        locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationButton setFrame:CGRectMake(label.left, label.bottom + 20, label.width, 44.)];
        [locationButton addTarget:self action:@selector(getLocationBtnTape:) forControlEvents:UIControlEventTouchUpInside];
        [locationButton setTitle:@"获取农场位置" forState:UIControlStateNormal];
        [locationButton setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:locationButton];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(locationButton.left, locationButton.bottom + 100, locationButton.width, 44.)];
        [button addTarget:self action:@selector(nextBtnTape:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        button.tag = nPageIndex;
        [self.view addSubview:button];
        
    }
    else if(nPageIndex == 3)
    {
        
        [[MapViewLocation shareInstance] startWithDelegate:(id)self];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [textLabel setNumberOfLines:2];
        textLabel.centerX = self.view.centerX;
        [textLabel setText:@"设定农场位置侯，将能在游戏内获取到当地的天气信息，也能帮助您找到附近的好友"];
        [self.view addSubview:textLabel];
        
        UIImageView *imageViewLocation = [[UIImageView alloc] initWithFrame:CGRectMake(0, textLabel.bottom + 30, 100, 100)];
        imageViewLocation.centerX = self.view.centerX;
        [imageViewLocation setBackgroundColor:[UIColor yellowColor]];
        [self.view addSubview:imageViewLocation];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewLocation.bottom + 30, 280, 80)];
        [detailLabel setFont:[UIFont systemFontOfSize:14]];
        [detailLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [detailLabel setNumberOfLines:2];
        detailLabel.centerX = self.view.centerX;
        [detailLabel setText:@"              未获取到您得地理位置\r\n请前往iphone系统设置》隐私》定位服务\r\n找到我们开启服务"];
        [self.view addSubview:detailLabel];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(detailLabel.left, detailLabel.bottom + 40, detailLabel.width, 44.)];
        [button addTarget:self action:@selector(nextBtnTape:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"暂不设置，进入游戏" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        button.tag = nPageIndex;
        [self.view addSubview:button];
        
    }
}

- (void)newPageViewController
{
    GuideViewController *controller = [[GuideViewController alloc] initPageIndex:++nPageIndex];
    //[self pushViewController:controller animated:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)handleSelection:(id)sender {
	NSLog(@"URBSegmentedControl: value changed");
}

- (void)getLocationBtnTape:(UIButton*)sender
{
    GetNearbyPlacesViewController *locationPlaces = [[GetNearbyPlacesViewController alloc] init];
    [self.navigationController pushViewController:locationPlaces animated:YES];
}

- (void)nextBtnTape:(UIButton*)sender
{

    if(sender.tag == 1)
    {
        AccountDTO *accountDto = [AccountDTO sharedInstance];
        [accountDto.dtoResult setObject:@"1" forKey:@"sign"];
        [self newPageViewController];
    }
    else if(sender.tag == 1)
    {
        AccountDTO *accountDto = [AccountDTO sharedInstance];
        [accountDto.dtoResult setObject:@"1" forKey:@"show"];
//        [accountDto parse_user_info:accountDto.dtoResult];

#warning updateMyProfile is error
//        [[FileClient sharedInstance] updateMyProfileWithUserToken:accountDto cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    }
    else
    {
        [[AppController shareInstance] setMainViewController];
    }

}

- (void)requestDidFinishLoad:(NSData*)data
{
    
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject != nil)//&& 0 == [responseObject integerValue])
        {
            id obj = [[json_string JSONValue]  objectForKey:@"data"];

            if(ERROR_CODE_SUCCESS == [responseObject integerValue])
            {
                [[AppController shareInstance] setMainViewController];
            }
            else
            {
                [self requestError:obj];
            }
        }
        else
        {
            [self requestError:nil];
        }
    }
    
    else {
        [self requestError:nil];
    }
    
}

- (void)requestError:(NSError *)data {
    NSLog(@"%@", data);
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败，请重新登录"];
    NSLog(@"ERROR");
}

#pragma RequestSenderDelegate
- (void)didCoordinateSuccess:(CLLocationCoordinate2D)coordinate
{
    AccountDTO *accountDto = [AccountDTO sharedInstance];
    [accountDto.dtoResult setObject:[NSString stringWithFormat:@"%lf",coordinate.longitude] forKey:@"longitude"];
    [accountDto.dtoResult setObject:[NSString stringWithFormat:@"%lf",coordinate.latitude] forKey:@"latitude"];
}

- (void)didCoordinateFailed:(NSError*)error
{
    [locationButton setUserInteractionEnabled:NO];
    AccountDTO *accountDto = [AccountDTO sharedInstance];
    [accountDto.dtoResult setObject:@"0" forKey:@"longitude"];
    [accountDto.dtoResult setObject:@"0" forKey:@"latitude"];
    
    [self newPageViewController];
}

//#pragma alertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if(buttonIndex == 1)
//    {
//        AccountDTO *accountDto = [AccountDTO sharedInstance];
//        [accountDto.dtoResult setObject:textFieldName.text forKey:@"name"];
//        [accountDto.dtoResult setObject:textFieldAge.text forKey:@"age"];
//        [accountDto.dtoResult setObject:textFieldBlood.text forKey:@"blood"];
//        [accountDto.dtoResult setObject:imageView.image forKey:@"avatar"];
//        [accountDto.dtoResult setObject:control.selectedSegmentIndex == 0?@"男":@"女" forKey:@"avatar"];
//        
//        [NSUserDefaults standardUserDefaults];
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"guidePageNumber"];
//        
//        [self newPageViewController];
//        
//    }
//}
//
//- (void)closeAlert:(NSTimer*)timer {
//    [(UIAlertView*) timer.userInfo  dismissWithClickedButtonIndex:0 animated:YES];
//}

#pragma scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPageControl *obj = (UIPageControl*)[scrollView viewWithTag:1];
    int index = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width;
    if(obj)
    {
        obj.currentPage = index;
    }
}



@end
