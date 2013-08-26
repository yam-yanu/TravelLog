//
//  CatcViewController.m
//  rerecamp
//
//  Created by yukihara on 2013/08/23.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "CatcViewController2.h"
#import "ImgComposer.h"

@interface CatcViewController2 ()

@end

@implementation CatcViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.702252
                                                            longitude:135.500231
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;

    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(34.702252, 135.500231)];
    [path addCoordinate:CLLocationCoordinate2DMake(37.45, 134.500231)];
    [path addCoordinate:CLLocationCoordinate2DMake(37.45, 133.500231)];

    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.map = _mapView;
    
    GMSMarker *options = [[GMSMarker alloc] init];
    options.position = CLLocationCoordinate2DMake(34.702252, 135.500231);
    ImgComposer *imc = [ImgComposer sharedManager];
    UIImage *cameraimg = [UIImage imageNamed:@"testicon1.jpg"];
    UIImage *image = [imc composedImageWithOriginal:cameraimg];
    options.title = @"大阪富国生命ビル";
    options.snippet = @"日本";
    options.map = _mapView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(100, 100, 90, 90);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];

    
    /*NSArray *imagearray = [NSArray arrayWithObjects:@"aaa", @"aaaa", nil];
    for (int i = 0; i < imagearray.count; i++)
    {
        GMSMarker *option = [[GMSMarker alloc] init];
        option.position = CLLocationCoordinate2DMake(34.702252, 135.500231);
        if (imagearray[i] != nil) option.icon = imagearray[i];//[UIImage imageNamed:@"testicon1.jpg"];
        option.title = @"大阪富国生命ビル";
        option.snippet = @"日本";
        option.map = _mapView;
    }*/
    
//  [self.mapView MarkerWithPosition:options];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
    
}

- (void)configureView
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 416.0, 320.0, 44.0)];
    toolbar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *camerabtn = [[UIBarButtonItem alloc]  initWithTitle:@"カメラ" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapCamera: ) ];
    UIBarButtonItem *top = [[UIBarButtonItem alloc]  initWithTitle:@"おわる" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapOwaru: ) ];
    toolbar.items = [ NSArray arrayWithObjects:camerabtn, top,
                     nil ];
    [self.view addSubview:toolbar];
}

- (void)onTapCamera:(id)inSender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		// カメラかライブラリからの読込指定。カメラを指定。
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		// Delegate
		[imagePickerController setDelegate:self];
		// アニメーションをしてカメラUIを起動
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		NSLog(@"camera invalid.");
	}
}

- (void) onTapOwaru:(id)inSender
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //撮ったデータをUIImageにセットする
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    //カメラロールに画像を保存
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    //ここからPOSTDATAの作成
    
    UIImage *postImage;
    
    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
    [image drawInRect:CGRectMake(0, 0, 100, 100)];
    postImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = [[NSData alloc] initWithData:UIImagePNGRepresentation(postImage)];
	
	NSURL *cgiUrl = [NSURL URLWithString:@"http://49.212.200.39/techcamp/upload_pic.php"];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
	
	//adding header information:
	[postRequest setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[postRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	//setting up the body:
	NSMutableData *postBody = [[NSMutableData alloc] init];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	//[postBody appendData:[@"Content-Disposition: form-data; name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	//[postBody appendData:[mail dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"upfile\"; tmp_name=\"test.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:imgData];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
    
    NSLog(@"a");
    
    //NSURLConnection *connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    
    //    NSData *returnData = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
    NSLog(@"image saved");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//CGRectMake(0,0,0,0)
