//
//  InProgressViewController.h
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;
@property NSUserDefaults *defaults;
@property NSMutableArray<Task *> *taskListGet;
@property NSMutableArray<Task *> *lowListGet;
@property NSMutableArray<Task *> *mediumListGet;
@property NSMutableArray<Task *> *highListGet;
@property Boolean isFiltered;
@property NSInteger rowIndexInProg;
@property NSInteger numOfAllRows;

- (IBAction)btnFilter:(UIBarButtonItem *)sender;

@end

NS_ASSUME_NONNULL_END
