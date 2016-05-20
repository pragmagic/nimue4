# Copyright 2016 Xored Software, Inc.

wclass(IFileHandle, header: "GenericPlatform/GenericPlatformFile.h"):

  proc tell(): int64
    ## Return the current write or read position.

  proc seek(newPosition: int64): bool
    ## Change the current write or read position.
    ## @param NewPosition	new write or read position
    ## @return true if the operation completed successfully.


  proc seekFromEnd(newPositionRelativeToEnd: int64 = 0): bool
    ## Change the current write or read position, relative to the end of the file.
    ## @param NewPositionRelativeToEnd	new write or read position, relative to the end of the file should be <=0!
    ## @return							true if the operation completed successfully.

  proc read(destination: ptr uint8; bytesToRead: int64): bool
    ## Read bytes from the file.
    ## @param Destination	Buffer to holds the results, should be at least BytesToRead in size.
    ## @param BytesToRead	Number of bytes to read into the destination.
    ## @return				true if the operation completed successfully.

  proc write(source: ptr uint8; bytesToWrite: int64): bool
    ## Write bytes to the file.
    ## @param Source		Buffer to write, should be at least BytesToWrite in size.
    ## @param BytesToWrite	Number of bytes to write.
    ## @return				true if the operation completed successfully.

  proc size(): int64
    ## Return the total size of the file *

wclass(FFileStatData, header: "GenericPlatform/GenericPlatformFile.h"):
  ##Contains the information that's returned from stat'ing a file or directory

  var creationTime: FDateTime
  var accessTime: FDateTime
    ## The time that the file or directory was last accessed, or FDateTime::MinValue if the access time is unknown
  var modificationTime: FDateTime
    ## The time the the file or directory was last modified, or FDateTime::MinValue if the modification time is unknown
  var fileSize: int64
    ## Size of the file (in bytes), or -1 if the file size is unknown
  var bIsDirectory: bool = true
    ## True if this data is for a directory, false if it's for a file
  var bIsReadOnly: bool = true
    ## True if this file is read-only
  var bIsValid: bool = true
    ## True if file or directory was found, false otherwise. Note that this value being true does not ensure that the other members are filled in with meaningful data, as not all file systems have access to all of this data

  proc initFFileStatData*(): FFileStatData {.constructor.}
  proc initFFileStatData*(inCreationTime: FDateTime; inAccessTime: FDateTime;
                            inModificationTime: FDateTime; inFileSize: int64;
                            inIsDirectory: bool; inIsReadOnly: bool): FFileStatData {.constructor.}

wclass(FDirectoryVisitor, header: "GenericPlatform/GenericPlatformFile.h"):
  ## Base class for file and directory visitors that take only the name. *

  proc visit(filenameOrDirectory: wstring; bIsDirectory: bool): bool
    ## Callback for a single file or a directory in a directory iteration.
    ## @param FilenameOrDirectory		If bIsDirectory is true, this is a directory (with no trailing path delimiter), otherwise it is a file name.
    ## @param bIsDirectory	true if FilenameOrDirectory is a directory.
    ## @return	true if the iteration should continue.

wclass(FDirectoryStatVisitor, header: "GenericPlatform/GenericPlatformFile.h"):
  ## Base class for file and directory visitors that take all the stat data.

  proc visit(filenameOrDirectory: wstring; statData: FFileStatData): bool
    ## Callback for a single file or a directory in a directory iteration.
    ## @param FilenameOrDirectory		If bIsDirectory is true, this is a directory (with no trailing path delimiter), otherwise it is a file name.
    ## @param StatData					The stat data for the file or directory.
    ## @return							true if the iteration should continue.

  proc iterateDirectory(directory: wstring; visitor: var FDirectoryVisitor): bool
    ## Call the Visit function of the visitor once for each file or directory in a single directory. This function does not explore subdirectories.
    ## @param Directory		The directory to iterate the contents of.
    ## @param Visitor		Visitor to call for each element of the directory
    ## @return				false if the directory did not exist or if the visitor returned false.

  proc iterateDirectoryStat(directory: wstring; visitor: var FDirectoryStatVisitor): bool
    ## Call the Visit function of the visitor once for each file or directory in a single directory. This function does not explore subdirectories.
    ## @param Directory		The directory to iterate the contents of.
    ## @param Visitor		Visitor to call for each element of the directory
    ## @return				false if the directory did not exist or if the visitor returned false.

wclass(IPlatformFile, header: "GenericPlatform/GenericPlatformFile.h"):
  ## File I/O Interface

  proc getPlatformPhysical(): var IPlatformFile
    ## Physical file system of the _platform_, never wrapped. *

  proc getPhysicalTypeName(): wstring
    ## Returns the name of the physical platform file type.

  proc setSandboxEnabled(bInEnabled: bool)
    ## Set whether the sandbox is enabled or not
    ## @param bInEnabled 	true to enable the sandbox, false to disable it

  proc isSandboxEnabled(): bool {.noSideEffect.}
    ## Returns whether the sandbox is enabled or not
    ## @return bool 		true if enabled, false if not

  proc shouldBeUsed(inner: ptr IPlatformFile; cmdLine: wstring): bool {.noSideEffect.}
    ## Checks if this platform file should be used even though it was not asked to be.
    ## i.e. pak files exist on disk so we should use a pak file

  proc initialize(inner: ptr IPlatformFile; cmdLine: wstring): bool
    ## Initializes platform file.
    ## @param Inner Platform file to wrap by this file.
    ## @param CmdLine Command line to parse.
    ## @return true if the initialization was successful, false otherise.

  proc initializeAfterSetActive()
    ## Performs initialization of the platform file after it has become the active (FPlatformFileManager.GetPlatformFile() will return this

  proc addLocalDirectories(localDirectories: var TArray[FString])
    ## Identifies any platform specific paths that are guaranteed to be local (i.e. cache, scratch space)

  proc getLowerLevel(): ptr IPlatformFile
    ## Gets the platform file wrapped by this file.

  proc getName(): wstring {.noSideEffect.}
    ## Gets this platform file type name.

  proc fileExists(filename: wstring): bool
    ## Return true if the file exists. *

  proc fileSize(filename: wstring): int64
    ## Return the size of the file, or -1 if it doesn't exist. *

  proc deleteFile(filename: wstring): bool
    ## Delete a file and return true if the file exists. Will not delete read only files. *

  proc isReadOnly(filename: wstring): bool
    ## Return true if the file is read only. *

  proc moveFile(to: wstring; `from`: wstring): bool
    ## Attempt to move a file. Return true if successful. Will not overwrite existing files. *

  proc setReadOnly(filename: wstring; bNewReadOnlyValue: bool): bool
    ## Attempt to change the read only status of a file. Return true if successful. *

  proc getTimeStamp(filename: wstring): FDateTime
    ## Return the modification time of a file. Returns FDateTime::MinValue() on failure *

  proc setTimeStamp(filename: wstring; dateTime: FDateTime)
    ## Sets the modification time of a file *

  proc getAccessTimeStamp(filename: wstring): FDateTime
    ## Return the last access time of a file. Returns FDateTime::MinValue() on failure *

  proc getFilenameOnDisk(filename: wstring): FString
    ## For case insensitive filesystems, returns the full path of the file with the same case as in the filesystem

  proc openRead(filename: wstring; bAllowWrite: bool = false): ptr IFileHandle
    ## Attempt to open a file for reading.
    ## @param Filename file to be opened
    ## @param bAllowWrite (applies to certain platforms only) whether this file is allowed to be written to by other processes. This flag is needed to open files that are currently being written to as well.
    ## @return If successful will return a non-nullptr pointer. Close the file by delete'ing the handle.

  proc openWrite(filename: wstring; bAppend: bool = false; bAllowRead: bool = false): ptr IFileHandle
    ## Attempt to open a file for writing. If successful will return a non-nullptr pointer. Close the file by delete'ing the handle. *

  proc directoryExists(directory: wstring): bool
    ## Return true if the directory exists. *

  proc createDirectory(directory: wstring): bool
    ## Create a directory and return true if the directory was created or already existed. *

  proc deleteDirectory(directory: wstring): bool
    ## Delete a directory and return true if the directory was deleted or otherwise does not exist. *

  proc getStatData(filenameOrDirectory: wstring): FFileStatData
    ## Return the stat data for the given file or directory. Check the FFileStatData::bIsValid member before using the returned data

  proc getTimeStampPair(pathA: wstring; pathB: wstring; outTimeStampA: var FDateTime;
                      outTimeStampB: var FDateTime)

  proc iterateDirectoryRecursively(directory: wstring;
                                  visitor: var FDirectoryVisitor): bool
    ## Call the Visit function of the visitor once for each file or directory in a directory tree. This function explores subdirectories.
    ## @param Directory		The directory to iterate the contents of, recursively.
    ## @param Visitor		Visitor to call for each element of the directory and each element of all subdirectories.
    ## @return				false if the directory did not exist or if the visitor returned false.

  proc iterateDirectoryStatRecursively(directory: wstring;
                                      visitor: var FDirectoryStatVisitor): bool
    ## Call the Visit function of the visitor once for each file or directory in a directory tree. This function explores subdirectories.
    ## @param Directory		The directory to iterate the contents of, recursively.
    ## @param Visitor		Visitor to call for each element of the directory and each element of all subdirectories.
    ## @return				false if the directory did not exist or if the visitor returned false.

  proc deleteDirectoryRecursively(directory: wstring): bool
    ## Delete all files and subdirectories in a directory, then delete the directory itself
    ## @param Directory		The directory to delete.
    ## @return				true if the directory was deleted or did not exist.

  proc createDirectoryTree(directory: wstring): bool
    ## Create a directory, including any parent directories and return true if the directory was created or already existed. *

  proc copyFile(toFile: wstring; fromFile: wstring): bool
    ## Copy a file. This will fail if the destination file already exists.
    ## @param ToFile		File to copy to.
    ## @param FromFile		File to copy from.
    ## @return			true if the file was copied sucessfully.

  proc copyDirectoryTree(destinationDirectory: wstring; source: wstring;
                        bOverwriteAllExisting: bool): bool
    ## Copy a file or a hierarchy of files (directory).
    ## @param DestinationDirectory			Target path (either absolute or relative) to copy to - always a directory! (e.g. "/home/dest/").
    ## @param Source						Source file (or directory) to copy (e.g. "/home/source/stuff").
    ## @param bOverwriteAllExisting			Whether to overwrite everything that exists at target
    ## @return								true if operation completed successfully.

  proc convertToAbsolutePathForExternalAppForRead(filename: wstring): FString
    ## Converts passed in filename to use an absolute path (for reading).
    ## @param	Filename	filename to convert to use an absolute path, safe to pass in already using absolute path
    ## @return	filename using absolute path

  proc convertToAbsolutePathForExternalAppForWrite(filename: wstring): FString
    ## Converts passed in filename to use an absolute path (for writing)
    ## @param	Filename	filename to convert to use an absolute path, safe to pass in already using absolute path
    ## @return	filename using absolute path
