//
//  DetailesViewController.h
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (weak, nonatomic) IBOutlet UITextField *textDetails;
@property (weak, nonatomic) IBOutlet UITextField *descDetails;


@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerDetails;
@property NSDate *selectedDate;
@property (nonatomic) NSInteger retrievedValue;
@property (nonatomic) NSInteger inProgValue;
@property (nonatomic) NSInteger doneValue;
@property (nonatomic) NSString *savedString;
@property NSMutableArray<Task *> *taskListDetails;
@property NSMutableArray<Task *> *inProgListDetails;
@property NSMutableArray<Task *> *doneListDetails;
@property NSUserDefaults *defaults;

//- (IBAction)btnDetails:(UIButton *)sender;
//@property (weak, nonatomic) IBOutlet UIButton *btnDetailsOutlet;

- (IBAction)btnEdit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEditDetails;


@end

NS_ASSUME_NONNULL_END
