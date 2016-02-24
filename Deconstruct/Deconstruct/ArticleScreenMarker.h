//
//  ArticleScreenMarker.h
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/15.
//  Copyright © 2015 Michael Xu. All rights reserved.
//

#import <WhirlyGlobeMaplyComponent/MaplyScreenMarker.h>
#import <WhirlyGlobeMaplyComponent/MaplyAnnotation.h>

@interface ArticleScreenMarker : MaplyScreenMarker

- (id) initWithDictionary:(NSDictionary *)articleInfo;

@property MaplyAnnotation *info;
@property NSDictionary *articleInfo;

@end
