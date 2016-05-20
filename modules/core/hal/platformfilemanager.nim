# Copyright 2016 Xored Software, Inc.

wclass(FPlatformFileManager, header: "HAL/PlatformFilemanager.h"):
  proc initFPlatformFileManager(): FPlatformFileManager {.constructor.}
    ## Constructor

  proc getPlatformFile(): var IPlatformFile
    ## Gets the currently used platform file.
    ## @return Reference to the currently used platform file.

  proc setPlatformFile(newTopmostPlatformFile: var IPlatformFile)
    ## Sets the current platform file.
    ## @param NewTopmostPlatformFile Platform file to be used.

  proc findPlatformFile(name: wstring): ptr IPlatformFile
    ## Finds a platform file in the chain of active platform files.
    ## @param Name of the platform file.
    ## @return Pointer to the active platform file or nullptr if the platform file was not found.

  proc getPlatformFile(name: wstring): ptr IPlatformFile
    ## Creates a new platform file instance.
    ## @param Name of the platform file to create.
    ## @return Platform file instance of the platform file type was found, nullptr otherwise.

proc getFPlatformFileManager*(): var FPlatformFileManager {.noSideEffect, header: "HAL/PlatformFilemanager.h", importcpp: "FPlatformFileManager::Get()".}
  ## Gets FPlatformFileManager Singleton.

proc fileExists*(filename: string): bool =
  ## Return true if the file exists.
  result = getFPlatformFileManager().getPlatformFile().fileExists(toWideString(filename))

proc fileSize*(filename: string): int64 =
  ## Return the size of the file, or -1 if it doesn't exist.
  result = getFPlatformFileManager().getPlatformFile().fileSize(toWideString(filename))

proc deleteFile*(filename: string): bool =
  ## Delete a file and return true if the file exists. Will not delete read only files.
  result = getFPlatformFileManager().getPlatformFile().deleteFile(toWideString(filename))

proc isReadOnly*(filename: string): bool =
  ## Return true if the file is read only.
  result = getFPlatformFileManager().getPlatformFile().isReadOnly(toWideString(filename))

proc copyFile*(toFile, fromFile: string): bool =
  ## Copy a file. This will fail if the destination file already exists.
  ## @param ToFile		File to copy to.
  ## @param FromFile		File to copy from.
  ## @return			true if the file was copied sucessfully.
  result = getFPlatformFileManager().getPlatformFile().copyFile(toWideString(toFile), toWideString(fromFile))

proc moveFile*(toFile, fromFile: string): bool =
  ## Attempt to move a file. Return true if successful. Will not overwrite existing files.
  result = getFPlatformFileManager().getPlatformFile().moveFile(toWideString(toFile), toWideString(fromFile))

proc setReadOnly*(filename: string; bNewReadOnlyValue: bool): bool =
  ## Attempt to change the read only status of a file. Return true if successful.
  result = getFPlatformFileManager().getPlatformFile().setReadOnly(toWideString(filename), bNewReadOnlyValue)

proc getTimeStamp*(filename: string): FDateTime =
  ## Return the modification time of a file. Returns FDateTime::MinValue() on failure
  result = getFPlatformFileManager().getPlatformFile().getTimeStamp(toWideString(filename))

proc setTimeStamp*(filename: string; dateTime: FDateTime) =
  ## Sets the modification time of a file
  getFPlatformFileManager().getPlatformFile().setTimeStamp(toWideString(filename), dateTime)

proc getAccessTimeStamp*(filename: string): FDateTime =
  ## Return the last access time of a file. Returns FDateTime::MinValue() on failure
  result = getFPlatformFileManager().getPlatformFile().getAccessTimeStamp(toWideString(filename))

proc getFilenameOnDisk*(filename: string): string =
  ## For case insensitive filesystems, returns the full path of the file with the same case as in the filesystem
  result = $getFPlatformFileManager().getPlatformFile().getFileNameOnDisk(toWideString(filename))

#TODO wrap nim streams
proc openRead*(filename: string; bAllowWrite: bool = false): ptr IFileHandle =
  ## Attempt to open a file for reading.
  ## @param Filename file to be opened
  ## @param bAllowWrite (applies to certain platforms only) whether this file is allowed to be written to by other processes. This flag is needed to open files that are currently being written to as well.
  ## @return If successful will return a non-nullptr pointer. Close the file by delete'ing the handle.
  result = getFPlatformFileManager().getPlatformFile().openRead(toWideString(filename), bAllowWrite)

proc openWrite*(filename: string; bAppend: bool = false; bAllowRead: bool = false): ptr IFileHandle =
  ## Attempt to open a file for writing. If successful will return a non-nullptr pointer. Close the file by delete'ing the handle.
  result = getFPlatformFileManager().getPlatformFile().openWrite(toWideString(filename), bAppend, bAllowRead)

proc directoryExists*(directory: string): bool =
  ## Return true if the directory exists.
  result = getFPlatformFileManager().getPlatformFile().directoryExists(toWideString(directory))

proc createDirectory*(directory: string): bool =
  ## Create a directory and return true if the directory was created or already existed.
  result = getFPlatformFileManager().getPlatformFile().createDirectory(toWideString(directory))

proc deleteDirectory*(directory: string): bool =
  ## Delete a directory and return true if the directory was deleted or otherwise does not exist.
  result = getFPlatformFileManager().getPlatformFile().deleteDirectory(toWideString(directory))

proc getStatData*(filenameOrDirectory: string): FFileStatData =
  ## Return the stat data for the given file or directory. Check the FFileStatData::bIsValid member before using the returned data
  result = getFPlatformFileManager().getPlatformFile().getStatData(toWideString(filenameOrDirectory))

proc copyDirectoryTree*(destinationDirectory, source: string; bOverwriteAllExisting: bool): bool =
  ## Copy a file or a hierarchy of files (directory).
  ## @param DestinationDirectory			Target path (either absolute or relative) to copy to - always a directory! (e.g. "/home/dest/").
  ## @param Source						Source file (or directory) to copy (e.g. "/home/source/stuff").
  ## @param bOverwriteAllExisting			Whether to overwrite everything that exists at target
  ## @return								true if operation completed successfully.
  result = getFPlatformFileManager().getPlatformFile().copyDirectoryTree(
            toWideString(destinationDirectory), toWideString(source), bOverwriteAllExisting)