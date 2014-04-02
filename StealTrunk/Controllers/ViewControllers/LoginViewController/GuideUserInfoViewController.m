//
//  GuideUserInfoViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "GuideUserInfoViewController.h"
#import "GuideShowViewController.h"
#import "GuideViewController.h"

@interface GuideUserInfoViewController ()

@end

@implementation GuideUserInfoViewController
@synthesize userAvatar = _userAvatar;
@synthesize userName = _userName;
@synthesize birthdayBtn = _birthdayBtn;
@synthesize birthdayPickView = _birthdayPickView;
@synthesize datePicker = _datePicker;
@synthesize genderSeg = _genderSeg;

@synthesize userInfo = _userInfo;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        self.userAvatar.centerX = self.view.centerX;
        self.userAvatar.top = 20;
        [self.userAvatar.layer setMasksToBounds:YES];
        [self.userAvatar.layer setCornerRadius:self.userAvatar.height/2];
        self.userAvatar.layer.borderWidth = 2.;
        [self.userAvatar.layer setBorderColor:[UIColor whiteColor].CGColor];
        self.userAvatar.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:self.userAvatar];

        UIImageView *changeAvatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"change_avatar"]];
        [changeAvatar sizeToFit];
        [changeAvatar setTop:self.userAvatar.top + self.userAvatar.height - 18];
        [changeAvatar setCenterX:self.view.centerX];
        [self.view addSubview:changeAvatar];
        [changeAvatar setBackgroundColor:[UIColor clearColor]];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 30)];
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [nameLabel setTextColor:[UIColor colorWithRed:12./255. green:166./255. blue:166./255. alpha:1.]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTop:self.userAvatar.bottom + 20];
        [nameLabel setText:@"名字"];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:nameLabel];
        
        self.userName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 240, 44)];
        self.userName.top = nameLabel.bottom;
        self.userName.centerX = self.view.centerX;
        self.userName.textAlignment = UITextAlignmentCenter;
        self.userName.textColor = [UIColor whiteColor];
        self.userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.userName.backgroundColor = [UIColor purpleColor];
        self.userName.delegate = self;
        self.userName.returnKeyType = UIReturnKeyNext;
        
        UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 30)];
        [birthdayLabel setFont:[UIFont systemFontOfSize:12]];
        [birthdayLabel setTextColor:[UIColor colorWithRed:12./255. green:166./255. blue:166./255. alpha:1.]];
        [birthdayLabel setTextAlignment:NSTextAlignmentCenter];
        [birthdayLabel setTop:self.userName.bottom + 10];
        [birthdayLabel setText:@"性别"];
        [birthdayLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:birthdayLabel];
        
        self.birthdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.birthdayBtn.frame = self.userName.frame;
        self.birthdayBtn.top = birthdayLabel.bottom;
        self.birthdayBtn.centerX = self.view.centerX;
        [self.birthdayBtn setTitle:NSLocalizedString(@"年龄 & 星座", nil) forState:UIControlStateNormal];
        [self.birthdayBtn addTarget:self action:@selector(birthdayBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        self.birthdayBtn.backgroundColor = [UIColor purpleColor];
        
        self.birthdayPickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        self.birthdayPickView.top = [[UIScreen mainScreen] bounds].size.height;
        
        UIToolbar *pickerBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
        pickerBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(birthdayCancelBtnPress:)];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(birthdayBarDoneBtnPress:)];
        [pickerBar setItems:[NSArray arrayWithObjects:cancleItem,spaceItem,doneItem, nil]];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.top = 44;
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
        NSDateComponents *nowComps  = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *tempComps = [calendar components:unitFlags fromDate:[NSDate date]];;
        
        [tempComps setYear:[nowComps year]-12];
        NSDate *maxDate = [calendar dateFromComponents:tempComps];
        
        [tempComps setYear:[nowComps year]-100];
        NSDate *minDate = [calendar dateFromComponents:tempComps];
        
        [tempComps setYear:[nowComps year]-26];
        NSDate *defaultDate = [calendar dateFromComponents:tempComps];
        
        self.datePicker.minimumDate = minDate;
        self.datePicker.maximumDate = maxDate;
        self.datePicker.date = defaultDate;
        
        [self.birthdayPickView addSubview:pickerBar];
        [self.birthdayPickView addSubview:self.datePicker];

        UILabel *gendersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 30)];
        [gendersLabel setFont:[UIFont systemFontOfSize:12]];
        [gendersLabel setTextColor:[UIColor colorWithRed:12./255. green:166./255. blue:166./255. alpha:1.]];
        [gendersLabel setTextAlignment:NSTextAlignmentCenter];
        [gendersLabel setTop:self.birthdayBtn.bottom + 10];
        [gendersLabel setText:@"性别"];
        [gendersLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:gendersLabel];
    
        UIButton *sexBoyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sexBoyButton setImage: [UIImage imageNamed:@"sex_boy"] forState:UIControlStateNormal];
        [sexBoyButton setImage:[UIImage imageNamed:@"sex_boy_selected"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
        
        // Button 2
        UIButton *sexGirlButton = [[UIButton alloc] init];
        [sexGirlButton setImage:[UIImage imageNamed:@"sex_girl"] forState:UIControlStateNormal];
        [sexGirlButton setImage:[UIImage imageNamed:@"sex_girl_selected"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
        
        self.genderSeg = [[AKSegmentedControl alloc] initWithFrame:self.userName.frame];
        self.genderSeg.top = gendersLabel.bottom;
        [self.genderSeg setDelegate:self];
        [self.genderSeg setBackgroundColor:[UIColor whiteColor]];
        [self.genderSeg setButtonsArray:@[sexBoyButton, sexGirlButton]];

        [self segmentedViewController:self.genderSeg touchedAtIndex:0];
        self.nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextStep.frame = CGRectMake(10, 0, screenSize().width - 20, 44);
        self.nextStep.bottom = screenSize().height - 20;
        self.nextStep.backgroundColor = [UIColor colorWithRed:120./255. green:196./255. blue:44./255. alpha:1.];
        [self.nextStep setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [self.nextStep addTarget:self action:@selector(nextStepBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.userName];
        [self.view addSubview:self.birthdayBtn];
        [self.view addSubview:self.genderSeg];
        [self.view addSubview:self.nextStep];
        [self.view addSubview:self.birthdayPickView];
        
        //初设
        //界面值
        Sina_user_info *sina_info = [[AccountDTO sharedInstance] sina_user_info];
        
        [self.userAvatar setImageWithURL:[NSURL URLWithString:sina_info.profile_image_url] placeholderImage:nil];
        [self.userName setText:sina_info.screen_name];
        
        if (sina_info.gender > 0) {
            [self.genderSeg setSelectedIndex:sina_info.gender-1];
        }
        
        //userInfo初始为错误值
        self.userInfo = [[Monstea_user_info alloc] init];
        self.userInfo.gender = -1;
        self.userInfo.longitude = 300;
        self.userInfo.latitude = 300;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    for(UIButton *button in segmentedControl.buttonsArray)
    {
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    [segmentedControl.buttonsArray[index] setBackgroundColor:[UIColor colorWithRed:243./255. green:98./255. blue:90./255. alpha:1.0]];
    if(0 == index)
    {
        [segmentedControl.buttonsArray[0] setImage:[UIImage imageNamed:@"sex_boy_selected"] forState:UIControlStateNormal];
        [segmentedControl.buttonsArray[1] setImage:[UIImage imageNamed:@"sex_girl"] forState:UIControlStateNormal];
    }
    else
    {
        [segmentedControl.buttonsArray[0] setImage:[UIImage imageNamed:@"sex_boy"] forState:UIControlStateNormal];
        [segmentedControl.buttonsArray[1] setImage:[UIImage imageNamed:@"sex_girl_selected"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - Actions
- (void)birthdayBtnPress:(id)sender
{
    //show datePicker
    [UIView animateWithDuration:0.15 animations:^{
        self.birthdayPickView.bottom = [[UIScreen mainScreen] bounds].size.height;
    }];
}

- (void)birthdayCancelBtnPress:(id)sender
{
    [UIView animateWithDuration:0.15 animations:^{
        self.birthdayPickView.top = [[UIScreen mainScreen] bounds].size.height;
    }];
}

- (void)birthdayBarDoneBtnPress:(id)sender
{
    [UIView animateWithDuration:0.15 animations:^{
        self.birthdayPickView.top = [[UIScreen mainScreen] bounds].size.height;
    }];
    
    self.userInfo.birthday = [NSDate getFormatTime:self.datePicker.date format:@"yyyy-MM-dd"];
}

- (void)nextStepBtnPress:(id)sender
{
    //保存用户信息到userInfo
    self.userInfo.user_name = self.userName.text;
    self.userInfo.gender = self.genderSeg.selectedIndex + 1;
    
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"提示"
                                                        message:@"性别一旦设定，将无法更改"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alert.style = GRAlertStyleWarning;
    alert.delegate = self;
    [alert setImage:@"alert.png"];
    [alert show];

}

#pragma alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 1)
    {
        AccountDTO *accountDto = [AccountDTO sharedInstance];
//        [accountDto.dtoResult setObject:textFieldName.text forKey:@"name"];
//        [accountDto.dtoResult setObject:textFieldAge.text forKey:@"age"];
//        [accountDto.dtoResult setObject:textFieldBlood.text forKey:@"blood"];
//        [accountDto.dtoResult setObject:imageView.image forKey:@"avatar"];
//        [accountDto.dtoResult setObject:control.selectedSegmentIndex == 0?@"男":@"女" forKey:@"avatar"];
//        
        [NSUserDefaults standardUserDefaults];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"guidePageNumber"];
        
        
        //push to next step
        //GuideShowViewController *showControl = [GuideShowViewController creatWithUserInfo:self.userInfo];
        GuideViewController *showControl = [[GuideViewController alloc] initPageIndex:1];
        [self.navigationController pushViewController:showControl animated:YES];
        
    }
}

- (void)closeAlert:(NSTimer*)timer {
    [(UIAlertView*) timer.userInfo  dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userName resignFirstResponder];
    
    return YES;
}

@end
