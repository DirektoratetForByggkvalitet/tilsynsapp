//
//  ArchiveListRetriever.h
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveFileInfo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic) BOOL isDownloadPdf1, isDownloadPdf2, allowRename, allowDelete;
@property (nonatomic) BOOL isCurrentlyDownloading;
@end

@interface ArchiveFolderInfo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic) BOOL allowRename, allowDelete;
@end

@interface ArchiveListRetriever : NSObject
+(NSArray*)getAll;
+(NSString*)getAllFoldersAndFilesJSON;
+(void)newFolder;
+(void)newFolderWithName:(NSString*)name;
+(void)renameFolderWithPath:(NSString*)folderPath andNewName:(NSString*)newFolderName;
+(void)renameFileWithPath:(NSString*)filePath andNewName:(NSString*)newFileName;
+(void)removeFolderWithPath:(NSString*)folderPath;
+(void)removeFileWithPath:(NSString*)filePath;
+(NSString*)getDefaultFolderPath;
+(NSString*)getPathForFolderName:(NSString*)folderName;
+(ArchiveFolderInfo*)getDefaultFolder;
@end
