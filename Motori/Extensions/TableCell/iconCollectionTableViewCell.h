//
//  iconCollectionTableViewCell.h
//  2x2
//
//  Created by aDb on 3/9/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *CollectionViewCellIdentifier = @"iconCell";
@interface iconCollectionTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
@end
