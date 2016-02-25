//
//  WorldNewsTVC.m
//  PassionProject
//
//  Created by C4Q on 2/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import "WorldNewsTVC.h"
#import "ArticleTableViewCell.h"
#import "WorldNewsData.h"

@interface WorldNewsTVC () <UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic) WorldNewsData *data;
@property (nonatomic) NSMutableArray *searchResults;
//@property (strong, nonatomic) RESideMenu *leftViewController;

-(void)LayoutTableView;

@end

@implementation WorldNewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"World News";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    
      [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imageView.image = [UIImage imageNamed:@"Balloon"];
//    [self.view addSubview:imageView];
    

//    [self fetchData:nil];
//    [NSTimer scheduledTimerWithTimeInterval:30.0
//                                     target:self
//                                   selector:@selector(fetchData:)
//                                   userInfo:nil];
    //NSURL connection
    [self fetchData];
    [self LayoutTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"DEMOFirstViewController will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"DEMOFirstViewController will disappear");
}





// INDICATORS WORK!!!!
- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"http://api.npr.org/query?id=1122,1004&fields=title,teaser,storyDate,text,image&requiredAssets=text&dateType=story&output=JSON&numResults=10&apiKey=MDIyNTg2ODAxMDE0NTQ1OTU1NTU1N2E2Ng000"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    
    
    
    // NSError *jsonParsingError = nil;
    NSDictionary *responseObj = [NSJSONSerialization JSONObjectWithData:response
                                                        options:0 error:nil];
    
   // NSLog(@"%@", country);
    
    NSDictionary *lists = [responseObj objectForKey:@"list"];
    
    NSArray *posts = [lists objectForKey:@"story"];
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    for (NSDictionary *post in posts) {
        
    
    
    //Story Title
    NSDictionary *title = [post objectForKey:@"title"];
    NSString * titleString = [title objectForKey:@"$text"];
    NSLog(@"%@", titleString);
    
    //Story Snippet
    NSDictionary *snippet = [post objectForKey:@"teaser"];
    NSString *snippetText = [snippet objectForKey:@"$text"];
    NSLog(@"%@", snippetText);
    
    //Story Date
    NSDictionary *storyDate = [post objectForKey:@"storyDate"];
    NSString *dateString = [storyDate objectForKey:@"$text"];
    NSLog(@"%@", dateString);
    
    //create new post from json
    //             WorldNewsData *data = [[WorldNewsData alloc] initWithJSON:post];
    //             // add post to array
    //             [self.searchResults addObject:data];
    //             NSLog(@"This is the world news data: %@",data);
    
    WorldNewsData *data = [[WorldNewsData alloc] init];
    data.titleString = titleString;
    data.snippetText = snippetText;
    data.dateString = dateString;
    
    [self.searchResults addObject:data];
    
    
    [self.tableView reloadData];
    }
//
//    //TOTAL POP
//    NSDictionary *pop = [country objectAtIndex:0];
//    NSLog(@"%@", pop);
//    self.totalPop = [pop objectForKey:@"value"];
//    //    NSLog(@"%@", self.totalPop);
//    infoPane.totalPop.text = self.totalPop;
//
//    //surface area
//    NSDictionary *sur = [country objectAtIndex:1];
//    NSLog(@"%@", sur);
//    self.surfacear = [sur objectForKey:@"value"];
//    NSLog(@"%@", self.surfacear);
//    infoPane.surfaceArea.text = self.surfacear;
}


#pragma mark- NPR API
//-(void)nprJson {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager GET:@"http://api.npr.org/query?id=1122,1004&fields=title,teaser,storyDate,text,image&requiredAssets=text&dateType=story&output=JSON&numResults=10&apiKey=MDIyNTg2ODAxMDE0NTQ1OTU1NTU1N2E2Ng000"
//      parameters:nil
//        progress:nil
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             
//             //NSArray *posts = [responseObject objectForKey:@"data"];
//             
//             NSDictionary *lists = [responseObject objectForKey:@"list"];
//             
//             NSArray *posts = [lists objectForKey:@"story"];
//             
//             self.searchResults = [[NSMutableArray alloc] init];
//             
//             for (NSDictionary *post in posts) {
//                 
//                 //Story Title
//                 NSDictionary *title = [post objectForKey:@"title"];
//                 NSString * titleString = [title objectForKey:@"$text"];
//                 NSLog(@"%@", titleString);
//                 
//                 //Story Snippet
//                 NSDictionary *snippet = [post objectForKey:@"teaser"];
//                 NSString *snippetText = [snippet objectForKey:@"$text"];
//                 NSLog(@"%@", snippetText);
//                 
//                 //Story Date
//                 NSDictionary *storyDate = [post objectForKey:@"storyDate"];
//                 NSString *dateString = [storyDate objectForKey:@"$text"];
//                 NSLog(@"%@", dateString);
//                 
//                 //create new post from json
//                 //             WorldNewsData *data = [[WorldNewsData alloc] initWithJSON:post];
//                 //             // add post to array
//                 //             [self.searchResults addObject:data];
//                 //             NSLog(@"This is the world news data: %@",data);
//                 
//                 WorldNewsData *data = [[WorldNewsData alloc] init];
//                 data.titleString = titleString;
//                 data.snippetText = snippetText;
//                 data.dateString = dateString;
//                 
//                 [self.searchResults addObject:data];
//                 
//                 [self.tableView reloadData];
//             }
//             
//         }
//         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             
//             NSLog(@"%@", error.userInfo);
//             
//         }];
//    
//}
//

#pragma MARK - UITableView Methods

#pragma MARK - UITableView Methods

-(void)LayoutTableView
{
    self.cellZoomInitialAlpha = [NSNumber numberWithFloat:0.1];
    self.cellZoomAnimationDuration = [NSNumber numberWithFloat:0.3];
    self.cellZoomXScaleFactor = [NSNumber numberWithFloat:1.3];
    self.cellZoomYScaleFactor = [NSNumber numberWithFloat:1.3];
    self.cellZoomXOffset = [NSNumber numberWithFloat:-75];
    self.cellZoomYOffset = [NSNumber numberWithFloat:75];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    if (self.searchResults != nil) {
        WorldNewsData *data = self.searchResults[indexPath.row];
        
        //[cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        cell.headlineLabel.text = data.titleString;
        NSLog(@"%@", data.titleString);
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.snippetLabel.text = data.snippetText;
        NSLog(@"%@", data.snippetText);
        
        cell.articleImage.image = [UIImage imageNamed:@"grayBackground"];
    }
    return cell;
}



@end

