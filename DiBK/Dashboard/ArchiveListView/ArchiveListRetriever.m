//
//  ArchiveListRetriever.m
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ArchiveListRetriever.h"
#import "AppUtils.h"
#import "FileSystemUtils.h"

@implementation ArchiveFileInfo
@synthesize name, path, isDownloadPdf1, isDownloadPdf2, isCurrentlyDownloading, allowRename, allowDelete;

- (id)init
{
    self = [super init];
    if (self) {
        allowRename = allowDelete = YES;
    }
    return self;
}

- (BOOL)isCurrentlyDownloading
{
    return ![[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end

@implementation ArchiveFolderInfo
@synthesize name, path, files, allowDelete, allowRename;

- (id)init
{
    self = [super init];
    if (self) {
        files = [NSMutableArray new];
        allowDelete = allowRename = YES;
    }
    return self;
}

@end

static const NSString *kDefaultFolderName = @"Tilsynsrapporter";

@implementation ArchiveListRetriever

+ (NSString*)getFileSizeStr:(NSString*)filePath
{
    unsigned long long size = ([[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize]);
    double convertedValue = (double)size;// size*1e-9;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KiB",@"MiB",@"GiB",@"TiB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

+ (NSString*)getDaysSinceCreated:(NSString*)path
{
    int days = [AppUtils getDaysSinceFileCreated:path];
    return [NSString stringWithFormat:@"%d", days];
}

+(NSString*)getAllFoldersAndFilesJSON
{
    NSArray *all = [self getAll];
    
    NSMutableArray *reports = [[NSMutableArray alloc] init];
    for (ArchiveFolderInfo *folderInfo in all) {
        NSMutableArray *files = [[NSMutableArray alloc] init];
        for (ArchiveFileInfo *fileInfo in folderInfo.files) {
            NSDictionary *fileTpl = @{
                                      @"name": fileInfo.name,
                                      @"path": fileInfo.path,
                                      @"date": [self getDaysSinceCreated:fileInfo.path],
                                      @"size": [self getFileSizeStr:fileInfo.path],
                                      @"allowRename": fileInfo.allowRename ? @"1" : @"0",
                                      @"allowDelete": fileInfo.allowDelete ? @"1" : @"0"
                                      };
            [files addObject:fileTpl];
        }
        NSDictionary *folderTpl = @{
                                    @"name": folderInfo.name,
                                    @"path": folderInfo.path,
                                    @"files": files,
                                    @"allowRename": folderInfo.allowRename ? @"1" : @"0",
                                    @"allowDelete": folderInfo.allowDelete ? @"1" : @"0"
                                    };
        [reports addObject:folderTpl];
    }
    
    NSDictionary *json = @{ @"reports" : reports };
    return [AppUtils jsonStringFromDict:json];
}

+(NSString*)getPathForFolderName:(NSString *)folderName
{
    NSArray *all = [self getAll];
    for (ArchiveFolderInfo *folderInfo in all) {
        if ([folderInfo.name isEqualToString:folderName]) {
            return folderInfo.path;
        }
    }
    // not found using folder name so return default path
    return [self getDefaultFolderPath];
}

// this function will create our default and download folders if they don't exist
+(NSString*)getDefaultFolderPath
{
    NSString *cachesDir = [FileSystemUtils docsDir];
    NSString *defaultFolder = [cachesDir stringByAppendingPathComponent:kDefaultFolderName];
    [FileSystemUtils createPath:defaultFolder];
    return defaultFolder;
}

+(ArchiveFolderInfo*)getDefaultFolder
{
    NSArray *folders = [ArchiveListRetriever getAll];
    NSArray *filesInDefaultFolder = nil;
    for (ArchiveFolderInfo *folderInfo in folders) {
        if ([folderInfo.name isEqualToString:kDefaultFolderName]) {
            return folderInfo;
        }
    }
    // we should always have a default folder
    assert(0);
    return nil;
}

+(NSArray*)getAll
{
    NSString *cacheDir = [FileSystemUtils docsDir];
    [FileSystemUtils createPath:cacheDir];
    [self getDefaultFolderPath];
    NSArray *allFolders = [self getFolders:cacheDir];
    for (ArchiveFolderInfo *f in allFolders) {
        [self populateFolder:f];
    }
    return allFolders;
}

+ (void)renameFolderWithPath:(NSString*)folderPath andNewName:(NSString*)newFolderName
{
    NSString *newPath = [[folderPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newFolderName];
    [[NSFileManager defaultManager] moveItemAtPath:folderPath toPath:newPath error:nil];
}

+ (void)renameFileWithPath:(NSString *)filePath andNewName:(NSString *)newFileName
{
    NSString *newPath = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newFileName];
    [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:newPath error:nil];
}

+ (void)removeFolderWithPath:(NSString *)folderPath
{
    [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
}

+ (void)removeFileWithPath:(NSString *)filePath
{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

+ (void)newFolder
{
    NSString *docsDir = [FileSystemUtils docsDir];
    NSString *newFolderStr = [self newFolderStr];
    NSString *path = [docsDir stringByAppendingPathComponent:newFolderStr];
    [FileSystemUtils createPath:path];
}

+ (void)newFolderWithName:(NSString *)name
{
    NSString *docsDir = [FileSystemUtils docsDir];
    NSString *path = [docsDir stringByAppendingPathComponent:name];
    [FileSystemUtils createPath:path];
}

+ (NSString*)newFolderStr
{
    BOOL taken = YES;
    NSString *newFolderStr = @"New Folder";
    NSArray *allFolders = [self getAll];
    int i = 0;
    while (taken) {
        taken = NO;
        for (ArchiveFolderInfo *folderInfo in allFolders) {
            if ([folderInfo.name isEqualToString:newFolderStr]) {
                taken = YES;
                break;
            }
        }
        if (taken) {
            newFolderStr = [NSString stringWithFormat:@"New Folder %d", ++i];
        }
    }
    return newFolderStr;
}

+(void)populateFolder:(ArchiveFolderInfo*)folder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:folder.path error:nil];
    
    // filter by file type
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"pathExtension IN %@", @[@"pdf", @"png", @"jpg", @"jpeg"]];
    NSArray *filtered = [dirContents filteredArrayUsingPredicate:fltr];
    
    // sort by creation date
    filtered = [filtered sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        a = [folder.path stringByAppendingPathComponent:a];
        b = [folder.path stringByAppendingPathComponent:b];
        NSDate *aDate = [AppUtils getFileCreationDate:a];
        NSDate *bDate = [AppUtils getFileCreationDate:b];
        return [bDate compare:aDate];
    }];
    
    for (NSString *file in filtered) {
        ArchiveFileInfo *afi = [ArchiveFileInfo new];
        afi.name = file;
        afi.path = [folder.path stringByAppendingPathComponent:file];
        [folder.files addObject:afi];
    }
}

+(NSArray*)getFolders:(NSString*)docsDir
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:docsDir error:nil];
    NSMutableArray *directoryList = [[NSMutableArray alloc] init];
    for(NSString *file in dirContents) {
        
        NSString *path = [docsDir stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if(isDir) {
            ArchiveFolderInfo *afi = [[ArchiveFolderInfo alloc] init];
            afi.path = path;
            afi.name = file;
            if ([afi.name isEqualToString:kDefaultFolderName]) {
                afi.allowDelete = afi.allowRename = NO;
            }
            [directoryList addObject:afi];
        }
    }
    return directoryList;
}

@end