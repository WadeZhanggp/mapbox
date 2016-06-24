//
//  MapBoxView.h
//  MapBox3
//
//  Created by 张光鹏 on 16/6/6.
//  Copyright © 2016年 Tsinova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapBoxView : UIView

/*!
 设置原点经纬度和比例尺
 */
- (void)setOregonLatitude:(float)lat andLongitude:(float)lon withZoomLevel:(float)level;

/*
 设置地图风格
 */
- (void)setMapStyleURLWith:(NSInteger)style;

/*!
 加入路线轨迹
 */
- (void)addRouteLineWith:(NSArray *)routeArray;

/*!
 高德地图路径数组转成mapbox路径数组
 */
-(NSArray *)mapboxArrayTransformWith:(NSArray *)gaodeArray;

@end
