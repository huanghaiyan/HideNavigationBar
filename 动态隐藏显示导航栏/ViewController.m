//
//  ViewController.m
//  动态隐藏显示导航栏
//
//  Created by 黄海燕 on 16/5/9.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+Awesome.h"
#define NAVBAR_CHANGE_POINT 50
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 150)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
   
    [self createNavigationBar];
    _redView = [[UIView alloc]initWithFrame:CGRectMake(10, 64, 50, 45)];
    _redView.backgroundColor = [UIColor redColor];
    _redView.layer.masksToBounds = YES;
    _redView.layer.cornerRadius = 10;
    [self.view addSubview:_redView];
}

-(void)createNavigationBar
{
    //首次界面
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    cityLabel.text = @"正在定位";
    cityLabel.tag = 124;
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.font = [UIFont boldSystemFontOfSize:17];
    UIBarButtonItem * cityItem = [[UIBarButtonItem alloc]initWithCustomView:cityLabel];
   
    self.navigationItem.leftBarButtonItems = @[cityItem];
}

#pragma mark UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"header";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        
//        _redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
//        _redView.backgroundColor = [UIColor redColor];
//        [self.view addSubview:_redView];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"text";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        [UIView animateWithDuration:0.5 animations:^{
            _redView.frame = CGRectMake(10, 64, self.view.frame.size.width - 20, 45);
        }];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        
        [UIView animateWithDuration:0.5 animations:^{
            _redView.frame = CGRectMake(10, 64, 50, 45);
        }];

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
