//
//  DoneViewController.m
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import "DoneViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadView];

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete  && !self.isFiltered) {
        [self.taskListGet removeObjectAtIndex:indexPath.row];
        self.rowIndexDone = 0;
        self.numOfAllRows = [self.taskListGet count];

        NSData *nsTaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListGet requiringSecureCoding:NO error:nil];
        self.defaults = [NSUserDefaults standardUserDefaults];
        [self.defaults setObject:nsTaskData forKey:@"doneKey"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.taskListGet count] == 0) {
            self.doneTableView.hidden = YES;
        } else {
            self.doneTableView.hidden = NO;
        }
        [self reloadView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(!self.isFiltered){
        return 1;
    }else{
        printf("3 \n");
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isFiltered){
        if (section == 0) {
            return [self.lowListGet count];
        } else if (section == 1) {
            return [self.mediumListGet count];
        } else if (section == 2) {
            return [self.highListGet count];
        }
    }
    return self.numOfAllRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    if(self.isFiltered){
        if(indexPath.section==0){
            cell.textLabel.text = self.lowListGet[indexPath.row].title;
            cell.imageView.image = [UIImage imageNamed:self.lowListGet[indexPath.row].img];
        }else if(indexPath.section==1){
            cell.textLabel.text = self.mediumListGet[indexPath.row].title;
            cell.imageView.image = [UIImage imageNamed:self.mediumListGet[indexPath.row].img];
        }else if(indexPath.section==2){
            cell.textLabel.text = self.highListGet[indexPath.row].title;
            cell.imageView.image = [UIImage imageNamed:self.highListGet[indexPath.row].img];
        }
    }
    else {
       cell.textLabel.text = self.taskListGet[indexPath.row].title;
       cell.imageView.image = [UIImage imageNamed:self.taskListGet[indexPath.row].img];
   }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Save the selected row index
    self.rowIndexDone = indexPath.row;
    NSLog(@"%ld", self.rowIndexDone);
    [self.defaults setInteger:self.rowIndexDone forKey:@"rowIndexDoneKey"];

}



- (IBAction)btnFilter:(UIBarButtonItem *)sender {
    if(!self.isFiltered){
        self.isFiltered=true;
        [self.doneTableView reloadData];
        printf("not filtered\n");
    }else{
        self.isFiltered=false;
        [self.doneTableView reloadData];
        printf("filtered\n");
    }
}


-(void) reloadView{
    self.isFiltered=false;
   
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    Task *lowTask = [Task new];
    lowTask.title = @"Low Tasks";
    Task *mediumTask = [Task new];
    mediumTask.title = @"Medium Tasks";
    Task *highTask = [Task new];
    highTask.title = @"High Tasks";
    
    [self.defaults setInteger:0 forKey:@"rowIndexDoneKey"];
    [self.defaults setInteger:0 forKey:@"rowIndexToDoKey"];

    NSData *nsTaskDataGet = [self.defaults objectForKey:@"doneKey"];
    self.taskListGet = [NSMutableArray<Task *> array];
    self.lowListGet = [NSMutableArray<Task *> array];
    self.mediumListGet = [NSMutableArray<Task *> array];
    self.highListGet = [NSMutableArray<Task *> array];
    
    [self.lowListGet addObject:lowTask];
    [self.mediumListGet addObject:mediumTask];
    [self.highListGet addObject:highTask];
    
    self.taskListGet = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Task class], nil] fromData:nsTaskDataGet error:nil];
    
    NSString *selectedView = @"done";
    [self.defaults setObject:selectedView forKey:@"selectedViewKey"];
    self.numOfAllRows=[self.taskListGet count];
    
    
    if ([self.taskListGet count] == 0) {
        self.doneTableView.hidden = YES;
    } else {
        self.doneTableView.hidden = NO;
    }
    
    
    for(int i = 0; i < [self.taskListGet count]; i++){
        if([self.taskListGet[i].priority isEqualToString:@"Low"]){
            [self.lowListGet addObject:self.taskListGet[i]];
            printf("lowListGet \n");
        }else if([self.taskListGet[i].priority isEqualToString:@"Medium"]){
            [self.mediumListGet addObject:self.taskListGet[i]];
            printf("mediumListGet \n");
        }else if([self.taskListGet[i].priority isEqualToString:@"High"]){
            [self.highListGet addObject:self.taskListGet[i]];
            printf("highListGet \n");
        }
    }
    
    [self.doneTableView reloadData];
}

@end
