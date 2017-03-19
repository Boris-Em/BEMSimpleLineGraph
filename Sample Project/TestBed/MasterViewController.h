//
//  MasterViewController.h
//  TestBed2
//
//  Created by Hugh Mackworth on 5/18/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

@import UIKit;



@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic)  DetailViewController *detailViewController;


@end

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel * title;

@end

@implementation CustomTableViewCell

@end
