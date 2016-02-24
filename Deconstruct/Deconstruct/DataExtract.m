//
//  DataExtract.m
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/2015.
//  Copyright (c) 2015 Varun Nambiar. All rights reserved.
//

#import "DataExtract.h"

@implementation DataExtract

- (id) init {
    self = [super init];
    if (self)   {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSString *stringContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSData *content = [stringContent dataUsingEncoding:NSUTF8StringEncoding];
        
        [self openJSON:content];
    }

    return self;
}

- (void) openJSON:(NSData *)content  {
    NSArray *articles = [NSJSONSerialization JSONObjectWithData:content
                                                        options:0
                                                          error:nil];
    self.articleList = articles;
}

@end

