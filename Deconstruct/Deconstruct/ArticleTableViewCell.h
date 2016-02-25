//
//  ArticleTableViewCell.h
//  PassionProject
//
//  Created by C4Q on 2/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UIView *view;

@end
