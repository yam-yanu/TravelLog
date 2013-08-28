//
//  CatcViewController3.m
//  rerecamp
//
//  Created by yukihara on 2013/08/26.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "CatcViewController3.h"
#import "CatcViewController4.h"

@interface CatcViewController3 ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CatcViewController3
@synthesize myTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"たびろぐ";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"もどる" style:UIBarButtonItemStylePlain target:self action:@selector(returnHome)];
    rt = [[remember_travel alloc]init];
    [rt setTravelList];
    [myTableView setDataSource:self];
    [myTableView setDelegate:self];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)returnHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
    //return [rt.travelName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell1 = [[ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1" ];
    cell1.imageView.image = [ UIImage imageNamed:@"gyoumurei.jpg" ];
    cell1.textLabel.text = @"北海道旅行";
    cell1.detailTextLabel.text = @"7月28日〜8月3日";
    
//    UITableViewCell *cell;
//    
//    if(indexPath.row==0){ //0行目のセル
//        //カスタムセルを選ぶ
//        cell =  [myTableView dequeueReusableCellWithIdentifier:@"helloCell"];
//        
//        //各要素にはタグでアクセスする
//        UILabel *idLabel = (UILabel*)[cell viewWithTag:1];
//        idLabel.text = @"Bye";
//        
//    }else if(indexPath.row==1){//1行目のセル
//        cell =  [myTableView dequeueReusableCellWithIdentifier:@"switchCell"];
//    }
    
    return cell1;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
        CatcViewController4 *detailViewController = [[CatcViewController4 alloc] init];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
