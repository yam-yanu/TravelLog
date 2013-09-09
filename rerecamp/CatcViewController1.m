//
//  CatcViewController2.m
//  rerecamp
//
//  Created by yukihara on 2013/08/25.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "CatcViewController1.h"

@interface CatcViewController1 ()

@end

@implementation CatcViewController1

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
    //NSLog(@"%d",tNo);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startButton:(id)sender {
    [travel_sequence start_travel];
    
    //画面遷移
    CatcViewController2 *view2 = [self.storyboard instantiateViewControllerWithIdentifier:@"travelView"];
    [self presentViewController: view2 animated:YES completion: nil];
}
@end
