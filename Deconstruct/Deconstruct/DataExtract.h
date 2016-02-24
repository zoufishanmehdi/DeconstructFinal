//
//  DataExtract.h
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/2015.
//  Copyright (c) 2015 Varun Nambiar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataExtract : NSObject

@property NSArray *articleList;

- (void) openJSON:(NSData *)content;

@end