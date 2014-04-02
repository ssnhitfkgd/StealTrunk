//
//  PublishViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-1.
//
//

#import "BaseController.h"
#import "VoiceRecorderBase.h"
#import "NCMusicEngine.h"

@interface PublishViewController : BaseController<NCMusicEngineDelegate,AVAudioRecorderDelegate,UIActionSheetDelegate,UIScrollViewDelegate,VoiceRecorderBaseDelegate>

@end
