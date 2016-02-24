//
//  AnnotationView.h
//  helloEarth2
//
//  Created by Varun Nambiar on 9/26/15.
//  Copyright © 2015 Michael Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationView : UIScrollView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *snippet;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *publisherImage;

@property NSURL *url;

- (IBAction)readArticle:(id)sender;


@end
