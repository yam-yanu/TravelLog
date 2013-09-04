#import "CatcViewController3.h"

@implementation CatcViewController3
{
    NSArray *myArray;//セル表示用配列
}

- (void)viewDidLoad
{
    //セルに表示するテキストを配列に格納
    self.title = @"旅行一覧";
    rt = [[remember_travel alloc]init];
    [rt setTravelList];
}

//セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //配列の要素数だけセルを設定
    return [rt.date count];
    //return 1;
}

//セルの内容の設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    // セルに表示する文字を設定
    //cell.imageView.image = [rt.picture objectAtIndex:indexPath.row];
    cell.textLabel.text = [rt.travelName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [rt.date objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:[rt.picture objectAtIndex:indexPath.row]];
    //cell.textLabel.text = @"謎";
    //cell.detailTextLabel.text = @"冷麺かな？";
    NSLog(@"リスト表示");
    
    return cell;
}


//画面遷移
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //地図描写の為に参照したい旅行Noを記録
    [remember_travel changeTravelNo:indexPath.row];
    
    //セル選択状態の解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CatcViewController4 *referenceMap = [self.storyboard instantiateViewControllerWithIdentifier:@"referenceMap"];
    [[self navigationController] pushViewController:referenceMap animated:YES];
}

@end