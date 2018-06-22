/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "Demo2ViewController.h"
#import "SWRevealViewController.h"
#import "Demo2TableViewCell.h"
#import "NCMBQuery.h"
#import "Utils.h"
#import "Mbaas.h"
#import "ProgressHUD.h"

@interface Demo2ViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSArray *arrData;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *lblResultCount;

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"demo2：全件検索";
    arrData = [NSArray array];

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [ProgressHUD show:@"Loading..."];
    [Mbaas getAllData:^(NSArray *objects) {
        arrData = objects;
        self.lblResultCount.text = [NSString stringWithFormat:NSLocalizedString(@"All search results", nil), (unsigned long)arrData.count];
        [self.table reloadData];
        [ProgressHUD dismiss];
    } errorCallback:^(NSError *error) {
        [ProgressHUD dismiss];
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Data acquisition failed", nil)];
        NSLog(@"全件検索失敗：%@", error);
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"Demo2TableViewCell";
    Demo2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (nil == cell) {
        [tableView registerClass:[Demo2TableViewCell self] forCellReuseIdentifier:cellId];
        cell = [[Demo2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (arrData.count > 0) {
        cell.lblTitle.text = [[arrData objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.lblCreatedDate.text = [Utils formatDate:[[arrData objectAtIndex:indexPath.row] objectForKey:@"createDate"]];
        NSString *contents = [NSString stringWithFormat:@"%@ (%@) - %@ - %@",
                              [[arrData objectAtIndex:indexPath.row] objectForKey:@"name"],
                              [[arrData objectAtIndex:indexPath.row] objectForKey:@"prefecture"],
                              [[arrData objectAtIndex:indexPath.row] objectForKey:@"age"],
                              [[arrData objectAtIndex:indexPath.row] objectForKey:@"emailAddress"]];
        cell.lblContents.text = contents;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Utils showAlert:self title:@"Alert" message:[[arrData objectAtIndex:indexPath.row] objectForKey:@"contents"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
