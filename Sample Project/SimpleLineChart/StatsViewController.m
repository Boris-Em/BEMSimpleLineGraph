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
@synthesize standardDeviation, average, median, mode, maximum, minimum, snapshotImage;
@synthesize standardDeviationLabel, averageLabel, medianLabel, modeLabel, maximumLabel, minimumLabel, snapshotImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    standardDeviationLabel.text = standardDeviation;
    averageLabel.text = average;
    medianLabel.text = median;
    modeLabel.text = mode;
    maximumLabel.text = maximum;
    minimumLabel.text = minimum;
    snapshotImageView.image = snapshotImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 6;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.textLabel.text = standardDeviation;
        cell.detailTextLabel.text = @"Standard Deviation";
        return cell;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = average;
        cell.detailTextLabel.text = @"Average";
        return cell;
    } else if (indexPath.row == 2)  {
        cell.textLabel.text = median;
        cell.detailTextLabel.text = @"Median";
        return cell;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = mode;
        cell.detailTextLabel.text = @"Mode";
        return cell;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = maximum;
        cell.detailTextLabel.text = @"Maximum Value";
        return cell;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = minimum;
        cell.detailTextLabel.text = @"Minimum Value";
        return cell;
    } else if (indexPath.row == 0  && indexPath.section == 1) {
        cell.textLabel.text = @"Rendered Snapshot";
        cell.imageView.image = snapshotImage;
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
