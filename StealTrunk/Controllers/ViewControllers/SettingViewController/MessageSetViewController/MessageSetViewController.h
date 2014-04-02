//
//  MessageSetViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-8-5.
//
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"

@interface MessageSetViewController : JMStaticContentTableViewController
{
    NSMutableDictionary *mutableMsgDict;
}

- (id)initWithMsgDict:(NSDictionary*)dict;
@end
