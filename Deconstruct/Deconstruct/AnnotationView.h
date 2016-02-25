//
//  AnnotationView.h
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/15.
//  Copyright © 2015 Michael Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationView : UIScrollView

@property (weak, nonatomic) IBOutlet UILabel *countryName;

@property (weak, nonatomic) IBOutlet UILabel *totalPop;
@property (weak, nonatomic) IBOutlet UILabel *gDP;
@property (weak, nonatomic) IBOutlet UILabel *fDI;
@property (weak, nonatomic) IBOutlet UILabel *timeReqBus;

@property (weak, nonatomic) IBOutlet UILabel *surfaceArea;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;


@property NSURL *url;



@end
