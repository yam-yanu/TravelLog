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
    NSLog(@"aaa");
    NSLog(@"aaa");

    //tNo = 1;
    //初めての起動なら初期化＋旅行中なら地図に画面遷移
    if([travel_sequence first_launch] == 1){
        CatcViewController2 *view2 = [self.storyboard instantiateViewControllerWithIdentifier:@"travelView"];
        [self presentViewController: view2 animated:YES completion: nil];
    }else{
        CatcViewController1 *view1 = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
       [self presentViewController: view1 animated:YES completion: nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
