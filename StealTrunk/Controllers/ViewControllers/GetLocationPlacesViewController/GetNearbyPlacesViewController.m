//
//  GetNearbyPlacesViewController.m
//  StealTrunk
//
//  Created by wangyong on 13-7-4.
//
//

#import "GetNearbyPlacesViewController.h"
#import "GetNearbyPlacesCell.h"


@interface GetNearbyPlacesViewController ()

@end

@implementation GetNearbyPlacesViewController
@synthesize dataArray = _dataArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithObjects:[NSArray array], [NSArray array],[NSArray array], nil];
        self.hidesBottomBarWhenPushed = YES;
        self.title = NSLocalizedString(@"激活部落", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MapViewLocation shareInstance] setFrame:CGRectMake(0, 0, screenSize().width, 200)];
    [self.tableView setTableHeaderView:[MapViewLocation shareInstance]];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithRadius:(NSString *)radius keywords:(NSString *)keywords
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 60)];
    [view setBackgroundColor:[UIColor blackColor]];

    for(int i = 0 ; i < 3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * 320/3 + i * 1, 0, 320/3, 58)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:[MapViewLocation shareInstance].keywords[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:self action:@selector(filterTaped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (void)filterTaped:(UIButton*)button
{
    if(self.model)
    {
        [_dataArray replaceObjectAtIndex:placeType withObject: self.model];
    }
    placeType = button.tag;
    self.model = nil;
    
    NSArray *array = _dataArray[placeType] ;
    if(array && [array count] > 0)
    {
        self.model = array;
        [self.tableView reloadData];
        return;
    }
    [self.tableView reloadData];
    [self reloadData];
}

- (CLLocationCoordinate2D)getLocationCoordinate
{
    return [MapViewLocation shareInstance].coordinateGPS;
}

- (NSString*)getRadius
{
    return [[MapViewLocation shareInstance] getLocationRadius];
}

- (NSString*)getKeywords
{
    return [[MapViewLocation shareInstance] getLocationKeywords:placeType];
}

- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [GetNearbyPlacesCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_LIST_NEARBY_PLACES;
}

- (void)didFinishLoad:(id)objc
{
    for(NSDictionary *dict in objc)
    {
        NSString *string = [dict objectForKey:@"keyword"];
        if([string isEqualToString:[self getKeywords]])
        {
            [_dataArray replaceObjectAtIndex:placeType withObject:[dict objectForKey:@"results"]];
            [super didFinishLoad:_dataArray[placeType]];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetNearbyPlacesCell *cell = (GetNearbyPlacesCell*)[tableView cellForRowAtIndexPath:indexPath];
    id obj = cell.nearbyPlacesView.textLabel.text;
    AccountDTO *accountDto = [AccountDTO sharedInstance];
    [accountDto.dtoResult setObject:obj forKey:@"place"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
