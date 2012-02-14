//
//  SDCheckpointLog.h
//  walmart
//
//  Created by Joel Bernstein on 11/8/11.
//  Copyright (c) 2011 Walmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDCheckpointLog : NSObject

+ (void)passCheckpointClass:(Class)class selector:(SEL)selector;
+(void)passCheckpoint:(NSString*)checkpointName;

+(void)passCheckpointVCDidAppearWithFilePath:(const char*)filePath;
+(void)passCheckpointServiceCallBegan:(NSString*)requestName url:(NSURL*)url postParams:(NSString*)postParams;
+(void)passCheckpointServiceCallFinished:(NSString*)requestName;

@end