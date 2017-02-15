//
//  TableViewCell.h
//  RAC
//
//  Created by ShaoFeng on 2017/2/14.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const NotificationName = @"NotificationName";
@class TableViewCell;
@protocol TableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(TableViewCell *)cell buttonClick:(UIButton *)button;
@end

@interface TableViewCell : UITableViewCell
@property (nonatomic,weak)id<TableViewCellDelegate>delegate;
@end
