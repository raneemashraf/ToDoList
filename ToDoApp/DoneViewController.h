//
//  DoneViewController.h
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskProtocol.h"


@interface DoneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TaskProtocol>

@property NSMutableArray *doneListArr;


@end

