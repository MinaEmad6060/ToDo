//
//  ViewController.m
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setInteger:-1 forKey:@"rowIndexToDoKey"];
    
    //get todo list and init other lists
    NSData *nsTaskDataGet = [self.defaults objectForKey:@"toDoKey"];
    self.taskListGet = [NSMutableArray<Task *> array];
    self.taskListTemp = [NSMutableArray<Task *> array];
    self.taskListThird = [NSMutableArray<Task *> array];
    self.taskListGet = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Task class], nil] fromData:nsTaskDataGet error:nil];
    
    //check search bar
    if(self.searchTestStr.length == 0){
        self.taskListThird=self.taskListGet;
    }else{
        self.taskListThird=self.taskListTemp;
    }
    
    //set selectedView
    NSString *selectedView = @"to do";
    [self.defaults setObject:selectedView forKey:@"selectedViewKey"];
    
    //show image
    if ([self.taskListThird count] == 0) {
        self.toDoTableView.hidden = YES;
    } else {
        self.toDoTableView.hidden = NO;
    }
    
    [self.toDoTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.taskListThird count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    
    cell.textCustomCell.text = self.taskListThird[indexPath.row].title;
    cell.imageView.image = [UIImage imageNamed:self.taskListThird[indexPath.row].img];
    
    return cell;
}

NSUInteger indexOfTaskWithTitle(NSArray<Task *> *tasks, NSString *title) {
    for (NSUInteger i = 0; i < tasks.count; i++) {
        Task *task = tasks[i];
        if ([task.title isEqualToString:title]) {
            return i;
        }
    }
    return NSNotFound;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchTestStr.length == 0){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self showAlert:indexPath.row with:indexPath tableView:tableView];
        }
    }else{
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                NSUInteger index = indexOfTaskWithTitle(self.taskListGet, self.taskListTemp[indexPath.row].title);
                [self.taskListTemp removeObjectAtIndex:indexPath.row];
                [self.taskListGet removeObjectAtIndex:index];
                self.rowIndexToDo = 0;
                NSData *nsTaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListGet requiringSecureCoding:NO error:nil];
                self.defaults = [NSUserDefaults standardUserDefaults];
                [self.defaults setObject:nsTaskData forKey:@"toDoKey"];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if ([self.taskListTemp count] == 0) {
                    self.toDoTableView.hidden = YES;
                } else {
                    self.toDoTableView.hidden = NO;
                }
            }
        }
    [self.toDoTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedView = @"to do";
    [self.defaults setObject:selectedView forKey:@"selectedViewKey"];
    self.rowIndexToDo = indexPath.row;
    NSLog(@"%ld", self.rowIndexToDo);
    [self.defaults setInteger:self.rowIndexToDo forKey:@"rowIndexToDoKey"];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTestStr = searchText;
        //  self.taskListThird=self.taskListGet;
    if (searchText.length == 0) {
        self.taskListThird=self.taskListGet;
        [self.toDoTableView reloadData];
    } else {
        // Filter the task list based on the search text
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        self.filteredTaskList = [self.taskListGet filteredArrayUsingPredicate:predicate];
        self.taskListTemp = [self.filteredTaskList mutableCopy];
        self.taskListThird=self.taskListTemp;
        [self.toDoTableView reloadData];
    }
}


- (IBAction)btnAdd:(UIBarButtonItem *)sender {
    NSString *selectedView = @"none";
    [self.defaults setObject:selectedView forKey:@"selectedViewKey"];
    
    
    NSString *savedString = [self.defaults stringForKey:@"selectedViewKey"];
    printf("selectedView %s\n", [savedString UTF8String]);
}


-(void) showAlert:(NSInteger)rowIndex with:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Are you sure, you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel button tapped");
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeTaskNoSearch:rowIndex with:indexPath tableView:tableView];
        NSLog(@"OK button tapped");
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}


-(void) removeTaskNoSearch:(NSInteger)rowIndex with:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    [self.taskListGet removeObjectAtIndex:rowIndex];
    self.rowIndexToDo = 0;

    NSData *nsTaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListGet requiringSecureCoding:NO error:nil];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults setObject:nsTaskData forKey:@"toDoKey"];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([self.taskListGet count] == 0) {
        self.toDoTableView.hidden = YES;
    } else {
        self.toDoTableView.hidden = NO;
    }
    self.taskListThird=self.taskListGet;
}

@end
