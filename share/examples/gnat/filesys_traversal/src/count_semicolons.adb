--  Counts "significant" semicolons in the files specified via the command line.
--  It does not count semicolons that are embedded within parameter
--  declarations, strings, character literals or comments.
--
--  The command line arguments consist of the path to the directory
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
with Ada.Characters.Latin_1;  use Ada.Characters;

with File_System_Traversal;

procedure Count_Semicolons is

   Total_Across_Files : Natural := 0;
   --  the grand total of all significant semicolons counted

   --  The following are used for recognizing significant semicolons. These are
   --  declared here, rather than in Examine_File, to avoid having a long list
   --  of parameters.

   Previous_Char  : Character := Latin_1.Nul;
   Within_String  : Boolean := False;
   Char_Literal   : Boolean := False;
   Paren_Depth    : Natural := 0;

   Display_Width  : constant := 4;
   --  number of digits to display when printing the counts

   Spacer : constant String := "  ";
   --  the space between the count and the file name

   function Identifier_Char (C : Character) return Boolean;
   --  Returns whether C is part of a legal identifier

   procedure Examine_Line (Line : String; Line_Count : in out Natural);
   --  Increments Line_Count for each significant semicolon on Line

   procedure Examine_File (File_Name : String);
   --  Counts all the significant semicolons in the file.  Calls Examine_Line
   --  to increment Total_Across_Files

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

   ---------------------
   -- Identifier_Char --
   ---------------------

   function Identifier_Char (C : Character) return Boolean is
   begin
      return (C in 'A' .. 'Z') or (C in 'a' .. 'z') or (C in '0' .. '9');
   end Identifier_Char;

   ------------------
   -- Examine_Line --
   ------------------

   procedure Examine_Line (Line : String; Line_Count : in out Natural) is
      Char : Character;
   begin
      for K in Line'Range loop
         Char := Line (K);
         case Char is
            when '(' =>
               if not Char_Literal and not Within_String then
                  Paren_Depth := Paren_Depth + 1;
               end if;
            when ')' =>
               if not Char_Literal and not Within_String then
                  Paren_Depth := Paren_Depth - 1;
               end if;
            when '"' =>
               if not Char_Literal then
                  Within_String := not Within_String;
               end if;
            when '-' =>
               if not Char_Literal then
                  exit when Previous_Char = '-'; -- skip comments
               end if;
            when ''' =>
               Char_Literal := (not Identifier_Char (Previous_Char) and
                                not Char_Literal);
            when ';' =>
               if Paren_Depth = 0 and
                  not Within_String and
                  not Char_Literal
               then
                  Line_Count := Line_Count + 1;
               end if;
            when others =>
               null;
         end case;
         Previous_Char := Char;
      end loop;
   end Examine_Line;

   ------------------
   -- Examine_File --
   ------------------

   procedure Examine_File (File_Name : String) is
      Lines_In_File : Natural := 0;
      Source_File   : File_Type;
      Line          : String (1 .. 1024);
      Line_Last     : Natural;
   begin
      Open (Source_File, In_File, File_Name);

      while not End_Of_File (Source_File) loop
         Char_Literal   := False;     -- literals can't span lines
         Within_String  := False;     -- strings can't span lines either
         Previous_Char  := Latin_1.Nul;

         Get_Line (Source_File, Line, Line_Last);
         Examine_Line (Line (1..Line_Last), Lines_In_File);
      end loop;

      Close (Source_File);

      Counter_IO.Put (Lines_In_File, Display_Width);
      Put_Line (Spacer & File_Name);

      Total_Across_Files := Total_Across_Files + Lines_In_File;
      Paren_Depth := 0; -- recover in case previous file had bad syntax
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
   Counter_IO.Put (Total_Across_Files, Display_Width);
   Put_Line (Spacer & "Total significant semicolons");
end Count_Semicolons;
