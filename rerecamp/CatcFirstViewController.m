//
//  CatcFirstViewController.m
//  rerecamp
//
//  Created by ami on 2013/08/28.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "CatcFirstViewController.h"

@interface CatcFirstViewController ()

@end

@implementation CatcFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    //初めての起動なら初期化＋旅行中なら地図に画面遷移
    if([travel_sequence first_launch] == 1){
        CatcViewController2 *view2 = [self.storyboard instantiateViewControllerWithIdentifier:@"travelView"];
        [self presentModalViewController:view2 animated:YES ];
    }else{
        CatcViewController1 *view1 = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
        [self presentModalViewController:view1 animated:YES ];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
