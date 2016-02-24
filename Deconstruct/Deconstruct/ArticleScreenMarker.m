//
//  ArticleScreenMarker.m
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/15.
//  Copyright © 2015 Michael Xu. All rights reserved.
//

#import "ArticleScreenMarker.h"

@implementation ArticleScreenMarker

- (id) initWithDictionary:(NSDictionary *)articleInfo    {
    self = [super init];
    
    if (self)   {
        self.articleInfo = articleInfo;
        self.info = [[MaplyAnnotation alloc] init];
    }

    return self;
}

@end
