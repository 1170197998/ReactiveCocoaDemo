//
//  TableViewCell.m
//  RAC
//
//  Created by ShaoFeng on 2017/2/14.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "TableViewCell.h"
#import "ReactiveCocoa.h"
@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *buttonDelegate;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotification;
@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.buttonDelegate addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonNotification addTarget:self action:@selector(clickButton2) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickButton
{
    NSLog(@"按钮被点击!~去相应代理");
    if ([_delegate respondsToSelector:@selector(tableViewCell:buttonClick:)]) {
        [_delegate tableViewCell:self buttonClick:self.buttonDelegate];
    }
}

- (void)clickButton2
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:nil userInfo:@{@"notificationContent":@666}];
}

@end
