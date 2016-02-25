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
- (void)addAnnotation:(ArticleScreenMarker*)theMarker at:(MaplyCoordinate)coord;
//TO GET COORDINATES
- (void)addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at:(MaplyCoordinate)coord;
- (void) addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at: (MaplyCoordinate)coord;

//coordinate properties
@property(nonatomic)ArticleScreenMarker *marker;
@property(nonatomic)double latitude;
@property(nonatomic)double longitude;
@property(nonatomic)CLPlacemark *placemark;

//country properties
@property(nonatomic)NSString *totalPop;
@property(nonatomic)NSString *surfacear;
@property(nonatomic)NSString *gdp;
@property(nonatomic)NSString *timeReq;
@property(nonatomic)NSString *fdi;
@property(nonatomic)NSString *urbPop;
@end

@implementation ViewController{
    MaplyBaseViewController *theViewC;      // screen
    WhirlyGlobeViewController *globeViewC;  // the globe
    MaplyViewController *mapViewC;          // not used, only used in 2D
    NSDictionary *vectorDict;               // outlines for the countries
    NSDictionary *inputData;
    NSMutableArray *markerList;
    NSDictionary *indicateForMe;
}

// Set this to false for a map
const bool DoGlobe = true;                  // for 3d globe
DataExtract *extractor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"At a Glance";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    
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

//    // add the beacons
 // [self addNewsBeacons];
}

//- (void) addNewsBeacons
//{
//    
//    for (NSDictionary *countryInd in extractor.indicatorList) {
//        self.marker = [[ArticleScreenMarker alloc] initWithDictionary:countryInd];
//        //EXAMPLE
////        NSDictionary *thumbnail = [images objectForKey:@"thumbnail"];
////        
////        NSString *urlString = [thumbnail objectForKey:@"url"];
//        //FIRSTVAL
////        NSString *firstValue = [[countryInd objectForKey:@"value"]objectAtIndex:0];
////        NSLog(@"%@", firstValue);
//        //Country Pop
//        //NSString *countryPop = [countryInd objectForKey:@"value"];
////        NSLog(@"%@", countryPop);
//        
//        
//        
//        
//        
//        //new app methods
////        marker.info.title = [countryInd objectForKey:@"indicator" o];
////        marker.info.subTitle = [article objectForKey:@"location"];
////        
////        marker.image = icon;
////        marker.loc = MaplyCoordinateMakeWithDegrees(self.latitude, self.longitude);
////        marker.size = CGSizeMake(40,40);
////        
////        [markerList addObject:marker];
//    }
//    
//    //[theViewC addScreenMarkers:markerList desc:nil];
//}


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


//-(void)addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at:(MaplyCoordinate)coord
//{
//    [theViewC clearAnnotations];
//    
//    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
//    annotation.title = title;
//    annotation.subTitle = subtitle;
//    [theViewC addAnnotation:annotation forPoint:coord offset:CGPointZero];
//}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC
                   didTapAt:(MaplyCoordinate)coord
{
    [viewC clearAnnotations];
    markerList = [[NSMutableArray alloc] init];
    UIImage *icon = [UIImage imageNamed:@"map_pin.png"];
    
    
    self.marker = [[ArticleScreenMarker alloc] init];
    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
    AnnotationView *infoPane = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView"
                                                              owner:self
                                                            options:nil]
                                objectAtIndex:0];
    [infoPane setFrame:CGRectMake(0, 0, infoPane.frame.size.width, infoPane.frame.size.height)];
    [self.view addSubview:infoPane];
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
    
   // NSLog(@"%@", subtitle);
    
    NSLog(@"%f", self.latitude);
    
    NSLog(@"%f", self.longitude);
    
    
    //Adding country indicators
       annotation.contentView = infoPane;
    infoPane.countryName.text = self.placemark.country;
    infoPane.totalPop.text = [NSString stringWithFormat:@"Total Population: %@",self.totalPop];
    infoPane.surfaceArea.text = [NSString stringWithFormat:@"Surface Area: %@",self.surfacear];
    infoPane.gDP.text = [NSString stringWithFormat:@"GDP: %@",self.gdp];
    infoPane.fDI.text = [NSString stringWithFormat:@"FDI: %@",self.fdi];
    infoPane.timeReqBus.text = [NSString stringWithFormat:@"Time Required to Start: %@",self.timeReq];
    
    
    //[viewC addAnnotation:title withSubtitle:subtitle at:coord];
    
    self.marker.image = icon;
    self.marker.loc = MaplyCoordinateMakeWithDegrees(self.latitude, self.longitude);
    self.marker.size = CGSizeMake(40,40);
   
    
   
    //[theViewC addScreenMarkers:self.marker.loc desc:nil];
   [markerList addObject:self.marker];
//
//
  [theViewC addScreenMarkers:markerList desc:nil];
    
    [theViewC addAnnotation:annotation forPoint:coord offset:CGPointZero];

    
}

-(void)geoCoding {
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    //CLLocation *loc = [[CLLocation alloc]initWithLatitude:48.41 longitude:21.322]; insert your coordinates
    
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        self.placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark %@",self.placemark);
        
        //String to hold address
        
        NSString *locatedAt = [[self.placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//        
//        NSLog(@"addressDictionary %@", self.placemark.addressDictionary);
        
        NSLog(@"placemark %@",self.placemark.region);
        
        NSLog(@"placemark %@",self.placemark.country);  // Give Country Name
        
        NSLog(@"placemark %@",self.placemark.locality); // Extract the city name
        
        NSLog(@"location %@",self.placemark.name);
        
        NSLog(@"ISOcountryCode %@",self.placemark.ISOcountryCode);
//        
//        NSLog(@"location %@",self.placemark.ocean);
//        
//        NSLog(@"location %@",self.placemark.postalCode);
//        
//        NSLog(@"location %@",self.placemark.subLocality);
        [self fetchData:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(fetchData:)
                                       userInfo:nil
                                        repeats:YES];
    }];
    
}


// INDICATORS WORK!!!!
- (void)fetchData:(NSTimer*) timer  {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.worldbank.org/country/%@/indicator/sp.pop.totl;ag.srf.totl.k2;ny.gdp.mktp.cd;ic.reg.durs;bx.klt.dinv.wd.gd.zs;sp.urb.grow?date=2014&source=2&per_page=1000&format=json",self.placemark.ISOcountryCode]];
    //self.placemark.ISOcountryCode
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    
    
    
    // NSError *jsonParsingError = nil;
    NSArray *country = [[NSJSONSerialization JSONObjectWithData:response
                                                        options:0 error:nil]objectAtIndex:1];
    
    NSLog(@"%@", country);
    
    
    AnnotationView *infoPane = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView"
                                                              owner:self
                                                            options:nil]objectAtIndex:0];
    
    //TOTAL POP
    NSDictionary *pop = [country objectAtIndex:0];
    NSLog(@"%@", pop);
   self.totalPop = [pop objectForKey:@"value"];
//    NSLog(@"%@", self.totalPop);
    infoPane.totalPop.text = self.totalPop;
    
    //surface area
    NSDictionary *sur = [country objectAtIndex:1];
    NSLog(@"%@", sur);
    self.surfacear = [sur objectForKey:@"value"];
    NSLog(@"%@", self.surfacear);
    infoPane.surfaceArea.text = self.surfacear;
    
    
    //GDP
    NSDictionary *gee = [country objectAtIndex:2];
    NSLog(@"%@", gee);
    self.gdp = [gee objectForKey:@"value"];
    NSLog(@"%@", self.gdp);
    infoPane.gDP.text = self.gdp;
    
    //time req to do business
    NSDictionary *tim = [country objectAtIndex:3];
    NSLog(@"%@", tim);
    self.timeReq = [tim objectForKey:@"value"];
    NSLog(@"%@", self.timeReq);
    infoPane.timeReqBus.text = self.timeReq;
    
    //FDI
    NSDictionary *forD = [country objectAtIndex:4];
    NSLog(@"%@", forD);
    self.fdi = [forD objectForKey:@"value"];
    NSLog(@"%@", self.fdi);
//    NSString *rssiString = [NSString stringWithFormat:@"%@", self.fdi];
    infoPane.fDI.text = self.fdi; 
    
    //urban pop growth
    NSDictionary *urb = [country objectAtIndex:5];
    NSLog(@"%@", urb);
    self.urbPop = [urb objectForKey:@"value"];
    NSLog(@"%@", self.urbPop);
    
   // [self addBlurb];
    
}
//
//-(void)addBlurb {
//   // [theViewC clearAnnotations];
//    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
//    AnnotationView *infoPane = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView"
//                                                              owner:self
//                                                            options:nil]
//                                objectAtIndex:0];
//    [infoPane setFrame:CGRectMake(0, 0, infoPane.frame.size.width, infoPane.frame.size.height)];
//    [self.view addSubview:infoPane];
//    
//    infoPane.countryName.text = self.placemark.country;
//    infoPane.totalPop.text = self.totalPop;
//    infoPane.gDP.text = self.gdp;
//    
//    
//    annotation.contentView = infoPane;
//    
//    //[self addAnnotation:infoPane at:self.marker.loc];
//    [theViewC addAnnotation:annotation forPoint:self.marker.loc offset:CGPointZero];
//}

////Add annotation
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
//    infoPane.countryName.text = self.placemark.country;
//    infoPane.totalPop.text = self.totalPop;
////    infoPane.totalPop.text = [theMarker.indicatorInfo objectForKey:@"snippet"];
////    infoPane.gDP.text = [theMarker.indicatorInfo objectForKey:@"snippet"];
////    infoPane.fDI.text = [theMarker.indicatorInfo objectForKey:@"snippet"];
////    infoPane.timeReqBus.text = [theMarker.indicatorInfo objectForKey:@"snippet"];
////    infoPane.surfaceArea.text = [theMarker.indicatorInfo objectForKey:@"snippet"];
//    //infoPane.countryImage.image = [UIImage imageNamed:@" "];
//   // infoPane.location.text = theMarker.info.subTitle;
//
//    annotation.contentView = infoPane;
//
//    [theViewC addAnnotation:annotation forPoint:self.marker.loc offset:CGPointZero];
//}


// Unified method to handle the selection
- (void) handleSelection:(MaplyBaseViewController *)viewC
                selected:(NSObject *)selectedObj
{
    // ensure it's a MaplyVectorObject. It should be one of our outlines.
    if ([selectedObj isKindOfClass:[MaplyVectorObject class]])
    {
        MaplyVectorObject *theVector = (MaplyVectorObject *)selectedObj;
        MaplyCoordinate location;
        
        if ([theVector centroid:&location])
        {
            NSString *title = @"Selected:";
            NSString *subtitle = (NSString *)theVector.userObject;
            [self addAnnotation:title withSubtitle:subtitle at:location];
        }
    }
}
// Unified method to handle the selection
//- (void) handleSelection:(MaplyBaseViewController *)viewC
//                selected:(NSObject *)selectedObj
//{
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
//        self.marker = (ArticleScreenMarker *)selectedObj;
//    
//        [self addAnnotation:self.marker at:self.marker.loc];
//    }
//   
//}
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
