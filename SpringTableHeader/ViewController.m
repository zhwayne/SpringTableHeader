//
//  ViewController.m
//  SpringTableHeader
//
//  Created by Wayne on 2018/6/14.
//  Copyright © 2018年 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "SpringTableHeaderView.h"

@interface ViewController () <UITableViewDataSource, SpringTableHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1"
                                                                                    ofType:@"jpeg"]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    SpringTableHeaderView *header = [SpringTableHeaderView new];
    header.contentView = imgView;
    header.delegate = self;
    header.intrinsicContentHeight = 200;
    
    [self.tableView setTableHeaderView:header];
}


- (void)headerView:(SpringTableHeaderView *)headView didScaled:(CGFloat)scale
{
    CGFloat alpha = 1 - MIN(scale, 1);
    self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:alpha];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}


@end
