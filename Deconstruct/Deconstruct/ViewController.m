//
//  ViewController.m
//  Deconstruct
//
//  Created by C4Q on 2/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import "ViewController.h"
#import "WhirlyGlobeMaplyComponent/WhirlyGlobeComponent.h"
#import "DataExtract.h"

@interface ViewController ()
- (void) addCountries;
////NPR ARTICLE
//- (void)addAnnotation:(ArticleScreenMarker*)theMarker at:(MaplyCoordinate)coord;
//TO GET COORDINATES
- (void)addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at:(MaplyCoordinate)coord;
- (void) addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at: (MaplyCoordinate)coord;

//coordinate properties
@property(nonatomic)double latitude;
@property(nonatomic)double longitude;
@end

@implementation ViewController{
    MaplyBaseViewController *theViewC;      // screen
    WhirlyGlobeViewController *globeViewC;  // the globe
    MaplyViewController *mapViewC;          // not used, only used in 2D
    NSDictionary *vectorDict;               // outlines for the countries
    NSDictionary *inputData;
    NSMutableArray *markerList;
}

// Set this to false for a map
const bool DoGlobe = true;                  // for 3d globe
DataExtract *extractor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (DoGlobe)
    {
        globeViewC = [[WhirlyGlobeViewController alloc] init];
        theViewC = globeViewC;
    } else {
        mapViewC = [[MaplyViewController alloc] init];
        theViewC = mapViewC;
    }
    
    // If you're doing a globe
    if (globeViewC != nil)
        globeViewC.delegate = self;
    
    // If you're doing a map
    if (mapViewC != nil)
        mapViewC.delegate = self;
    
    // Create an empty globe or map and add it to the view
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];     // ???
    
    // we want a black background for a globe, a white background for a map.
    theViewC.clearColor = (globeViewC != nil) ? [UIColor blackColor] : [UIColor whiteColor];
    
    // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
    theViewC.frameInterval = 1;
    
    // add the capability to use the local tiles or remote tiles
    bool useLocalTiles = false;
    
    // we'll need this layer in a second
    MaplyQuadImageTilesLayer *layer;
    
    if (useLocalTiles)
    {
        MaplyMBTileSource *tileSource =
        [[MaplyMBTileSource alloc] initWithMBTiles:@"geography­-class_medres"];
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    } else {
        // Because this is a remote tile set, we'll want a cache directory
        NSString *baseCacheDir =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
         objectAtIndex:0];
        NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/osmtiles/",
                                         baseCacheDir];
        int maxZoom = 18;
        
        // MapQuest Open Aerial Tiles, Courtesy Of Mapquest
        // Portions Courtesy NASA/JPL­Caltech and U.S. Depart. of Agriculture, Farm Service Agency
        MaplyRemoteTileSource *tileSource =
        [[MaplyRemoteTileSource alloc]
         initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/"
         ext:@"png" minZoom:0 maxZoom:maxZoom];
        tileSource.cacheDir = aerialTilesCacheDir;
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    }
    
    layer.handleEdges = (globeViewC != nil);
    layer.coverPoles = (globeViewC != nil);
    layer.requireElev = false;
    layer.waitLoad = false;                     // ???
    layer.drawPriority = 0;
    layer.singleLevelLoading = false;
    [theViewC addLayer:layer];
    
    // start up over San Francisco
    // dealing with animations
    if (globeViewC != nil)
    {
        globeViewC.height = 0.8;
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                                 time:1.0];
        [globeViewC setZoomLimitsMin:0.1f max:1.6f];
        [globeViewC setAutoRotateInterval:10.0f degrees:4.0f];
    } else {
        mapViewC.height = 1.0;
        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                               time:1.0];
    }
    
    // set the vector characteristics to be pretty and selectable
    vectorDict = @{
                   kMaplyColor: [UIColor whiteColor],
                   kMaplySelectable: @(true),
                   kMaplyVecWidth: @(4.0)};
    
    // add the countries
        [self addCountries];
    
//    [self fetchData:nil];
//    [NSTimer scheduledTimerWithTimeInterval:30.0
//                                     target:self
//                                   selector:@selector(fetchData:)
//                                   userInfo:nil
//                                    repeats:YES];
//    
//    extractor = [[DataExtract alloc] init];
//    
//    // add the beacons
//    [self addNewsBeacons];
}

- (void) addNewsBeacons
{
    markerList = [[NSMutableArray alloc] init];
    UIImage *icon = [UIImage imageNamed:@"circle-stroked-24@2x.png"];
    
    for (NSDictionary *article in extractor.articleList) {
        ArticleScreenMarker *marker = [[ArticleScreenMarker alloc] initWithDictionary:article];
        marker.info.title = [article objectForKey:@"title"];
        marker.info.subTitle = [article objectForKey:@"location"];
        
        marker.image = icon;
        double latitude = [[article objectForKey:@"coordinates"][1] doubleValue];
        double longitude = [[article objectForKey:@"coordinates"][0] doubleValue];
        marker.loc = MaplyCoordinateMakeWithDegrees(latitude, longitude);
        marker.size = CGSizeMake(40,40);
        
        [markerList addObject:marker];
    }
    
    [theViewC addScreenMarkers:markerList desc:nil];
}

- (void)fetchData:(NSTimer*) timer  {
    NSURL *url = [NSURL URLWithString:@"http://104.236.54.3/data.json"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   [theViewC removeObjects:markerList];
                                   [extractor openJSON:data];
//                                   [self addNewsBeacons];
                               }
                           }];
    
    //    NSURLSession *session = [[NSURLSession alloc] init];
    //    [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse *response, NSError *error){
    //                   if (!error) {
    //                       NSLog(@"i fetched");
    //                       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    //                       [data writeToFile:filePath atomically:NO];
    //                       // [theViewC ] clear all the beacons
    //                       [self addNewsBeacons];
    //                   }
    //               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCountries
{
    // handle this in another thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
                   ^{
                       NSArray *allOutlines = [[NSBundle mainBundle] pathsForResourcesOfType:@"geojson" inDirectory:nil];
                       
                       for (NSString *outlineFile in allOutlines)
                       {
                           NSData *jsonData = [NSData dataWithContentsOfFile:outlineFile];
                           if (jsonData)
                           {
                               MaplyVectorObject *wgVecObj = [MaplyVectorObject VectorObjectFromGeoJSON:jsonData];
                               
                               // the admin tag from the country outline geojson has the country name ­ save
                               NSString *vecName = [[wgVecObj attributes] objectForKey:@"ADMIN"];
                               wgVecObj.userObject = vecName;
                               
                               // add the outline to our view
                               MaplyComponentObject *compObj = [theViewC addVectors:[NSArray arrayWithObject:wgVecObj] desc:vectorDict];
                               // If you ever intend to remove these, keep track of the MaplyComponentObjects above.
                               
                               // Add a screen label per country
                               if ([vecName length] > 0)
                               {
                                   MaplyScreenLabel *label = [[MaplyScreenLabel alloc] init];
                                   label.text = vecName;
                                   label.loc = [wgVecObj center];
                                   label.selectable = true;
                                   [theViewC addScreenLabels:@[label] desc:
                                    @{
                                      kMaplyFont: [UIFont boldSystemFontOfSize:24.0],
                                      kMaplyTextOutlineColor: [UIColor blackColor],
                                      kMaplyTextOutlineSize: @(2.0),
                                      kMaplyColor: [UIColor whiteColor]
                                      }];
                               }
                           }
                       }
                   });
}

//NPR Articles
//- (void)addAnnotation:(ArticleScreenMarker*)theMarker at:(MaplyCoordinate)coord
//{
//    [theViewC clearAnnotations];
//    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
//    AnnotationView *infoPane = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView"
//                                                              owner:self
//                                                            options:nil]
//                                objectAtIndex:0];
//    [infoPane setFrame:CGRectMake(0, 0, infoPane.frame.size.width, infoPane.frame.size.height)];
//    [self.view addSubview:infoPane];
//    
//    infoPane.title.text = theMarker.info.title;
//    infoPane.snippet.text = [theMarker.articleInfo objectForKey:@"snippet"];
//    infoPane.location.text = theMarker.info.subTitle;
//    infoPane.publisherImage.image = [UIImage imageNamed:@"AP Icon.png"];
//    NSString *url =[[theMarker articleInfo] objectForKey:@"url"];
//    infoPane.url = [NSURL URLWithString:url];
//    
//    annotation.contentView = infoPane;
//    
//    [theViewC addAnnotation:annotation forPoint:coord offset:CGPointZero];
//}
-(void)addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at:(MaplyCoordinate)coord
{
    [theViewC clearAnnotations];
    
    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
    annotation.title = title;
    annotation.subTitle = subtitle;
    [theViewC addAnnotation:annotation forPoint:coord offset:CGPointZero];
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC
                   didTapAt:(MaplyCoordinate)coord
{
    NSString *title = @"Tap Location:";
    NSString *subtitle = [NSString stringWithFormat:@"(%.2fN, %.2fE)",
                          coord.y*57.296,coord.x*57.296];
    //lat and long for geocoding
    
    NSString *latString = [NSString stringWithFormat:@"%.2fN", coord.y*57.296];
    
    NSString *longString = [NSString stringWithFormat:@"%.2fE", coord.x*57.296];
    
    self.latitude = [latString doubleValue];
    
    self.longitude = [longString doubleValue];
    
    
    //geocoding for country name and isocode
    [self geoCoding];
    
    NSLog(@"%@", subtitle);
    
    NSLog(@"%f", self.latitude);
    
    NSLog(@"%f", self.longitude);
    [self addAnnotation:title withSubtitle:subtitle at:coord];
    
    [theViewC clearAnnotations];
}

-(void)geoCoding {
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    //CLLocation *loc = [[CLLocation alloc]initWithLatitude:48.41 longitude:21.322]; insert your coordinates
    
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark %@",placemark);
        
        //String to hold address
        
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//        
//        NSLog(@"addressDictionary %@", placemark.addressDictionary);
        
        NSLog(@"placemark %@",placemark.region);
        
        NSLog(@"placemark %@",placemark.country);  // Give Country Name
        
        NSLog(@"placemark %@",placemark.locality); // Extract the city name
        
        NSLog(@"location %@",placemark.name);
        
        NSLog(@"ISOcountryCode %@",placemark.ISOcountryCode);
//        
//        NSLog(@"location %@",placemark.ocean);
//        
//        NSLog(@"location %@",placemark.postalCode);
//        
//        NSLog(@"location %@",placemark.subLocality);
        
    }];
    
}

//- (void)maplyViewController:(MaplyViewController *)viewC
//                   didTapAt:(MaplyCoordinate)coord
//{
//    NSString *title = @"Tap Location:";
//    NSString *subtitle = [NSString stringWithFormat:@"(%.2fN, %.2fE)",
//                          coord.y*57.296,coord.x*57.296];
//    [self addAnnotation:title withSubtitle:subtitle at:coord];
//}

// Unified method to handle the selection
- (void) handleSelection:(MaplyBaseViewController *)viewC
                selected:(NSObject *)selectedObj
{
    // ensure it's a MaplyVectorObject. It should be one of our outlines.
    //        if ([selectedObj isKindOfClass:[MaplyVectorObject class]])
    //        {
    //            [theViewC clearAnnotations];
    //
    //            MaplyVectorObject *theVector = (MaplyVectorObject *)selectedObj;
    //            MaplyCoordinate location;
    //
    //            if ([theVector centroid:&location])
    //            {
    //                NSString *title = @"Selected:";
    //                NSString *subtitle = (NSString *)theVector.userObject;
    //                [self addAnnotation:title withSubtitle:subtitle at:location];
    //
    //            }
    //        } else
//    if ([selectedObj isKindOfClass:[ArticleScreenMarker class]])
//    {
//        // or it might be a screen marker
//        ArticleScreenMarker *theMarker = (ArticleScreenMarker *)selectedObj;
//        [self addAnnotation:theMarker at:theMarker.loc];
//    }
}

// This is the version for a globe
- (void) globeViewController:(WhirlyGlobeViewController *)viewC
                   didSelect:(NSObject *)selectedObj
{
    [self handleSelection:viewC selected:selectedObj];
}

// This is the version for a map
- (void) maplyViewController:(MaplyViewController *)viewC
                   didSelect:(NSObject *)selectedObj
{
    [self handleSelection:viewC selected:selectedObj];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}





@end
