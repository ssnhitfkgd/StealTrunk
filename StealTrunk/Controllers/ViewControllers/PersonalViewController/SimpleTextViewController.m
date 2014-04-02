//
//  SimpleTextViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-10.
//
//

#import "SimpleTextViewController.h"

@interface SimpleTextViewController ()

@end

@implementation SimpleTextViewController

@synthesize hpTextView = _hpTextView;
@synthesize delegate = _delegate;
@synthesize type = _type;

- (id)initWithText:(NSString *)str Type:(TextType)type
{
    self = [super init];
    
    if (self) {
        
        self.view.backgroundColor = [UIColor redColor];
        
        self.hpTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 150)];
        self.hpTextView.font = [UIFont systemFontOfSize:16.0f];
        self.hpTextView.delegate = self;
        self.hpTextView.backgroundColor = [UIColor lightGrayColor];
        [self.hpTextView becomeFirstResponder];
        [self.view addSubview:self.hpTextView];
        
        if (str) {
            self.hpTextView.text = str;
        }
        
        self.type = type;
    }
    
    return self;
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    //传回值
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnText: Type:)]) {
        [self.delegate returnText:self.hpTextView.text Type:self.type];
    }
}

#pragma mark - Delegates
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL tf = YES;
    
    NSString *resultText = [growingTextView.text stringByAppendingString:text];
    
    switch (self.type) {
        case TextTypeUserName:
        {
            if (resultText.length > 20) {
                tf = NO;
            }
        }
            break;
        case TextTypeSignText:
        {
            if (resultText.length > 60) {
                tf = NO;
            }
        }
            break;
        default:
            break;
    }
    
    return tf;
}

@end
