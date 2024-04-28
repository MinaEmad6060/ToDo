//
//  CustomTableViewCell.h
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageCustomCell;
@property (weak, nonatomic) IBOutlet UILabel *textCustomCell;

@end

NS_ASSUME_NONNULL_END
