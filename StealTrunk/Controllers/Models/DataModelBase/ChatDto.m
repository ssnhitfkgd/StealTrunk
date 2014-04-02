//
//  ChatDto.m
//  StealTrunk
//
//  Created by wangyong on 13-7-22.
//
//

#import "ChatDto.h"

@implementation Chat_message
@synthesize chat_id = _chat_id;
@synthesize chat_type = _chat_type;
@synthesize create_time = _create_time;
@synthesize text = _text;
@synthesize audio = _audio;
@synthesize img = _img;
@synthesize from = _from;

- (void)parseWithDic:(NSDictionary *)result
{
    self.chat_id = [self getStrValue:[result objectForKey:@"id"]];
    self.chat_type = [self getIntValue:[result objectForKey:@"type"]];
    self.create_time = [self getStrValue:[result objectForKey:@"create_time"]];
    self.text = [self getStrValue:[result objectForKey:@"text"]];
    self.audio = [self getStrValue:[result objectForKey:@"audio"]];
    self.img = [self getStrValue:[result objectForKey:@"image"]];
    self.from = [self getStrValue:[result objectForKey:@"from"]];
}
@end

@implementation ChatDto
@synthesize chatMessage = _chatMessage;
@synthesize userInfo = _userInfo;

- (BOOL)parse2:(NSDictionary *)result
{
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        self.chatMessage = [[Chat_message alloc] init];
        id obj = [result objectForKey:@"message"];
        if(!obj)
        {
            return NO;
        }
        [self.chatMessage parseWithDic:obj];
       
        self.userInfo = [[Monstea_user_info alloc] init];
        obj = [result objectForKey:@"user"];
        if(!obj)
        {
            return NO;
        }
        [self.userInfo parseWithDic:[result objectForKey:@"user"]];
      
        return YES;
    }
    return NO;
}


@end
