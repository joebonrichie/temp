--  Prints the names of all the files that are at least a given size (in bytes).
--
--  The command line arguments consist of the path to the root of the directory
--  tree to be searched, followed by the minimum size of the file to be
--  considered a match. For example, to show all the files in and under the
--  folder named "src" that is up one level from the current dir, invoke the
--  command as follows (where $ is the prompt):
--
--  $ show_by_size ..\src 10000

with File_System_Traversal;

with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Directories;       use Ada.Directories;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Exceptions;        use Ada.Exceptions;

procedure Show_By_Size is

   Default_Dir : Unbounded_String;
   --  The name of the dir from which the program was invoked, for the sake of
   --  error recovery

   Entered_Directory_Name  : Unbounded_String;
   --  The name of the directory containing any files about to be printed

   Dir_Name_Needs_Printing : Boolean := False;
   --  Whether the value of Entered_Directory_Name has been printed yet. The
   --  logic for conditionally printing the directory name exists so that no
   --  directory name is displayed if no files within that directory match the
   --  minimum file size.

   Minimum_File_Size : Long_Long_Integer;
   --  The minimum file size of interest, taken from the command line

   Spacer : constant String := "  ";
   --  the space between the size and the file name

   procedure List_File (File_Name : in String);
   --  Prints File_Name and size on a line by themselves. First prints the name
   --  of the enclosing directory, on a line by itself, if that directory name
   --  has not yet been printed.

   procedure Capture_Dir_Name (Directory_Name : in String);
   --  Captures the Directory_Name (if it is not one of the dotted names) for
   --  later printing if necessary.

   function Big_File (Name : String) return Boolean;
   --  The file test that determines whether the size of the file is at least
   --  that of Minimum_File_Size and so should be printed.

   --------------
   -- Traverse --
   --------------

   procedure Traverse is
      new File_System_Traversal.Walk
         (Do_Subdirs_Last => False,
          File_Predicate  => Big_File,
          File_Action     => List_File,
          Subdir_Action   => Capture_Dir_Name);

   ------------------
   -- File_Size_IO --
   ------------------

   package File_Size_IO is new Integer_IO (File_Size);

   ---------------
   -- List_File --
   ---------------

   procedure List_File (File_Name : in String) is
   begin
      if Dir_Name_Needs_Printing then
         New_Line;
         Put_Line (To_String (Entered_Directory_Name));
         Dir_Name_Needs_Printing := False;
      end if;
      File_Size_IO.Put (Size (File_Name), 10);
      Put (Spacer);
      Put_Line (Simple_Name (File_Name));
   end List_File;

   ----------------------
   -- Capture_Dir_Name --
   ----------------------

   procedure Capture_Dir_Name (Directory_Name : in String) is
   begin
      if Directory_Name (Directory_Name'Last) = '.' then
         return;
      end if;
      Entered_Directory_Name := To_Unbounded_String (Directory_Name);
      Dir_Name_Needs_Printing := True;
   end Capture_Dir_Name;

   --------------
   -- Big_File --
   --------------

   function Big_File (Name : String) return Boolean is
   begin
      return Size (Name) >= File_Size (Minimum_File_Size);
   end Big_File;

   ----------
   -- Help --
   ----------

   procedure Help is
   begin
      Put_Line ("Specify the target directory path containing files to be ");
      Put_Line ("examined and a minimum size for the source files to be ");
      Put_Line ("displayed. You may need to enclose arguments in quotes.");
   end Help;


begin
   Default_Dir := To_Unbounded_String (Current_Directory);

   if Argument_Count /= 2 then
      Help;
      return;
   end if;

   if not Exists (Argument (1)) then
      Put_Line ("Error: '" & Argument (1) & "' does not exist.");
      return;
   end if;

   if Kind (Argument (1)) /= Directory then
      Put_Line ("Error: '" & Argument (1) & "' is not a directory.");
      return;
   end if;

   begin
      Minimum_File_Size := Long_Long_Integer'Value (Argument (2));
      if Minimum_File_Size < 0 then
         Put_Line ("You must specify a size >= 0");
         return;
      end if;
   exception
      when others =>
         Put_Line ("Argument #2 ('" & Argument (2) & "') is not an integer value.");
         Help;
         return;
   end;

   Traverse (Full_Name (Argument (1)));
exception
   when Error : others =>
      Put_Line ("Abandoning listing: " & Exception_Name (Error));
      Set_Directory (To_String (Default_Dir));
end Show_By_Size;

