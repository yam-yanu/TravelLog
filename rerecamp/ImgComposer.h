
#import <Foundation/Foundation.h>

@interface ImgComposer : NSObject

+ (ImgComposer*)sharedManager;

- (UIImage *) composedImageWithOriginal:(UIImage*)original;

@end
