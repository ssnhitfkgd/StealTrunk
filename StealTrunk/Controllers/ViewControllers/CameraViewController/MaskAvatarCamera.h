//
//  CameraViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-30.
//
//

#import "BaseController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol MaskAvatarCameraDelegate <NSObject>

- (void)alreadyUpdateAvatar:(NSString *)avatar;

@end

@interface MaskAvatarCamera : BaseController<AVCaptureVideoDataOutputSampleBufferDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) id<MaskAvatarCameraDelegate>delegate;

@end
