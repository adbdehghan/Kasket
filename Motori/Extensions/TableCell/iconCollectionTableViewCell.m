//
//  iconCollectionTableViewCell.m
//  2x2
//
//  Created by aDb on 3/9/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import "iconCollectionTableViewCell.h"

@implementation iconCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
   layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    //layout.itemSize = CGSizeMake(90, 101);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
   // self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
   // [self.contentView addSubview:self.collectionView];
    
    return self;
}

-(void)layoutSubviews
{
    
    [self.collectionView.collectionViewLayout invalidateLayout];
//    [super layoutSubviews];
//    
//    self.collectionView.frame = self.contentView.bounds;
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.tag = index;
    
    [self.collectionView reloadData];
}

@end
