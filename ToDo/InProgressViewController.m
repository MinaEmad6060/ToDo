//
//  InProgressViewController.m
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import "InProgressViewController.h"

@interface InProgressViewController ()

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadView];
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskListGet removeObjectAtIndex:indexPath.row];
        self.numOfAllRows = [self.taskListGet count];
        self.rowIndexInProg = 0;
        self.numOfAllRows = [self.taskListGet count];

        NSData *nsTaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListGet requiringSecureCoding:NO error:nil];
        self.defaults = [NSUserDefaults standardUserDefaults];
        [self.defaults setObject:nsTaskData forKey:@"inProgKey"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.taskListGet count] == 0) {
            self.inProgressTableView.hidden = YES;
        } else {
            self.inProgressTableView.hidden = NO;
        }
        [self reloadView];    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Save the selected row index
    self.rowIndexInProg = indexPath.row;
    NSLog(@"%ld", self.rowIndexInProg);
    [self.defaults setInteger:self.rowIndexInProg forKey:@"rowIndexInProgKey"];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inProgressCell" forIndexPath:indexPath];
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




- (IBAction)btnFilter:(UIBarButtonItem *)sender {
    if(!self.isFiltered){
        self.isFiltered=true;
        [self.inProgressTableView reloadData];
        printf("not filtered\n");
    }else{
        self.isFiltered=false;
        [self.inProgressTableView reloadData];
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

    
    [self.defaults setInteger:0 forKey:@"rowIndexInProgKey"];
    [self.defaults setInteger:0 forKey:@"rowIndexToDoKey"];

    NSData *nsTaskDataGet = [self.defaults objectForKey:@"inProgKey"];
    self.taskListGet = [NSMutableArray<Task *> array];
    self.lowListGet = [NSMutableArray<Task *> array];
    self.mediumListGet = [NSMutableArray<Task *> array];
    self.highListGet = [NSMutableArray<Task *> array];
    
    [self.lowListGet addObject:lowTask];
    [self.mediumListGet addObject:mediumTask];
    [self.highListGet addObject:highTask];
    
    self.taskListGet = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Task class], nil] fromData:nsTaskDataGet error:nil];
    NSString *selectedView = @"in progress";
    [self.defaults setObject:selectedView forKey:@"selectedViewKey"];
    if ([self.taskListGet count] == 0) {
        self.inProgressTableView.hidden = YES;
    } else {
        self.inProgressTableView.hidden = NO;
    }
    self.numOfAllRows=[self.taskListGet count];
    
    
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
    
    
    [self.inProgressTableView reloadData];
}

@end
