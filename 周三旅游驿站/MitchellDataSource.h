//
//  MitchellDataSource.h
//  轻量级tableView
//
//  Created by MENGCHEN on 15-5-26.
//  Copyright (c) 2015年 Mcking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef  void (^MitchellDataSourceBlock)(id cellArr,id items,id Identifier);
typedef  void (^MitchellDeleteRowAtSectionAndRow)(int section,int row);
@interface MitchellDataSource : NSObject<UITableViewDataSource>
@property(nonatomic,strong)MitchellDeleteRowAtSectionAndRow deleteRowBlock;
/**
 *  创建tableView
 *
 *  @param Items             数据源
 *  @param cellIdentifierArr cell标识符数组
 *  @param numberOfSection   section个数
 *  @param headerArr         header标题数据源
 *  @param footerArr         footer标题数据源
 *  @param ifEdit            row是否可以修改
 *  @param MitchellBlock     回传Block
 *
 */
- (id)initWithItems:(NSArray*)Items
  cellIdentifierArr:(NSArray*)cellIdentifierArr
WithNumberOfSection:(int)numberOfSection
 WithTitlesOfHeader:(NSArray*)headerArr
 WithTitlesOfFooter:(NSArray*)footerArr
   WithIfCanEditRow:(BOOL)ifEdit
configMithcellBlock:(MitchellDataSourceBlock)MitchellBlock;

/**
 *  每一行所对应的数据
 */
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;





@end
