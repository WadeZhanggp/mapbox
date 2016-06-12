//
//  MapBoxView.m
//  MapBox3
//
//  Created by 张光鹏 on 16/6/6.
//  Copyright © 2016年 Tsinova. All rights reserved.
//

#import "MapBoxView.h"
#import <Mapbox/Mapbox.h>

@interface MapBoxView()<MGLMapViewDelegate>{
}

@property (nonatomic, strong) MGLMapView *mapView;

@property (nonatomic, strong) MGLPolyline *polyline;

@end

@implementation MapBoxView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.frame];
    [self addSubview:_mapView];
    
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;//设置定位
    
    [self setOregonLatitude:22.301935 andLongitude:114.176682 withZoomLevel:14];

    //[self.mapView setShowsUserLocation:YES];
    [self setMapStyleURLWith:3];
    
    UIButton *addPolylineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    addPolylineButton.backgroundColor = [UIColor redColor];
    [addPolylineButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addPolylineButton];
    
    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 50, 50)];
    removeButton.backgroundColor = [UIColor greenColor];
    [removeButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeButton];
}

- (void)buttonAction{
    NSDictionary *hike = [NSJSONSerialization JSONObjectWithData:
                          [NSData dataWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"polyline" ofType:@"geojson"]]
                                                         options:0
                                                           error:nil];
    
    NSArray *hikeCoordinatePairs = hike[@"features"][0][@"geometry"][@"coordinates"];
    NSLog(@"数组 = %@",hikeCoordinatePairs);
    
    hikeCoordinatePairs = @[@[@"114.163284",@"22.282158"],@[@"114.164169",@"22.28174"],@[@"114.164268",@"22.281519"],@[@"114.165207",@"22.283033"],@[@"114.173714",@"22.291084"],@[@"114.177124",@"22.295395"],@[@"114.176804",@"22.299904"],@[@"114.176682",@"22.301935"]];
    
    CLLocationCoordinate2D *polylineCoordinates = (CLLocationCoordinate2D *)malloc([hikeCoordinatePairs count] * sizeof(CLLocationCoordinate2D));
    
    for (NSUInteger i = 0; i < [hikeCoordinatePairs count]; i++)
    {
        polylineCoordinates[i] = CLLocationCoordinate2DMake([hikeCoordinatePairs[i][1] doubleValue], [hikeCoordinatePairs[i][0] doubleValue]);
    }
    
    if (!self.polyline) {
        self.polyline = [MGLPolyline polylineWithCoordinates:polylineCoordinates
                                                       count:[hikeCoordinatePairs count]];
    }
    
    [self.mapView addAnnotation:self.polyline];
    
    free(polylineCoordinates);
    
    // PA/NJ/DE polys
    //
    NSDictionary *threestates = [NSJSONSerialization JSONObjectWithData:
                                 [NSData dataWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"threestates" ofType:@"geojson"]]
                                                                options:0
                                                                  error:nil];
    
    for (NSDictionary *feature in threestates[@"features"])
    {
        NSArray *stateCoordinatePairs = feature[@"geometry"][@"coordinates"];
        
        while ([stateCoordinatePairs count] == 1) stateCoordinatePairs = stateCoordinatePairs[0];
        
        CLLocationCoordinate2D *polygonCoordinates = (CLLocationCoordinate2D *)malloc([stateCoordinatePairs count] * sizeof(CLLocationCoordinate2D));
        
        for (NSUInteger i = 0; i < [stateCoordinatePairs count]; i++)
        {
            polygonCoordinates[i] = CLLocationCoordinate2DMake([stateCoordinatePairs[i][1] doubleValue], [stateCoordinatePairs[i][0] doubleValue]);
        }
        
        MGLPolygon *polygon = [MGLPolygon polygonWithCoordinates:polygonCoordinates count:[stateCoordinatePairs count]];
        
        [self.mapView addAnnotation:polygon];
        
        free(polygonCoordinates);
    }

}

- (void)removeAction{
    if (self.polyline) {
        [self.mapView removeOverlay:self.polyline];
    }
}

//
- (void)setOregonLatitude:(float)lat andLongitude:(float)lon withZoomLevel:(float)level{
    
    [self.mapView setLatitude:lat];
    [self.mapView setLongitude:lon];
    [self.mapView setZoomLevel:level];
}

- (void)setMapStyleURLWith:(NSInteger)style{
    
    NSString *urlString;
    switch (style) {
        case 0:
            urlString = @"mapbox://styles/mapbox/streets-v9";
            break;
            
        case 1:
            urlString = @"mapbox://styles/mapbox/outdoors-v9";
            break;
            
        case 2:
            urlString = @"mapbox://styles/mapbox/light-v9";
            break;
            
        case 3:
            urlString = @"mapbox://styles/mapbox/dark-v9";
            break;
            
        case 4:
            urlString = @"mapbox://styles/mapbox/satellite-v9";
            break;
            
        case 5:
            urlString = @"mapbox://styles/mapbox/satellite-streets-v9";
            break;
            
        default:
            break;
    }
    [self.mapView setStyleURL:[NSURL URLWithString:urlString]];
}

#pragma mark ----代理方法
- (void)mapViewWillStartLoadingMap:(MGLMapView *)mapView{
    NSLog(@"开始定位");
}

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation{
    
    //[self setOregonLatitude:userLocation.coordinate.latitude andLongitude:userLocation.coordinate.longitude withZoomLevel:14];
    
}

@end
