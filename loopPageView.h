//
//  loopPageView.h
//  xunhuan
//
//  Created by 韩金波 on 15/6/30.
//  Copyright (c) 2015年 韩金波-psylife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loopPageView : UIView
@property (nonatomic ,strong)NSArray *imageNames;
/**
 *  是否垂直显示
 */
@property (nonatomic,assign) BOOL isPortrait;
@end
