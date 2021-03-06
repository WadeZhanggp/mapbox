//
//  MapBoxView.m
//  MapBox3
//
//  Created by 张光鹏 on 16/6/6.
//  Copyright © 2016年 Tsinova. All rights reserved.
//

#import "MapBoxView.h"
#import <Mapbox/Mapbox.h>


#import <Mapbox/MGLMapView+MGLCustomStyleLayerAdditions.h>

@interface MapBoxView()<MGLMapViewDelegate>{
}

@property (nonatomic, strong) MGLMapView *mapView;

@property (nonatomic, strong) MGLPolyline *polyline;

@property (nonatomic, strong) MGLPointAnnotation *startPoint;

@property (nonatomic, strong) MGLPointAnnotation *endPoint;

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

#pragma mark ----Private methods
- (void)layoutUI{
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.frame];
    [self addSubview:_mapView];
    
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;//设置定位
    //116.426162,39.928631
    [self setOregonLatitude:39.928631 andLongitude:116.426162 withZoomLevel:14];

    //[self.mapView setShowsUserLocation:YES];
    [self setMapStyleURLWith:3];
    
    UIButton *addPolylineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, 50, 50)];
    addPolylineButton.backgroundColor = [UIColor redColor];
    addPolylineButton.layer.cornerRadius = 5;
    [addPolylineButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addPolylineButton];
    
    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, self.frame.size.height - 50, 50, 50)];
    removeButton.backgroundColor = [UIColor greenColor];
    removeButton.layer.cornerRadius = 5;
    [removeButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeButton];
}

- (void)buttonAction{
    [self addRouteLineWith:@[@[@"114.163284",@"22.282158"],@[@"114.164169",@"22.28174"],@[@"114.164268",@"22.281519"],@[@"114.165207",@"22.283033"],@[@"114.173714",@"22.291084"],@[@"114.177124",@"22.295395"],@[@"114.176804",@"22.299904"],@[@"114.176682",@"22.301935"]]];
}

- (void)removeAction{
    if (self.polyline) {
        [self.mapView removeOverlay:self.polyline];
        self.polyline = nil;
    }
    
    if (self.startPoint) {
        [self.mapView removeAnnotation:self.startPoint];
        self.startPoint = nil;
    }
    
    if (self.endPoint) {
        [self.mapView removeAnnotation:self.endPoint];
        self.endPoint = nil;
    }
}

#pragma mark ----Public methods

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

- (void)addRouteLineWith:(NSArray *)routeArray{
    
    NSArray *hikeCoordinatePairs;
    
//    hikeCoordinatePairs = @[@[@"114.163284",@"22.282158"],@[@"114.164169",@"22.28174"],@[@"114.164268",@"22.281519"],@[@"114.165207",@"22.283033"],@[@"114.173714",@"22.291084"],@[@"114.177124",@"22.295395"],@[@"114.176804",@"22.299904"],@[@"114.176682",@"22.301935"]];
//    NSLog(@"标准数据 = %@",hikeCoordinatePairs);
    
    //NSArray *gaodeArray = @[@"114.163284,22.282158",@"114.164169,22.28174",@"114.164268,22.281519",@"114.165207,22.283033",@"114.177124,22.295395",@"114.176804,22.299904",@"114.176682,22.301935"];
    NSArray *gaodeArray = @[@"116.413459,39.909865",@"116.426162,39.928631",@"116.41465,39.936531",@"116.403063,39.936928",@"116.386583,39.936665",@"116.375597,39.94364"];
    
    hikeCoordinatePairs = [self mapboxArrayTransformWith:gaodeArray];
    NSLog(@"%@",hikeCoordinatePairs);
    
    CLLocationCoordinate2D *polylineCoordinates = (CLLocationCoordinate2D *)malloc([hikeCoordinatePairs count] * sizeof(CLLocationCoordinate2D));
    
    for (NSUInteger i = 0; i < [hikeCoordinatePairs count]; i++)
    {
        polylineCoordinates[i] = CLLocationCoordinate2DMake([hikeCoordinatePairs[i][1] doubleValue], [hikeCoordinatePairs[i][0] doubleValue]);
    }
    
    if (!self.polyline) {
        self.polyline = [MGLPolyline polylineWithCoordinates:polylineCoordinates
                                                       count:[hikeCoordinatePairs count]];
        
        NSMutableArray *annotations = [NSMutableArray array];
        self.startPoint = [MGLPointAnnotation new];
        self.startPoint.coordinate = polylineCoordinates[0];
        self.startPoint.title = @"起点";
        self.startPoint.subtitle = @"起点";
//        MGLAnnotation *a;
        //[self.mapView addAnnotation:self.startPoint];
        
        self.endPoint = [MGLPointAnnotation new];
        self.endPoint.coordinate = polylineCoordinates[[hikeCoordinatePairs count]-1];
        self.endPoint.title = @"终点";
        //[self.mapView addAnnotation:self.endPoint];
        [annotations addObject:self.startPoint];
        [annotations addObject:self.endPoint];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //[self.mapView addAnnotations:annotations];
                           //[self.mapView showAnnotations:annotations animated:YES];
                       });
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((polylineCoordinates[0].latitude + polylineCoordinates[[hikeCoordinatePairs count]-1].latitude)/2, (polylineCoordinates[0].longitude + polylineCoordinates[[hikeCoordinatePairs count]-1].longitude)/2);
        [self setOregonLatitude:center.latitude andLongitude:center.longitude withZoomLevel:12];
        [self.mapView addAnnotation:self.polyline];
    }
    
    free(polylineCoordinates);
    
    
    
}

- (NSArray *)mapboxArrayTransformWith:(NSArray *)gaodeArray{
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSString *subString in gaodeArray) {
         NSArray *pointArray = [subString componentsSeparatedByString:@","];
        [returnArray addObject:pointArray];
    }
    NSLog(@"返回数据 = %@",returnArray);
    return (NSArray *)returnArray;
    
}

#pragma mark ----代理方法
- (void)mapViewWillStartLoadingMap:(MGLMapView *)mapView{
    NSLog(@"开始定位");
}

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation{
    
    //[self setOregonLatitude:userLocation.coordinate.latitude andLongitude:userLocation.coordinate.longitude withZoomLevel:14];
    
}

-(MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation{
    
    MGLAnnotationImage *annotationImage = [[MGLAnnotationImage alloc] init];
    annotationImage.image = [UIImage imageNamed:@"navigation_begin"];
    return annotationImage;
    
}

@end
