//
//  SearchViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-11.
//
//

#import "BaseController.h"

@interface SearchViewController : BaseController<UITextFieldDelegate>

@property (nonatomic, retain) UITextField *searchField;
@property (nonatomic, retain) UIButton *searchBtn;

- (void)searchBtnPress:(id)sender;

@end
