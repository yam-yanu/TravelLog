
#import "ImgComposer.h"

@implementation ImgComposer

static ImgComposer *sharedInstance = nil;

+ (ImgComposer*)sharedManager
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (UIImage *) composedImageWithOriginal:(UIImage*)original
{
    // グラフィックスコンテキストを作る
    int width = 90, height = 90; // ここで画像のサイズを指定する
    CGSize size = { width, height };
    UIGraphicsBeginImageContext(size);
    
    //背景画像を描画
    UIImage *background = [UIImage imageNamed:@"imgframe.png"];
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = size;
    [background drawInRect:rect];
    
    //重ね合わせる画像を描画
    rect.origin = CGPointMake(10, 10);
    rect.size = CGSizeMake(width-20, height-30);
    [original drawInRect:rect];
    
    // 描画した画像を取得する
    UIImage* shrinkedImage;
    shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return shrinkedImage;
}


@end
