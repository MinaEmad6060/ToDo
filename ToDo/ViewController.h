//
//  ViewController.h
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchToDo;
@property (strong, nonatomic) NSArray<Task *> *filteredTaskList;

@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
@property (weak, nonatomic) IBOutlet UILabel *textCustomCell;
@property NSUserDefaults *defaults;
@property NSInteger rowIndexToDo;
@property NSString *searchTestStr;
@property NSMutableArray<Task *> *taskListGet;
@property NSMutableArray<Task *> *taskListTemp;
@property NSMutableArray<Task *> *taskListThird;
- (IBAction)btnAdd:(UIBarButtonItem *)sender;

@end

