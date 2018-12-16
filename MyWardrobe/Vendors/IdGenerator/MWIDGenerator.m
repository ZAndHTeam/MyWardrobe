//
//  MWIDGenerator.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWIDGenerator.h"

static long long time_stamp = 0;
static long long time_stamp_now = 0;
static NSMutableArray *temp = NULL;
static NSNumber *random_n = NULL;
static NSLock *theLock = NULL;


@implementation MWIDGenerator

+ (NSString *)generateID {
    if(theLock == NULL)
        theLock = [[NSLock alloc] init];
    
    if(temp == NULL)
        temp = [[NSMutableArray alloc] init];
    
    @synchronized(theLock){
        time_stamp_now = [[NSDate date] timeIntervalSince1970];
        if(time_stamp_now != time_stamp){
            //清空缓存，更新时间戳
            [temp removeAllObjects];
            time_stamp = time_stamp_now;
        }
        
        //判断缓存中是否存在当前随机数
        while ([temp containsObject:(random_n = [NSNumber numberWithLong:arc4random() % 8999 + 1000])]);
        
        if ([temp containsObject:random_n]) {
            return nil;
        }
        
        [temp addObject:[NSNumber numberWithLong:[random_n longValue]]];
    }
    
    long long generateId = -1.f;
    
    generateId = (time_stamp * 10000) + [random_n longValue];
    
    return [NSString stringWithFormat:@"%lld", generateId];
}

@end
