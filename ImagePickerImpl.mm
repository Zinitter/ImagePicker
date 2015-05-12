// Image Picker for cocos2d-x
// @Author: Kanglai Qian
// @url: https://github.com/qiankanglai/ImagePicker

#include "ImagePicker.h"
#include "ImagePickerImpl.h"
#import "ImagePickerBase64-ios-mac.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "ImagePicker-ios.h"
static ImagePickerIOS *sharedPicker = [[[ImagePickerIOS alloc] init] retain];
#endif

#include "cocos2d.h"

using namespace cocos2d;

void ImagePickerImpl::openImage()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    [sharedPicker takePicture];
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
    @autoreleasepool {
        NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        NSArray *fileTypesArray = fileTypesArray = [NSArray arrayWithObjects:@"png", @"jpeg", @"jpg", nil];
        [openDlg setCanChooseFiles:YES];
        [openDlg setAllowedFileTypes:fileTypesArray];
        [openDlg setAllowsMultipleSelection:FALSE];
        if ( [openDlg runModal] == NSOKButton )
        {
            NSArray *files = [openDlg URLs];
            
            if([files count] > 0)
            {
                NSString* path = [[files objectAtIndex:0] path];

                NSData *imageData = [NSData dataWithContentsOfFile:path];
                
                NSString *base64ImageString = [Base64 encode:imageData];
   
                Texture2D* texture = Director::getInstance()->getTextureCache()->addImage(std::string([path UTF8String]));
                ImagePicker::getInstance()->finishImage(texture, std::string([base64ImageString UTF8String]));

                return;
            }
        }
        ImagePicker::getInstance()->finishImage(nullptr, std::string());
    }
#else
    CCLOG("ImagePickerImpl: unsupported yet");
    ImagePicker::getInstance()->finishImage(nullptr, std::string());
#endif
}

