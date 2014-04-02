//
//  VoiceRecorderBase.m
//  StealTrunk
//
//  Created by wangyong on 13-7-15.
//
//

#import "VoiceRecorderBase.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@interface VoiceRecorderBase ()
@end

@implementation VoiceRecorderBase
@synthesize vrbDelegate,maxRecordTime,recordFileName,recordFilePath;

/**
	生成当前时间字符串
	@returns 当前时间字符串
 */
- (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}


/**
	获取缓存路径
	@returns 缓存路径
 */
- (NSString*)getCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Voice"];
}

/**
	判断文件是否存在
	@param _path 文件路径
	@returns 存在返回yes
 */
- (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}

/**
	删除文件
	@param _path 文件路径
	@returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}
    
/**
	生成文件路径
	@param _fileName 文件名
	@param _type 文件类型
	@returns 文件路径
 */
- (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[self getCacheDirectory] stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}

/**
 生成文件路径
 @param _fileName 文件名
 @returns 文件路径
 */
- (NSString*)getPathByFileName:(NSString *)_fileName{
    NSString* fileDirectory = [[self getCacheDirectory] stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}

/**
	获取录音设置
	@returns 录音设置
 */
- (NSDictionary*)getAudioRecorderSettingDict
{
    /*
=======
    //初始化录音
>>>>>>> 6aa9d78aa269dc32f0956469733102135be4a111
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
//                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
//                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
     */
    
////////////////////////////////////////
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
//                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
//                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   [NSNumber numberWithInt: AVAudioQualityHigh],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    /*
    [recordSettings setObject:formatObject forKey: AVFormatIDKey];//ID
    [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];//采样率
    [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];//通道的数目,1单声道,2立体声
    [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];//解码率
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//采样位
    [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    */
    return recordSetting;
}

- (NSInteger) getFileSize:(NSString*) filePath{
    NSFileManager * filemanager = [[NSFileManager alloc] init];
    if([filemanager fileExistsAtPath:filePath]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:filePath error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

- (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath{
    
    if (! DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0;
    
    return 1;
}

- (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath{
    
    if (EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return 0;
    
    return 1;
}

@end
