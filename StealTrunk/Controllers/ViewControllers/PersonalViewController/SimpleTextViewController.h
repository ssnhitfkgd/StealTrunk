//
//  SimpleTextViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-10.
//
//

#import "BaseController.h"
#import "HPGrowingTextView.h"

typedef enum {
    TextTypeUserName = 0,
    TextTypeSignText,
    
    
}TextType;

@protocol SimpleTextViewControllerDelegate <NSObject>

- (void)returnText:(NSString *)str Type:(TextType)type;

@end

@interface SimpleTextViewController : BaseController<HPGrowingTextViewDelegate>

@property (nonatomic, strong) HPGrowingTextView *hpTextView;
@property (nonatomic, assign) id<SimpleTextViewControllerDelegate>delegate;
@property (nonatomic, assign) TextType type;

- (id)initWithText:(NSString *)str Type:(TextType)type;

@end
