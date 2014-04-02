    //
//  LBTableApiViewController.m
//  StealTrunk
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

#import "TableApiViewController.h"
#import "TableCellDelegate.h"
#import "UserStatusCell.h"
#import "FileClient.h"
@implementation TableApiViewController
@synthesize tableView = _tableView;
@synthesize enableFooter = _enableFooter;
@synthesize enableHeader = _enableHeader;
@synthesize enableFooterTemp = _enableFooterTemp;
@synthesize errorImageView = _errorImageView;
@synthesize errorLabel = _errorLabel;
@synthesize errorView = _errorView;
@synthesize activityIndicator = _activityIndicator;
@synthesize isTracking;

- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return NULL;
}

- (void)viewDidUnload
{
    _tableView = nil;
    _errorImageView = nil;
    _errorLabel = nil;
    _errorView = nil;
    _activityIndicator = nil;
    [super viewDidUnload];
}

- (void)didFailWithError:(int)type
{
    
    if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
    
    if(_footerLoading)
    {
        [self finishLoadFooterTableViewDataSource];
    }
    
    if(_headerLoading)
    {
        [self finishLoadHeaderTableViewDataSource];
    }
    
    NSString *strFailText = @"网络异常，请稍后重试";
    if([[FileClient sharedInstance] getNetworkingType] == 0)
    {
        strFailText = @"当前没有连接到网络";
    }
    else if(-1001 == type)
    {
        strFailText = @"连接超时，请稍后重试";
    }
    
    [_errorView removeFromSuperview];
    
    if(self.model && [(NSArray*)self.model count] > 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:strFailText];
        return;
    }

    CGFloat fErrorImageViewTop = (self.tableView.height - self.tableView.tableHeaderView.height)/2 + self.tableView.tableHeaderView.height;

    [_errorLabel setText:strFailText];
    [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
    [_errorView setCenterY:fErrorImageViewTop];
    [_errorView setCenterX:self.tableView.centerX];
    [self.tableView addSubview:_errorView];
}

- (void)didFinishLoad:(id)objc {
    
    if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
    
    //if (array != nil)
    {
        [_errorView removeFromSuperview];
    }
       
    if(_footerLoading)
    {
        [self finishLoadFooterTableViewDataSource];
    }
    
    if(_headerLoading)
    {
        self.model = nil;
        [self finishLoadHeaderTableViewDataSource];
    }
    
    if([(NSArray*)objc count] == 0)
    {
        if(self.model == nil)
        {
            [self addSubErrorView];
            [self.tableView reloadData];
        }
        self.enableFooter = NO;
        
        return;
    }

    if([(NSArray*)objc count] < 20)
    {
        self.enableFooter = NO;
    }
    else
    {
        self.enableFooter = YES;
    }
    
    [super didFinishLoad:objc];
    [self.tableView reloadData];
}

- (void)addSubErrorView
{
    CGFloat fErrorImageViewTop = (self.tableView.height - self.tableView.tableHeaderView.height)/2 + self.tableView.tableHeaderView.height;
    
    [_errorLabel setShadowColor:[UIColor colorWithRed:216./255. green:216./255. blue:216./255. alpha:1.]];
    API_GET_TYPE api_type = [self modelApi];
    switch (api_type) {
        case API_GET_USER_INFO:
            [_errorLabel setText:@"获取个人信息失败"];
            [_errorImageView setImage:[UIImage imageNamed:@"没有"]];
            break;
        case API_LIST_USER_STATUS:
            [_errorLabel setText:@"获取个人状态失败"];
            [_errorImageView setImage:[UIImage imageNamed:@"没有"]];
            break;
        case API_LIST_USER_STATUS_COMMENT:
            [_errorLabel setText:@"获取个人状态评论"];
            [_errorImageView setImage:[UIImage imageNamed:@"没有"]];
            break;
        case API_LIST_USER_STATUS_LIKE:
            [_errorLabel setText:@"获取个人状态喜欢"];
            [_errorImageView setImage:[UIImage imageNamed:@"没有"]];
            break;
        case API_LIST_RECOMMEND:
            break;
        default:
            [_errorLabel setText:@"空"];
            [_errorImageView setImage:[UIImage imageNamed:@"没有"]];
            break;
    }           
    
    [_errorView setCenterY:fErrorImageViewTop];
    [_errorView setCenterX:self.tableView.centerX];
    
    [_tableView addSubview:_errorView];
    [_tableView sendSubviewToBack:_errorView];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, self.tableView.width, 60)];
    _refreshHeaderView.delegate = self;
    
    [_refreshHeaderView refreshLastUpdatedDate];
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 48)];
    _refreshFooterView.delegate = self;
    _headerLoading = NO;
    _footerLoading = NO;
    [_refreshFooterView refreshLastUpdatedDate];
    
    [self.view addSubview:self.tableView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setHidesWhenStopped:YES];
    [_activityIndicator setCenter:self.tableView.center];
    [_activityIndicator setTop:_activityIndicator.top - 50];
    [self activityIndicatorAni:YES];
    [self.tableView addSubview:_activityIndicator];
    [self createErrorView];
}

- (void)createErrorView
{
    self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 70)];
    [_errorView setBackgroundColor:[UIColor clearColor]];
    self.errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [_errorImageView setBackgroundColor:[UIColor clearColor]];
    [_errorImageView setFrame:CGRectMake(40, 0, 70, 70)];
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 12)];
    [_errorLabel setTop:_errorImageView.bottom +5];
    [_errorLabel setFont:[UIFont systemFontOfSize:12.]];
    [_errorLabel setTextColor:[UIColor colorWithRed:155./255. green:155./255. blue:155./255. alpha:1.0]];
    [_errorLabel setShadowColor:[UIColor colorWithRed:216./255. green:216./255. blue:216./255. alpha:1.]];
    [_errorLabel setShadowOffset:CGSizeMake(0, 1)];
    [_errorLabel setTextAlignment:UITextAlignmentCenter];
    [_errorLabel setBackgroundColor:[UIColor clearColor]];
    
    [_errorView addSubview:_errorImageView];
    [_errorView addSubview:_errorLabel];
    [_errorView setCenterX:self.tableView.centerX];
}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isTracking = YES;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
}

- (void)activityIndicatorAni:(BOOL)animal
{
    if(animal)
    {
        CGFloat activityIndicatorY = (self.tableView.height - self.tableView.tableHeaderView.height)/2 + self.tableView.tableHeaderView.height;
        [_activityIndicator setCenterY:activityIndicatorY];
        [_activityIndicator startAnimating];
    }
    else
    {
        [_activityIndicator stopAnimating];
    }
    
}
- (void)activityIndicatorState
{
    if(_activityIndicator && _errorView &&![_errorView isDescendantOfView:self.tableView] && self.model == nil)
    {
        [self activityIndicatorAni:YES];
    }
    else if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self activityIndicatorState];
}

- (void)setSeparatorClear
{
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.model== nil)
        return 0;
#warning isKindOfClass:[NSDictionary class] ??
    if([self.model isKindOfClass:[NSDictionary class]])
        return 1;
    
    return [(NSArray*)self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class cls = [self cellClass];
    static NSString *identifier = @"Cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([cell respondsToSelector:@selector(setObject:)]) {
        if([(NSArray*)self.model count] > indexPath.row)
        {
            id item = nil;
            if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
                item = [self.model objectAtIndex:indexPath.row];
            else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
                item = self.model;

            [cell setObject:item];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![cell isKindOfClass:[UserStatusCell class]])
        return;
    
    if(self.isTracking == NO)
        return;
    
    self.isTracking = NO;
    
    id curPlayRow = [self getCurCellIndex];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = nil;
    if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
        item = [self.model objectAtIndex:indexPath.row];
    else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
        item = self.model;
    Class cls = [self cellClass];
    if ([cls respondsToSelector:@selector(rowHeightForObject:)]) {
        return [cls rowHeightForObject:item];
    }
    return tableView.rowHeight; // failover
}

- (id)getCurCellIndex
{
    id curPlayCellIndex = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"curPlayCellIndex_%d",[self modelApi]]];
    
    if(curPlayCellIndex)
    {
        return [self.tableView.indexPathsForVisibleRows count] > [curPlayCellIndex intValue]?  curPlayCellIndex: [NSNumber numberWithInt:0];
    }
    
    return [NSNumber numberWithInt:0];
}

#pragma scro

- (void)setEnableFooter:(BOOL)tf
{
    _enableFooter = tf;
    _enableFooterTemp = tf;
    /*
     if (tf == YES) {
     if ([self.subviews containsObject:_refreshFooterView] == NO) {
     [self addSubview:_refreshFooterView];
     }
     } else {
     if ([self.subviews containsObject:_refreshFooterView] == YES) {
     [_refreshFooterView removeFromSuperview];
     }
     }
     */
    if (tf == YES) {
        //[_refreshFooterView setBackgroundColor:[UIColor redColor]];
        [self.tableView setTableFooterView:_refreshFooterView];
    } else {
        [self.tableView setTableFooterView:nil];
    }
}

- (void)setEnableHeader:(BOOL)tf
{
    _enableHeader = tf;
    if (tf == YES) {
        if ([self.tableView.subviews containsObject:_refreshHeaderView] == NO) {
            [self.tableView addSubview:_refreshHeaderView];
        }
    } else {
        if ([self.tableView.subviews containsObject:_refreshHeaderView] == YES) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

- (void)updateFooter
{
    /*
     CGSize size = self.contentSize;
     CGSize size2 = self.frame.size;
     if (size.height < size2.height) {
     size.height = size2.height;
     }
     
     _refreshFooterView.frame = CGRectMake(0, size.height, size.width, 60);
     */
}

- (void)showDataLoading:(CGFloat)offsety
{
    // 会调用loadHeader
    if (_enableHeader == YES && offsety < -44)
    {
        self.tableView.contentOffset = CGPointMake(0, offsety);
        [_refreshHeaderView egoRefreshScrollViewDidScroll: self.tableView];
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging: self.tableView];
    }
}

- (void)activeRefresh
{
    [self showDataLoading: -70];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[Global clearPlayStatus];
    if (scrollView.contentOffset.y < 0) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    } else if (scrollView.contentOffset.y > 10) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGSize size = scrollView.frame.size;
    CGFloat offsety = scrollView.contentOffset.y;
    //NSLog(@"scrollViewDidEndDragging %f %f",scrollView.contentSize.height, offsety);
    
    CGFloat offset = scrollView.contentSize.height - size.height;
    if (offset < 0) {
        offset = 0;
    }
    if (_enableHeader == YES && offsety < -50) {
        // header刷新
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    } else if (_enableFooter == YES && offsety > offset+10) {
        // footer刷新
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}
#pragma mark -

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadHeaderTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _headerLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self reloadFooterTableViewDataSource];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _footerLoading;
}

- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view
{
    return [NSDate date];
}

- (void)loadMoreData:(NSNumber *)loadHeader
{
    [super loadMoreData:loadHeader];
    //[self updateFooter];
}

- (void)reloadHeaderTableViewDataSource
{
    if([_activityIndicator isAnimating])
    {
        [self finishLoadHeaderTableViewDataSource];
        return;
    }
    _headerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:NO]];
    }
    //[self finishLoadHeaderTableViewDataSource];
}

- (void)reloadFooterTableViewDataSource
{
	_footerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:YES]];
    }
    
    //[self finishLoadFooterTableViewDataSource];
}

- (void)finishLoadHeaderTableViewDataSource
{
    //    [self checkTimeout: _refreshHeaderView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshHeaderView afterDelay:0.01];
}

- (void)finishLoadFooterTableViewDataSource
{
    //    [self checkTimeout: _refreshF ooterView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshFooterView afterDelay:0.01];
}

- (void)checkTimeout:(id)view
{
    if ([view isKindOfClass:[EGORefreshTableHeaderView class]] == YES) {
        _headerLoading = NO;
   
        EGORefreshTableHeaderView *header = (EGORefreshTableHeaderView *)view;
        if ([header getState] != EGOOPullRefreshNormal) {
            [header egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
    } else if ([view isKindOfClass:[EGORefreshTableFooterView class]] == YES) {
        _footerLoading = NO;
        EGORefreshTableFooterView *footer = (EGORefreshTableFooterView *)view;
        if ([footer getState] != EGOOPullRefreshNormal) {
            [footer egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
    }
}

@end
