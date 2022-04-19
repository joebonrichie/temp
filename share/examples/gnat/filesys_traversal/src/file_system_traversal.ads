package File_System_Traversal is

   function Always_True (Name : String) return Boolean;
   --  This function always returns True and is used as a default for the
   --  generic formal predicate functions below.

   generic

      Do_Subdirs_Last : in Boolean := True;
      --  When True, Walk will process the files contained in the current
      --  directory before recursively calling itself on any directories also
      --  contained within that directory. When false, Walk will enter the
      --  directories before processing the files.

      with function File_Predicate (Name : String) return Boolean
         is Always_True;
      --  Called for each file encountered.
      --  File_Action is only called when this function returns True.

      with function Dir_Predicate (Name : String) return Boolean
         is Always_True;
      --  Called for each directory encountered.
      --  Subdir_Action is only called when this function returns True.

      with procedure File_Action (File_Name : in String) is null;
      --  The action to perform on each file encountered.

      with procedure Subdir_Action (Directory_Name : in String) is null;
      --  The action to perform on each directory encountered.

   procedure Walk
     (Current_Dir        : in String;
      File_Name_Template : in String := "*";
      Dir_Name_Template  : in String := "*");

   --  File_Name_Template is the regular expression template for file names to
   --  locate when searching a given directory. Proper execution requires the
   --  file system search to handle such expressions. Windows and Unix-based
   --  operating systems will do so.
   --
   --  Dir_Name_Template is the regular expression template for directory names
   --  to locate when searching a given directory. Proper execution requires the
   --  file system search to handle such expressions. Windows and Unix-based
   --  operating systems will do so.
   --
   --  Walk traverses the file system, starting at Current_Dir, recursively
   --  descending into any contained subdirectories.
   --
   --  Each encountered file with a name matching File_Name_Template will be
   --  passed to an invocation of File_Action, iff File_Predicate returns True
   --  for that named file. For example, we could use a function that returns
   --  True only when the size of the given file is greater than some number,
   --  or alternatively, when the file contains some text fragment. Any Boolean
   --  function working with a file name will suffice.
   --
   --  Each encountered directory with a name matching Dir_Name_Template will
   --  be passed to an invocation of Dir_Action, iff Dir_Predicate returns True
   --  for that named directory.

end File_System_Traversal;
