//
//  DetailsViewController.m
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import "DetailsViewController.h"
#import "InProgressViewController.h"
#import "DoneViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *descLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityOutlet;

@end

@implementation DetailsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    _titleLabel.text = _oneTask.title;
    _descLabel.text = _oneTask.desc;
    _dateLabel.text = _oneTask.date;
    _priorityOutlet.selectedSegmentIndex = _oneTask.myPriority;
    
}

- (IBAction)stateBtn:(id)sender {
    switch ([sender selectedSegmentIndex]) {
            case 0:
                _oneTask.state = [sender selectedSegmentIndex];
                printf("%ld", _oneTask.state);
                break;
            case 1: {
                _oneTask.state = [sender selectedSegmentIndex];
                printf("%ld", _oneTask.state);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *progressArray = [[defaults objectForKey:@"ProgressArray"] mutableCopy];
                if (progressArray == nil) {
                    progressArray = [[NSMutableArray alloc] init];
                }
                
                [progressArray addObject:[self dictionaryFromTask:_oneTask]];
                [defaults setObject:progressArray forKey:@"ProgressArray"];
                [defaults synchronize];
                
                NSArray *existingTasksToDo = [defaults objectForKey:@"TasksArray"];
                NSMutableArray *existingTasksToDoMutable = existingTasksToDo ? [existingTasksToDo mutableCopy] : [NSMutableArray array];
                
                [existingTasksToDoMutable removeObject:[self dictionaryFromTask:_oneTask]];
                [defaults setObject:existingTasksToDoMutable forKey:@"TasksArray"];
                [_deleteProtocol deleteData:[self dictionaryFromTask:_oneTask]];
                
                [_taskProtocol reloadData:[self dictionaryFromTask:_oneTask]];
                
                InProgressViewController *inProgress = [self.storyboard instantiateViewControllerWithIdentifier:@"InProgressViewController"];
                [self.navigationController pushViewController:inProgress animated:YES];
            }
                break;
        case 2:{
            _oneTask.state = [sender selectedSegmentIndex];
            printf("%ld", _oneTask.state);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *progressArray = [[defaults objectForKey:@"DoneArray"] mutableCopy];
            if (progressArray == nil) {
                progressArray = [[NSMutableArray alloc] init];
            }
            
            [progressArray addObject:[self dictionaryFromTask:_oneTask]];
            [defaults setObject:progressArray forKey:@"DoneArray"];
            [defaults synchronize];
            [_taskProtocol reloadData:[self dictionaryFromTask:_oneTask]];
            
            DoneViewController *doneView = [self.storyboard instantiateViewControllerWithIdentifier:@"DoneViewController"];
            [self.navigationController pushViewController:doneView animated:YES];
            
        }
                break;
            default:
                break;
        }
    [_priorityOutlet setSelectedSegmentIndex:_oneTask.state];

}


- (NSDictionary *)dictionaryFromTask:(TaskDTO *)task {
    NSNumber *priorityNumber = @(task.myPriority);
    NSNumber *stateNumber = @(task.state);
    
    return @{
        @"title": task.title,
        @"description": task.desc,
        @"taskPriority": priorityNumber,
        @"date": task.date,
        @"state":stateNumber};
}






@end
