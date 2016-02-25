//
//  AnalysisTVC.m
//  Deconstruct
//
//  Created by C4Q on 2/25/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import "AnalysisTVC.h"
#import "AnalysisData.h"
#import "TopicTableViewCell.h"

@interface AnalysisTVC ()<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic) AnalysisData *data;
@property (nonatomic) NSMutableArray *searchResults;

//topic properties
@property(nonatomic)NSString *tName;
@property(nonatomic)NSString *tAnalysis;

@end

@implementation AnalysisTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Analysis";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
    
    [self fetchData];
    [self LayoutTableView];
}

- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"http://api.worldbank.org/topics/3;9;12;14?format=json"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    
    
    
    // NSError *jsonParsingError = nil;
    NSArray *topicArray = [[NSJSONSerialization JSONObjectWithData:response
                                                        options:0 error:nil]objectAtIndex:1];
    
    NSLog(@"%@", topicArray);
    
    //initialize searchResults
    self.searchResults = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *post in topicArray) {
        //topic name
       self.tName = [post objectForKey:@"value"];
        NSLog(@"%@", self.tName);
        
        //topic analysis
        self.tAnalysis = [post objectForKey:@"sourceNote"];
        NSLog(@"%@", self.tAnalysis);
        
    
    
//    
//    //Econo
//    NSDictionary *eco = [topicArray objectAtIndex:0];
//    NSLog(@"%@", eco);
//    self.tName = [eco objectForKey:@"value"];
//        NSLog(@"%@", self.tName);
//    self.tAnalysis = [eco objectForKey:@"sourceNote"];
//    NSLog(@"%@", self.tAnalysis);
//    
//    //Infrastructure
//    NSDictionary *infras = [topicArray objectAtIndex:1];
//    NSLog(@"%@", infras);
//    self.tName = [infras objectForKey:@"value"];
//    NSLog(@"%@", self.tName);
//    self.tAnalysis = [infras objectForKey:@"sourceNote"];
//    NSLog(@"%@", self.tAnalysis);
//    
//    
//    //Private Sector
//    NSDictionary *priv = [topicArray objectAtIndex:2];
//    NSLog(@"%@", priv);
//    self.tName = [priv objectForKey:@"value"];
//    NSLog(@"%@", self.tName);
//    self.tAnalysis = [priv objectForKey:@"sourceNote"];
//    NSLog(@"%@", self.tAnalysis);
//    
//    //Sci and Tech
//    NSDictionary *sciTec = [topicArray objectAtIndex:3];
//    NSLog(@"%@", sciTec);
//    self.tName = [sciTec objectForKey:@"value"];
//    NSLog(@"%@", self.tName);
//    self.tAnalysis = [sciTec objectForKey:@"sourceNote"];
//    NSLog(@"%@", self.tAnalysis);
    
    AnalysisData *data = [[AnalysisData alloc] init];
    data.name = self.tName;
    data.analysis = self.tAnalysis;
    
    [self.searchResults addObject:data];
    
    [self.tableView reloadData];
    }
}


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
    return 225.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
    
    if (self.searchResults != nil) {
        AnalysisData *data = self.searchResults[indexPath.row];
        cell.topicName.text = data.name;
        cell.topicAnalysis.text = data.analysis; 
    }
    return cell;
}
/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
