//
//  DiBKAppDelegate.m
//  DiBK
//
//  Created by Magnus Hasfjord on 04.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DiBKAppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIView (FindViewThatIsFirstResponder)
- (UIView *)findViewThatIsFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findViewThatIsFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}
@end

@implementation DiBKAppDelegate
@synthesize startViewController = _startViewController;
@synthesize startNavCon = _startNavCon;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"ggf7k2f3n392j5r"
                            appSecret:@"i86wvnir2rfmjpr"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        frame.origin.y += 20;
    }
    self.window = [[UIWindow alloc] initWithFrame:frame];
    
    // Override point for customization after application launch.
    
    if ([self userDoesExist]) {
        _dashboardViewController = [[DashboardViewController alloc]init];
        [_dashboardViewController setManagedObjectContext:self.managedObjectContext];
        _dashboardNavCon = [[UINavigationController alloc]initWithRootViewController:_dashboardViewController];
        _dashboardNavCon.navigationBarHidden = YES;
        [self.window setRootViewController:_dashboardNavCon];
        [_dashboardViewController downloadWebdata];
    } else {
        _startViewController = [[StartViewController alloc]init];
        [_startViewController setManagedObjectContext:self.managedObjectContext];
        _startNavCon = [[UINavigationController alloc]initWithRootViewController:_startViewController];
        _startNavCon.navigationBarHidden = YES;
        [self.window setRootViewController:_startNavCon];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // we need to move view up on textviews which are at the bottom of the screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    return YES;
}

// we need to move view up on textviews which are at the bottom of the screen
// http://stackoverflow.com/questions/1465394/iphone-get-position-of-uiview-within-entire-uiwindow
// http://stackoverflow.com/questions/9874569/find-view-that-is-the-firstresponder
-(void)keyboardDidShow:(NSNotification *)notification
{
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstReponder = [frontWindow findViewThatIsFirstResponder];
    if ([self viewIsMailComposer:firstReponder]) {
        return;
    }
    CGPoint origin = [firstReponder.superview convertPoint:firstReponder.frame.origin toView:nil];
    int diff = 1024 - (origin.y+firstReponder.frame.size.height);
    if (diff < 264) {
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
        [frontWindow setFrame:CGRectMake(0,-(264-diff+20),768,1024)];
    }
}

- (BOOL)viewIsMailComposer:(UIView*)view
{
    const char* className = class_getName([view class]);
    NSString *str = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"MFComposeTextContentView"]) {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadToDropbox" object:nil];
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    [frontWindow setFrame:CGRectMake(0,0,768,1024)];
    CGRect frame = frontWindow.frame;
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        frame.origin.y += 20;
    }
    frontWindow.frame = frame;
}

-(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %li", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, dis@able timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    [[AppData getInstance] setManagedObjectContext:_managedObjectContext];
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DiBK" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DiBK.sqlite"];
    NSLog(@"Core Data store path = \"%@\"", [storeURL path]);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data fetches

-(BOOL)userDoesExist
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UserInfo"];
    
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([users count] > 0) {
        return YES;
    }
    
    return NO;
}

@end
