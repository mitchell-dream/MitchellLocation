//
//  MitchellDataSource.m
//  轻量级tableView
//
//  Created by MENGCHEN on 15-5-26.
//  Copyright (c) 2015年 Mcking. All rights reserved.
//

#import "MitchellDataSource.h"
@interface MitchellDataSource ()
@property (nonatomic,strong) NSArray *itemsArr;
@property (nonatomic,strong) NSArray *cellIdentifierArr;
@property (nonatomic,strong) NSArray *headerTittleArr;
@property (nonatomic,strong) NSArray *footerTittleArr;
@property (nonatomic,assign) int     sectionNumber;
@property (nonatomic,assign) BOOL    ifEdit;
@property(nonatomic,strong)MitchellDataSourceBlock dataSourceBlock;
@end
@implementation MitchellDataSource
-(instancetype)init{
    return nil;
}

#pragma mark ------------------ 创建方法 ------------------
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
-(id)initWithItems:(NSArray *)Items cellIdentifierArr:(NSArray *)cellIdentifierArr WithNumberOfSection:(int)numberOfSection WithTitlesOfHeader:(NSArray *)headerArr WithTitlesOfFooter:(NSArray *)footerArr WithIfCanEditRow:(BOOL)ifEdit configMithcellBlock:(MitchellDataSourceBlock)MitchellBlock{
    self = [super init];
    if (self) {
        self.itemsArr          = Items;
        self.headerTittleArr   = headerArr;
        self.footerTittleArr   = footerArr;
        self.sectionNumber     = numberOfSection;
        self.cellIdentifierArr = cellIdentifierArr;
        self.ifEdit            = ifEdit;
        self.dataSourceBlock   = [MitchellBlock copy];
    }
    return self;
}
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/




#pragma mark ------------------ 返回每行(row)数据源 ------------------
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
-(id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.itemsArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/



#pragma mark ------------------ tableViewDataSource ------------------
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionNumber;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_itemsArr objectAtIndex:section] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*cellIdentifier = [self.cellIdentifierArr objectAtIndex:indexPath.section];
    UITableViewCell*cell    = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    id item                 = [self itemAtIndexPath:indexPath];
    self.dataSourceBlock(cell,item,cellIdentifier);
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_headerTittleArr objectAtIndex:section];
}


-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [_footerTittleArr objectAtIndex:section];
}

//row是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.ifEdit;
}

//点击编辑按钮回调
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        if (self.deleteRowBlock) {
            self.deleteRowBlock(indexPath.section,indexPath.row);
        }
        
    }
}
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/


@end
