//
//  DetailesViewController.m
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import "DetailesViewController.h"
#import "Task.h"


@interface DetailesViewController ()

@end

@implementation DetailesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePickerDetails.date = [NSDate date];
    [self.datePickerDetails addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    self.datePickerDetails.minimumDate = [NSDate date];
    self.imageDetails.image = [UIImage imageNamed:@"todo.png"];
    
    //get user def.s
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.retrievedValue = [self.defaults integerForKey:@"rowIndexToDoKey"];
    self.inProgValue = [self.defaults integerForKey:@"rowIndexInProgKey"];
    self.doneValue = [self.defaults integerForKey:@"rowIndexDoneKey"];
    NSData *nsTaskDataGet = [self.defaults objectForKey:@"toDoKey"];
    NSData *nsInProgDataGet = [self.defaults objectForKey:@"inProgKey"];
    NSData *nsDoneDataGet = [self.defaults objectForKey:@"doneKey"];
    NSString *savedString = [self.defaults stringForKey:@"selectedViewKey"];
    self.savedString=savedString;
    
    self.taskListDetails = [NSMutableArray<Task *> array];
    self.inProgListDetails = [NSMutableArray<Task *> array];
    self.doneListDetails = [NSMutableArray<Task *> array];
    self.taskListDetails = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Task class], nil] fromData:nsTaskDataGet error:nil];
    self.inProgListDetails = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Task class], nil] fromData:nsInProgDataGet error:nil];
    self.doneListDetails = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Task class], nil] fromData:nsDoneDataGet error:nil];


    if(self.retrievedValue==-1){
//        self.btnDetailsOutlet.hidden = YES;
        [self.btnEditDetails setTitle:@"Add" forState:UIControlStateNormal];
        self.typeSegment.selectedSegmentIndex = 0;
        [self.typeSegment setEnabled:NO forSegmentAtIndex:1];
        [self.typeSegment setEnabled:NO forSegmentAtIndex:2];

    }
    else if ([savedString isEqualToString:@"to do"]) {
        [self.btnEditDetails setTitle:@"Edit" forState:UIControlStateNormal];
        if([self.taskListDetails count] > 0){
            [self setDetailsView:self.taskListDetails controller:self.retrievedValue];
            [self.typeSegment setEnabled:NO forSegmentAtIndex:2];
//            self.btnDetailsOutlet.hidden = YES;
        }
    }else if ([savedString isEqualToString:@"in progress"]) {
        [self.btnEditDetails setTitle:@"Edit" forState:UIControlStateNormal];
        if([self.inProgListDetails count] > 0){
            [self setDetailsView:self.inProgListDetails controller:self.inProgValue];
            [self.typeSegment setEnabled:NO forSegmentAtIndex:0];
//            self.btnDetailsOutlet.hidden = YES;
        }

    }else if ([savedString isEqualToString:@"done"]) {
        [self.btnEditDetails setTitle:@"Edit" forState:UIControlStateNormal];
        if([self.doneListDetails count] > 0){
            [self setDetailsView:self.doneListDetails controller:self.doneValue];
            [self.typeSegment setEnabled:NO forSegmentAtIndex:0];
            [self.typeSegment setEnabled:NO forSegmentAtIndex:1];
            self.textDetails.enabled = NO;
            self.descDetails.enabled = NO;
            self.datePickerDetails.enabled = NO;
//            self.btnDetailsOutlet.hidden = YES;
            self.btnEditDetails.hidden = YES;
        }
        
    }

    
}

- (IBAction)prioritySegmentChanged:(UISegmentedControl *)sender {

}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    self.selectedDate = sender.date;
}



- (IBAction)btnEdit:(UIButton *)sender {

    if(self.textDetails.text.length !=0 ){
        if (self.retrievedValue==-1) {
            Task *addTask = [Task new];
            addTask.title = self.textDetails.text;
            addTask.desc = self.descDetails.text;
            
            NSInteger prioritySegmentIndex = self.prioritySegment.selectedSegmentIndex;
            NSString *priorityTitle = [self.prioritySegment titleForSegmentAtIndex:prioritySegmentIndex];
            addTask.priority = priorityTitle;
            addTask.img = [priorityTitle stringByAppendingString:@".png"];
            
            NSInteger typeSegmentIndex = self.typeSegment.selectedSegmentIndex;
            NSString *typeTitle = [self.typeSegment titleForSegmentAtIndex:typeSegmentIndex];
            addTask.type =typeTitle;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
            addTask.date = dateString;
            
            if (self.taskListDetails == nil) {
                self.taskListDetails = [NSMutableArray arrayWithObject:addTask];
            } else {
                [self.taskListDetails addObject:addTask];
            }
            
            NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListDetails requiringSecureCoding:NO error:nil];
            [self.defaults setObject:nstaskData forKey:@"toDoKey"];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Task added successfuly" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        
        }else if([[self.typeSegment titleForSegmentAtIndex:self.typeSegment.selectedSegmentIndex] isEqualToString:@"To Do"]){
            
            if (self.retrievedValue < self.taskListDetails.count) {
                [self.taskListDetails removeObjectAtIndex:self.retrievedValue];
                NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListDetails requiringSecureCoding:NO error:nil];
                [self.defaults setObject:nstaskData forKey:@"toDoKey"];
            }
            Task *editTask = [Task new];
            editTask.title = self.textDetails.text;
            editTask.desc = self.descDetails.text;
            
            NSInteger prioritySegmentIndex = self.prioritySegment.selectedSegmentIndex;
            NSString *priorityTitle = [self.prioritySegment titleForSegmentAtIndex:prioritySegmentIndex];
            editTask.priority = priorityTitle;
            editTask.img = [priorityTitle stringByAppendingString:@".png"];
            
            NSInteger typeSegmentIndex = self.typeSegment.selectedSegmentIndex;
            NSString *typeTitle = [self.typeSegment titleForSegmentAtIndex:typeSegmentIndex];
            editTask.type =typeTitle;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
            editTask.date = dateString;
            
            if (self.taskListDetails == nil) {
                self.taskListDetails = [NSMutableArray arrayWithObject:editTask];
            } else {
                [self.taskListDetails addObject:editTask];
            }
            
//            [self.taskListDetails insertObject:editTask atIndex:self.retrievedValue];
            
            NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListDetails requiringSecureCoding:NO error:nil];
            [self.defaults setObject:nstaskData forKey:@"toDoKey"];
            
        }else if([[self.typeSegment titleForSegmentAtIndex:self.typeSegment.selectedSegmentIndex] isEqualToString:@"In Progress"]){
            
            if([self.savedString isEqualToString:@"to do"]){
                
                if ((self.retrievedValue < self.taskListDetails.count)) {
                    [self.taskListDetails removeObjectAtIndex:self.retrievedValue];
                    NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.taskListDetails requiringSecureCoding:NO error:nil];
                    [self.defaults setObject:nstaskData forKey:@"toDoKey"];
                }
                
                Task *addTask = [Task new];
                addTask.title = self.textDetails.text;
                addTask.desc = self.descDetails.text;
                
                NSInteger prioritySegmentIndex = self.prioritySegment.selectedSegmentIndex;
                NSString *priorityTitle = [self.prioritySegment titleForSegmentAtIndex:prioritySegmentIndex];
                addTask.priority = priorityTitle;
                addTask.img = [priorityTitle stringByAppendingString:@".png"];
                
                NSInteger typeSegmentIndex = self.typeSegment.selectedSegmentIndex;
                NSString *typeTitle = [self.typeSegment titleForSegmentAtIndex:typeSegmentIndex];
                addTask.type =typeTitle;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
                addTask.date = dateString;
                
                if (self.inProgListDetails == nil) {
                    self.inProgListDetails = [NSMutableArray arrayWithObject:addTask];
                } else {
                    [self.inProgListDetails addObject:addTask];
                }
                
                NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgListDetails requiringSecureCoding:NO error:nil];
                [self.defaults setObject:nstaskData forKey:@"inProgKey"];
                
            }else if ([self.savedString isEqualToString:@"in progress"]){
                
                if ((self.inProgValue < self.inProgListDetails.count)) {
                    [self.inProgListDetails removeObjectAtIndex:self.inProgValue];
                    NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgListDetails requiringSecureCoding:NO error:nil];
                    [self.defaults setObject:nstaskData forKey:@"inProgKey"];
                }
                
                Task *addTask = [Task new];
                addTask.title = self.textDetails.text;
                addTask.desc = self.descDetails.text;
                
                NSInteger prioritySegmentIndex = self.prioritySegment.selectedSegmentIndex;
                NSString *priorityTitle = [self.prioritySegment titleForSegmentAtIndex:prioritySegmentIndex];
                addTask.priority = priorityTitle;
                addTask.img = [priorityTitle stringByAppendingString:@".png"];
                
                
                NSInteger typeSegmentIndex = self.typeSegment.selectedSegmentIndex;
                NSString *typeTitle = [self.typeSegment titleForSegmentAtIndex:typeSegmentIndex];
                addTask.type =typeTitle;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
                addTask.date = dateString;
                
                if (self.inProgListDetails == nil) {
                    self.inProgListDetails = [NSMutableArray arrayWithObject:addTask];
                } else {
                    [self.inProgListDetails addObject:addTask];
                }
                
//                [self.inProgListDetails insertObject:addTask atIndex:self.inProgValue];
                
                NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgListDetails requiringSecureCoding:NO error:nil];
                [self.defaults setObject:nstaskData forKey:@"inProgKey"];
            }
            
        }else if([[self.typeSegment titleForSegmentAtIndex:self.typeSegment.selectedSegmentIndex] isEqualToString:@"Done"]){
            
            if ((self.inProgValue < self.inProgListDetails.count)) {
                [self.inProgListDetails removeObjectAtIndex:self.inProgValue];
                NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgListDetails requiringSecureCoding:NO error:nil];
                [self.defaults setObject:nstaskData forKey:@"inProgKey"];
            }
            
            Task *addTask = [Task new];
            addTask.title = self.textDetails.text;
            addTask.desc = self.descDetails.text;
            
            NSInteger prioritySegmentIndex = self.prioritySegment.selectedSegmentIndex;
            NSString *priorityTitle = [self.prioritySegment titleForSegmentAtIndex:prioritySegmentIndex];
            addTask.priority = priorityTitle;
            addTask.img = [priorityTitle stringByAppendingString:@".png"];
            
            NSInteger typeSegmentIndex = self.typeSegment.selectedSegmentIndex;
            NSString *typeTitle = [self.typeSegment titleForSegmentAtIndex:typeSegmentIndex];
            addTask.type =typeTitle;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
            addTask.date = dateString;
            
            if (self.doneListDetails == nil) {
                self.doneListDetails = [NSMutableArray arrayWithObject:addTask];
            } else {
                [self.doneListDetails addObject:addTask];
            }
            
//            [self.doneListDetails insertObject:addTask atIndex:self.doneValue];
            
            NSData *nstaskData = [NSKeyedArchiver archivedDataWithRootObject:self.doneListDetails requiringSecureCoding:NO error:nil];
            [self.defaults setObject:nstaskData forKey:@"doneKey"];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Task Edited" message:@"you update yor task details successfully!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Title" message:@"Please enter a title." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}



//- (IBAction)btnDetails:(UIButton *)sender{}


-(void) setDetailsView:(NSMutableArray<Task *>*)myList controller:(NSInteger)rowIndex{

    
    printf("rowIndex%ld", (long)rowIndex);
    self.textDetails.text = myList[rowIndex].title;
    self.descDetails.text = myList[rowIndex].desc;
    if ([myList[rowIndex].priority isEqualToString:@"Low"]) {
            [self.prioritySegment setEnabled:NO forSegmentAtIndex:1];
            [self.prioritySegment setEnabled:NO forSegmentAtIndex:2];
        self.prioritySegment.selectedSegmentIndex = 0;
    } else if ([myList[rowIndex].priority isEqualToString:@"Medium"]) {
            [self.prioritySegment setEnabled:NO forSegmentAtIndex:0];
            [self.prioritySegment setEnabled:NO forSegmentAtIndex:2];
        self.prioritySegment.selectedSegmentIndex = 1;
    } else if ([myList[rowIndex].priority isEqualToString:@"High"]) {
            [self.prioritySegment setEnabled:NO forSegmentAtIndex:0];
            [self.prioritySegment setEnabled:NO forSegmentAtIndex:1];
        self.prioritySegment.selectedSegmentIndex = 2;
    }
    
    if ([myList[rowIndex].type isEqualToString:@"To Do"]) {
        self.typeSegment.selectedSegmentIndex = 0;
    } else if ([myList[rowIndex].type isEqualToString:@"In Progress"]) {
        self.typeSegment.selectedSegmentIndex = 1;
    } else if ([myList[rowIndex].type isEqualToString:@"Done"]) {
        self.typeSegment.selectedSegmentIndex = 2;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:myList[rowIndex].date];
    [self.datePickerDetails setDate:date animated:YES];
}


@end
