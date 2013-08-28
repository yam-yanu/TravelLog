//
//  CatcViewController3.h
//  rerecamp
//
//  Created by yukihara on 2013/08/26.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remember_travel.h"

@interface CatcViewController3 : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    remember_travel *rt;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
