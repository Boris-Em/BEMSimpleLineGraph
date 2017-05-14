//
//  StatsViewController.m
//  SimpleLineChart
//
//  Created by iRare Media on 1/6/14.
//  Copyright (c) 2014 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.standardDeviationLabel.text = self.standardDeviation;
    self.averageLabel.text = self.average;
    self.medianLabel.text = self.median;
    self.modeLabel.text = self.mode;
    self.maximumLabel.text = self.maximum;
    self.minimumLabel.text = self.minimum;
    self.snapshotImageView.image = self.snapshotImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 8;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.textLabel.text = self.standardDeviation;
        cell.detailTextLabel.text = @"Standard Deviation";
        return cell;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = self.average;
        cell.detailTextLabel.text = @"Average";
        return cell;
    } else if (indexPath.row == 2)  {
        cell.textLabel.text = self.median;
        cell.detailTextLabel.text = @"Median";
        return cell;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = self.mode;
        cell.detailTextLabel.text = @"Mode";
        return cell;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = self.maximum;
        cell.detailTextLabel.text = @"Maximum Value";
        return cell;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = self.minimum;
        cell.detailTextLabel.text = @"Minimum Value";
        return cell;
    } else if (indexPath.row == 6) {
        cell.textLabel.text = self.area;
        cell.detailTextLabel.text = @"Graph Area";
        return cell;
    } else if (indexPath.row == 7) {
        cell.textLabel.text = self.correlation;
        cell.detailTextLabel.text = @"Correlation";
        return cell;
    } else if (indexPath.row == 0  && indexPath.section == 1) {
        cell.textLabel.text = @"Rendered Snapshot";
        cell.imageView.image = self.snapshotImage;
        return cell;
    } else {
        NSLog(@"Unknown");
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
