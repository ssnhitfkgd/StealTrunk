//
//  LBTableApiViewController.h
//  StealTrunk
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

#import "ModelApiViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface TableApiViewController : ModelApiViewController <UITableViewDelegate, UITableViewDataSource,EGORefreshTableHeaderDelegate, EGORefreshTableFooterViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _headerLoading;
    BOOL _footerLoading;
    BOOL _reloading;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *errorImageView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL enableFooterTemp;
@property (nonatomic, assign) BOOL isTracking;


- (void)createErrorView;
- (void)updateFooter;

- (void)showDataLoading:(CGFloat)offsety;
- (void)activeRefresh;

- (Class)cellClass;
- (void)setSeparatorClear;

- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;
- (void)finishLoadHeaderTableViewDataSource;
- (void)finishLoadFooterTableViewDataSource;

- (void)didFinishLoad:(id)objc;
- (void)didFailWithError:(int)type;
- (void)activityIndicatorAni:(BOOL)animal;

@end

@protocol RefreshTableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@optional

- (void)loadHeader;
- (void)loadFooter;
@end

