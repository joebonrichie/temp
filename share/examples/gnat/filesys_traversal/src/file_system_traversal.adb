with Ada.Directories; use Ada.Directories;

package body File_System_Traversal is

   Dirs  : constant Filter_Type := (Directory     => True, others => False);
   Files : constant Filter_Type := (Ordinary_File => True, others => False);

   function Should_Process (This : Directory_Entry_Type) return Boolean;
   --  Returns whether this is the dotted dir ("." or ".."), which should
   --  not be processed because it will cause Walk to infinitely recurse

   ----------
   -- Walk --
   ----------

   procedure Walk
     (Current_Dir        : in String;
      File_Name_Template : in String := "*";
      Dir_Name_Template  : in String := "*")
   is
      Iterator   : Search_Type;
      Next_Entry : Directory_Entry_Type;
   begin
      --  Process the files in the current directory.

      Start_Search (Iterator, Current_Dir, File_Name_Template, Files);
      while More_Entries (Iterator) loop
         Get_Next_Entry (Iterator, Next_Entry);
         if File_Predicate (Full_Name (Next_Entry)) then
            File_Action (Full_Name (Next_Entry));
         end if;
      end loop;

      --  Process the directories, recursively entering them and
      --  processing any files/directories within.

      Start_Search (Iterator, Current_Dir, Dir_Name_Template, Dirs);
      while More_Entries (Iterator) loop
         Get_Next_Entry (Iterator, Next_Entry);
         if Should_Process (Next_Entry) then
            if Do_Subdirs_Last then
               Walk (Full_Name (Next_Entry), File_Name_Template, Dir_Name_Template);
               if Dir_Predicate (Full_Name (Next_Entry)) then
                  Subdir_Action (Full_Name (Next_Entry));
               end if;
            else
               if Dir_Predicate (Full_Name (Next_Entry)) then
                  Subdir_Action (Full_Name (Next_Entry));
               end if;
               Walk (Full_Name (Next_Entry), File_Name_Template, Dir_Name_Template);
            end if;
         end if;
      end loop;
   end Walk;

   --------------------
   -- Should_Process --
   --------------------

   function Should_Process (This : Directory_Entry_Type) return Boolean is
   begin
      if Kind (This) = Directory and then
        (Simple_Name (This) = "." or Simple_Name (This) = "..")
      then
         return False;
      else
         return True;
      end if;
   end Should_Process;

   -----------------
   -- Always_True --
   -----------------

   function Always_True (Name : String) return Boolean is
      pragma Unreferenced (Name);
   begin
      return True;
   end Always_True;

end File_System_Traversal;
