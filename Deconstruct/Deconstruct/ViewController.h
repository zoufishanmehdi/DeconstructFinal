//
//  ViewController.h
//  Deconstruct
//
//  Created by C4Q on 2/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhirlyGlobeMaplyComponent/WhirlyGlobeComponent.h"
#import "ArticleScreenMarker.h"
#import "AnnotationView.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate, CLLocationManagerDelegate>


@end

