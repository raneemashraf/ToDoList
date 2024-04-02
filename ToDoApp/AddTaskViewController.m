//
//  AddTaskViewController.m
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import "AddTaskViewController.h"
#import "TaskDTO.h"


@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityOutlet;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)addBtn:(id)sender {
    NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    TaskDTO *task =[TaskDTO new];
    task.title = _titleLabel.text;
    task.desc = _descLabel.text;
    task.myPriority = _priorityOutlet.selectedSegmentIndex;
    task.date = dateString;
    [_taskProtocol reloadData:[self dictionaryFromTask:task]];
    
    

    //Retrieve the existing task array from UserDefaults or create a new one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tasksArray = [[defaults objectForKey:@"TasksArray"] mutableCopy];
        if(tasksArray ==nil){
            tasksArray=[[NSMutableArray alloc]init];
        }
    
    [tasksArray addObject:[self dictionaryFromTask:task]];
    
    // Save the updated task array back to UserDefaults
    [defaults setObject:tasksArray forKey:@"TasksArray"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

//convert Task object to NSDictionary
- (NSDictionary *)dictionaryFromTask:(TaskDTO *)task {
    NSNumber *priorityNumber = @(task.myPriority);
    NSNumber *stateNumber = 0;
    NSInteger statenum = 0;
    
   // NSNumber *stateNumber = @(task.state);

        return @{
        @"title": task.title,
        @"description": task.desc,
        @"taskPriority": priorityNumber,
        @"date": task.date,
        @"state":@(statenum)
    };
}


@end
