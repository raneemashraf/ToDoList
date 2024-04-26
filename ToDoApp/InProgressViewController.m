//
//  InProgressViewController.m
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import "InProgressViewController.h"
#import "DetailsViewController.h"
#import "AddTaskViewController.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *inProgressTable;
@property (weak, nonatomic) IBOutlet UIImageView *progressImage;
- (IBAction)piriortySeg:(id)sender;

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inProgressTable.delegate = self;
    self.inProgressTable.dataSource = self;
    self.progressImage.hidden = YES;
        // Retrieve the existing task array from UserDefaults or create a new one
          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
          NSArray *existingTasks = [[defaults objectForKey:@"ProgressArray"]mutableCopy];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == %@", @(1)];
          _inProgressListArr = existingTasks ? [existingTasks mutableCopy]:[NSMutableArray array];
    if (_inProgressListArr.count == 0) {
        self.progressImage.hidden = NO;
    }else{
        self.progressImage.hidden = YES;

    }
}


    - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return _inProgressListArr.count;
    }

    - (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inProgressCell" forIndexPath:indexPath];
        
        if ([_inProgressListArr count] > 0 && indexPath.row < [_inProgressListArr count]) {
            NSDictionary *taskDic = _inProgressListArr[indexPath.row];
            TaskDTO *currentTask = [self taskFromDictionary:taskDic];
            
            
            cell.textLabel.text = [currentTask title];
            long priorityValue = [currentTask myPriority];
            
            if (priorityValue == 0) {
                cell.imageView.image = [UIImage imageNamed:@"H"];
            } else if (priorityValue == 1) {
                cell.imageView.image = [UIImage imageNamed:@"M"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"L"];
            }
        }
        return cell;
    }

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 60.0;
    }

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
            DetailsViewController *deatailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        
        NSDictionary *selectedTask;
        selectedTask = _inProgressListArr[indexPath.row];
        TaskDTO *currentTask = [self taskFromDictionary:selectedTask];
        deatailsVC.oneTask = currentTask;
        
        [self.navigationController pushViewController:deatailsVC animated:YES];
    }

    - (IBAction)addBtn:(id)sender {
        AddTaskViewController *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
        [self.navigationController pushViewController:addTaskVC animated:YES];
        addTaskVC.taskProtocol = self;

    }
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.inProgressListArr removeObject:_inProgressListArr[indexPath.row]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
        [defaults setObject:_inProgressListArr forKey:@"inProgressCell"];
        [defaults synchronize];
    [self.inProgressTable reloadData];

}

- (void)reloadData:(NSDictionary *)t {
        [_inProgressListArr addObject:t];
        [self.inProgressTable reloadData];
    }

- (void)viewWillAppear:(BOOL)animated{
    
    [self.inProgressTable reloadData];

}
    - (TaskDTO *)taskFromDictionary:(NSDictionary *)dict {
        TaskDTO *task = [[TaskDTO alloc] init];
        NSNumber *priorityNumber = dict[@"taskPriority"];
        NSNumber *stateNumber = dict[@"state"];

        task.title = dict[@"title"];
        task.desc = dict[@"description"];
        task.state = [stateNumber longValue];
        task.myPriority = [priorityNumber longValue];
        task.date = dict[@"date"];
        return task;
    }
- (IBAction)piriortySeg:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self filterTasksByPriority:0];
            break;
        case 1:
            [self filterTasksByPriority:1];
            break;
        case 2:
            [self filterTasksByPriority:2];
            break;
        default:
            break;
    }
}
 
- (void)filterTasksByPriority:(long )priority {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *existingTasks = [[defaults objectForKey:@"ProgressArray"] mutableCopy];
    _inProgressListArr = existingTasks ? [existingTasks mutableCopy] : [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskPriority == %@",@(priority)];
    NSArray *filteredTasks = [_inProgressListArr filteredArrayUsingPredicate:predicate];
    _inProgressListArr = [NSMutableArray arrayWithArray:filteredTasks];
    [self.inProgressTable reloadData];
}

@end
