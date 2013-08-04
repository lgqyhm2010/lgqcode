//
//  NSNotification+_Remove_.m
//  CaiYun
//
//  Created by penghanbin on 13-4-26.
//
//

NSString const *ObserversKey = @"ObserversKey";

#import "NSNotificationCenter+Removed.h"
#import <objc/runtime.h>

@interface NSNotificationCenter ()
@property (nonatomic,retain) NSMutableDictionary *observers;
@end

@implementation NSNotificationCenter (Removed)

- (void)setObservers:(NSMutableDictionary *)observers {
    objc_setAssociatedObject(self, ObserversKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary*)observers {
    id obj = objc_getAssociatedObject(self, ObserversKey);
    if (!obj) {
        obj = [NSMutableDictionary dictionary];
        [self setObservers:obj];
    }
    return obj;
}

- (void)addObserver:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block inClass:(id)cls {
    id tmp = [self addObserverForName:name object:obj queue:queue usingBlock:block];
    
    if (tmp && cls) {
        
        NSString *idString = [NSString stringWithFormat:@"%d" ,(int)cls];
        NSDictionary *dic = [self.observers objectForKey:NSStringFromClass([cls class])];
        NSMutableDictionary *clsDic = dic ? [NSMutableDictionary dictionaryWithDictionary:dic] : [NSMutableDictionary dictionary];
        
        NSArray *arr = [clsDic objectForKey:idString];
        NSMutableArray *array = arr ? [NSMutableArray arrayWithArray:arr] : [NSMutableArray array];
        
        [array addObject:tmp];
        
        [clsDic setObject:array forKey:idString];
        
        [self.observers setObject:clsDic forKey:NSStringFromClass([cls class])];
        NSLog(@"%@   %@------>addObserver count:%d" ,NSStringFromClass([cls class]) ,idString ,array.count);
    }
}

- (void)removeAllObserver:(id)obj{

    if (obj) {
        NSString *idString = [NSString stringWithFormat:@"%d" ,(int)obj];
        NSMutableDictionary *clsDic = [self.observers objectForKey:NSStringFromClass([obj class])];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[clsDic objectForKey:idString]];
        
        for (id observer in array) {
            [self removeObserver:observer];
        }
        [array removeAllObjects];
        [clsDic removeObjectForKey:idString];
        NSLog(@"%@   %@------>removeAllObserver count:%d" ,NSStringFromClass([obj class]) ,idString ,clsDic.count);
        if (clsDic.count) {
            [self.observers setObject:clsDic forKey:NSStringFromClass([obj class])];
        } else {
            [self.observers removeObjectForKey:NSStringFromClass([obj class])];
        }
    }
    
    [self removeObserver:obj];
}

- (void)dealloc {
    self.observers = nil;
    [super dealloc];
}

@end
