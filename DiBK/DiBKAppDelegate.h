//
//  DiBKAppDelegate.h
//  DiBK
//
//  Created by Magnus Hasfjord on 04.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
// Mags

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "DashboardViewController.h"
#import "UserInfo.h"

@interface DiBKAppDelegate : UIResponder <UIApplicationDelegate>
{
    UserInfo *_user;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StartViewController *startViewController;
@property (strong, nonatomic) UINavigationController *startNavCon;
@property (strong, nonatomic) DashboardViewController *dashboardViewController;
@property (strong, nonatomic) UINavigationController *dashboardNavCon;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
