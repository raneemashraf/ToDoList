//
//  AddTaskViewController.h
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *descLabel;
- (IBAction)addBtn:(id)sender;

@property id <TaskProtocol>taskProtocol;


@end

NS_ASSUME_NONNULL_END
