--  Counts non-comment, non-blank lines in the files specified via the command
--  line. The command line arguments consist of the path to the directory
--  containing the source files, followed by the name of the file to be
--  examined. This second argument can be a regular expression, such that
--  multiple files are examined. For example, to count such lines in all the
--  "spec" files (using the default GNAT naming scheme) in the folder named
--  "src" that is up one level from the current dir, invoke the command as
--  follows (where $ is the prompt):
--
--  $ count_lines ..\src "*.ads"
--
--  The regex representing the file names may require being quoted, as shown
--  above, when using Windows.
--
--  The total for each file is displayed. After all files are examined, the
--  grand total across all files is then displayed.

with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Command_Line;        use Ada.Command_Line;
with Ada.Directories;         use Ada.Directories;
with Ada.Characters.Latin_1;  use Ada.Characters.Latin_1;

with File_System_Traversal;

procedure Count_Lines is

   Total : Natural := 0;
   --  the total number of lines counted, across all files examined

   Display_Width : constant := 4;
   --  the number of digits to display when printing the counts

   Spacer : constant String := "  ";
   --  the space between the count and the file name

   procedure Examine_Line (Line : String; Line_Count : in out Natural);
   --  Increments Line_Count if this is a significant line

   procedure Examine_File (File_Name : String);
   --  Counts all the significant lines in the file by calling Examine_Line

   function Is_Ordinary_File (Name : String) return Boolean;
   --  Returns whether this is an ordinary file, as opposed to a directory or
   --  special file

   procedure Help;
   --  Prints help info

   --------------
   -- Traverse --
   --------------

   procedure Traverse is
      new File_System_Traversal.Walk
         (Do_Subdirs_Last => False,
          File_Predicate  => Is_Ordinary_File,
          File_Action     => Examine_File);

   ----------------
   -- Counter_IO --
   ----------------

   package Counter_IO is new Integer_IO (Integer);

   ------------------
   -- Examine_Line --
   ------------------

   procedure Examine_Line (Line : String;  Line_Count : in out Natural) is
      Start : Integer;
   begin
      -- skip blanks, if any
      Start := Line'First;
      while
         Start <= Line'Last and then (Line (Start) = ' ' or Line (Start) = HT)
      loop
         Start := Start + 1;
      end loop;
      -- if remainder is empty, ignore this line since effectively was blank
      if Start > Line'Last then
         return;
      end if;
      -- if first chars of remainder are start of comment, ignore this line
      if Start < Line'Last - 1 then
         if Line (Start) = '-' and Line (Start + 1) = '-' then
            return;
         end if;
      end if;
      --  otherwise we include this line in the count
      Line_Count := Line_Count + 1;
   end Examine_Line;

   ------------------
   -- Examine_File --
   ------------------

   procedure Examine_File (File_Name : String) is
      Lines_In_File : Natural := 0;
      Source_File   : File_Type;
      Line          : String (1 .. 1024);  -- arbitrary upper bound
      Line_Last     : Natural;
   begin
      Open (Source_File, In_File, File_Name);
      while not End_Of_File (Source_File) loop
         Get_Line (Source_File, Line, Line_Last);
         Examine_Line (Line (1..Line_Last), Lines_In_File);
      end loop;
      Close (Source_File);

      Counter_IO.Put (Lines_In_File, Display_Width);
      Put_Line (Spacer & File_Name);

      Total := Total + Lines_In_File;
   exception
      when Ada.Text_IO.Name_Error =>
         Put_Line ("Problem opening file named '" & File_Name & "'");
   end Examine_File;

   ----------------------
   -- Is_Ordinary_File --
   ----------------------

   function Is_Ordinary_File (Name : String) return Boolean is
   begin
      return Ada.Directories.Kind (Name) = Ordinary_File;
   end Is_Ordinary_File;

   ----------
   -- Help --
   ----------

   procedure Help is
   begin
      Put_Line ("Specify the target directory containing the files to be ");
      Put_Line ("examined and a pattern for the source file names in that ");
      Put_Line ("directory.  The pattern can be as specific as an individual ");
      Put_Line ("file or as general as a regular expression (regex).  A null");
      Put_Line ("pattern (i.e., """") matches all files.");
      Put_Line ("You may need to enclose arguments in quotes.");
   end Help;


begin
   if Argument_Count /= 2 then
      Help;
      return;
   end if;

   if not Exists (Argument (1)) then
      Put_Line ("Specified directory does not exist.");
      return;
   end if;

   Traverse (Argument (1), File_Name_Template => Argument (2));

   New_Line;
   Counter_IO.Put (Total, Display_Width);
   Put_Line (Spacer & "Total non-comment, non-blank lines");
end Count_Lines;
