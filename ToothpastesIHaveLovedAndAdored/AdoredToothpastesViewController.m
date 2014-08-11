//
//  ViewController.m
//  ToothpastesIHaveLovedAndAdored
//
//  Created by Iván Mervich on 8/11/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "AdoredToothpastesViewController.h"
#import "ToothpastesTableViewController.h"

@interface AdoredToothpastesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *adoredToothpastes;

@end

@implementation AdoredToothpastesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self load];

	if (!self.adoredToothpastes) {
		self.adoredToothpastes = [NSMutableArray new];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.adoredToothpastes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
	cell.textLabel.text = self.adoredToothpastes[indexPath.row];
	return cell;
}

- (IBAction)unWindFromToothpasteViewController:(UIStoryboardSegue *)segue
{
	ToothpastesTableViewController *tvc = (ToothpastesTableViewController * )segue.sourceViewController;

	NSString *toothpaste = [tvc adoredToothpaste];
	[self.adoredToothpastes addObject:toothpaste];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.adoredToothpastes.count - 1
												inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];

	[self save];
}

#pragma Persistance

- (NSURL *)documentsDirectory
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *directories = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	NSLog(@"%@", directories.firstObject);
	return directories.firstObject;
}

- (void)save
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist"];

	NSLog(@"%@", plist);
	[self.adoredToothpastes writeToURL:plist atomically:YES];
	[defaults setObject:[NSDate date] forKey:@"LastSaved"];
	[defaults synchronize];
}

- (void)load
{
	NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist"];
	self.adoredToothpastes = [NSMutableArray arrayWithContentsOfURL:plist];
}

@end
