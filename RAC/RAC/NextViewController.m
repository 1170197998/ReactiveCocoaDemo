//
//  NextViewController.m
//  RAC
//
//  Created by ShaoFeng on 2017/2/14.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "NextViewController.h"
#import "TableViewCell.h"
#import "ReactiveCocoa.h"
@interface NextViewController ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"ID"];
    
    //检测代理
    [[self rac_signalForSelector:@selector(tableViewCell:buttonClick:) fromProtocol:@protocol(TableViewCellDelegate)] subscribeNext:^(id x) {
        NSLog(@"代理相应成功");
    }];
    //检测通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotificationName object:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //检测某个方法被调用
    [[self rac_signalForSelector:@selector(tableView:numberOfRowsInSection:)] subscribeNext:^(id x) {
        NSLog(@"tableView:numberOfRowsInSection:被调用!");
    }];
    
//    [[self rac_signalForSelector:@selector(tableView:numberOfRowsInSection:) fromProtocol:@protocol(UITableViewDataSource)] map:^id(id value) {
//        return [@5 stringValue];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
