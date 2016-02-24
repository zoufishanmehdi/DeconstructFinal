//
//  AnnotationView.m
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/15.
//  Copyright © 2015 Michael Xu. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView

- (IBAction)readArticle:(id)sender {
    if (![[UIApplication sharedApplication] openURL:self.url]) {
        NSLog(@"%@%@",@"Failed to open url:",[self.url description]);
    }
}

- (void) randomFunc {
    return;
}


@end