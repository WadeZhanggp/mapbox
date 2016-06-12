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

@end
