//
//  NSDictionary(Json).m
//  CaiYun
//
//  Created by lusonglin on 13-5-8.
//
//

#import "NSDictionary(Json).h"

@implementation NSDictionary(Json)


- (id)jsonObjectForKey:(id)aKey
{
    if ([[self objectForKey:aKey]isKindOfClass:[NSNull class]])
        return nil;
    
    return [self objectForKey:aKey];
}


@end
