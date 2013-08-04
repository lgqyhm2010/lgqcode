//
//  NSNotification+_Remove_.h
//  CaiYun
//
//  Created by penghanbin on 13-4-26.
//
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Removed)

- (void)addObserver:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block inClass:(id)cls ;
//移除所有oberver
- (void)removeAllObserver:(id)obj;


@end
