//
//  DoneViewController.h
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;
@property NSUserDefaults *defaults;
@property NSMutableArray<Task *> *taskListGet;
@property NSMutableArray<Task *> *lowListGet;
@property NSMutableArray<Task *> *mediumListGet;
@property NSMutableArray<Task *> *highListGet;
@property NSInteger rowIndexDone;
@property NSInteger numOfAllRows;
@property Boolean isFiltered;
- (IBAction)btnFilter:(UIBarButtonItem *)sender;

@end

NS_ASSUME_NONNULL_END
