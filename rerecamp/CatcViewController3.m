#import "CatcViewController3.h"

@implementation CatcViewController3
{
    NSArray *myArray;//セル表示用配列
}

- (void)viewDidLoad
{
    //セルに表示するテキストを配列に格納
    myArray = [NSArray arrayWithObjects:@"カテゴリ1",@"カテゴリ2",@"カテゴリ3",nil];
    rt = [[remember_travel alloc]init];
    [rt setTravelList];
}

//セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //配列の要素数だけセルを設定
    //return [rt.date count];
    return 1;
}

//セルの内容の設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    // セルに表示する文字を設定
    cell.imageView.image = [UIImage imageNamed:@"gyoumurei.jpg"];
   // cell.textLabel.text = [rt.date objectAtIndex:indexPath.row];
    cell.textLabel.text = @"謎";
    cell.detailTextLabel.text = @"冷麺かな？";
    NSLog(@"リスト表示");
    
    return cell;
}


//画面遷移
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //セル選択状態の解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    //遷移先（Navi2）クラスのインスタンスを生成
//    TestNavi2 *testNavi2 = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];//手順7で付けた名前
//    
//    //遷移先（Navi2）のタイトル（タップされたセルのテキストとした）の設定
//    testNavi2.title = [myArray objectAtIndex:indexPath.row];
//    
//    [[self navigationController] pushViewController:testNavi2 animated:YES];
}

@end