
with Ada.Calendar;                          use Ada.Calendar;
with Ada.Containers.Indefinite_Hashed_Maps; use Ada;
with Ada.Text_IO;                           use Ada.Text_IO;
with Ada.Integer_Text_IO;                   use Ada.Integer_Text_IO;
with Ada.Directories;                       use Ada.Directories;
with Ada.Strings.Fixed;                     use Ada.Strings.Fixed;
with Ada.Strings.Hash;                      use Ada.Strings;
with Ada.Strings.Unbounded;                 use Ada.Strings.Unbounded;

with Dash_Board;
with Plugins;               use Plugins;
with Extension;             use Extension;

procedure Demo is

   --  Record plug-in name and corresponding handle

   package Plugin_Map is new Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Plugin,
      Hash            => Strings.Hash,
      Equivalent_Keys => "=",
      "="             => "=");

   Increment : Integer;
   --  elapsed time in milliseconds

   Loaded_DLLs : Plugin_Map.Map;
   --  The names of all currently discovered plug-ins with corresponding handle

   function "+"
     (Source : String) return Unbounded_String renames To_Unbounded_String;

   -----------------
   -- Plugin_Name --
   -----------------

   function Plugin_Name (Name : String) return String is
      K : Integer := Index (Name, "plugin_");
   begin
      return Name (Name'First .. K -1) & Name (K + 7 .. Name'Last);
   end Plugin_Name;

   ----------------------
   -- Discover_Plugins --
   ----------------------

   procedure Discover_Plugins is
      S, S1      : Search_Type;
      D, D1      : Directory_Entry_Type;
      Only_Dirs  : constant Filter_Type :=
                     (Directory     => True, others => False);
      Only_Files : constant Filter_Type :=
                     (Ordinary_File => True, others => False);
      Base       : constant String := "base." & Extension.File_Extension;
      Any_Plugin : constant String :=
                     "libplugin_*." & Extension.File_Extension;
   begin
      Start_Search (S, ".", "", Only_Dirs);

      while More_Entries (S) loop
         Get_Next_Entry (S, D);

         Start_Search (S1, Full_Name (D), Any_Plugin, Only_Files);

         while More_Entries (S1) loop
            Get_Next_Entry (S1, D1);
            declare
               P     : Plugin;
               Name  : constant String := Simple_Name (D1);
               Fname : constant String := Full_Name (D1);
               Pname : constant String := Plugin_Name (Fname);
            begin
               --  Plug-in file is older than 5 seconds, we do not want to try
               --  loading a plug-in not yet fully compiled.

               if Modification_Time (D1) < Clock - 5.0 then
                  Put_Line ("Plug-in " & Name);

                  if Loaded_DLLs.Contains (Pname) then
                     Put_Line ("... already loaded, unload now");
                     P := Loaded_DLLs.Element (Pname);
                     Plugins.Unload (P);
                  end if;

                  --  Rename plug-in (remove pluging_)

                  if Exists (Pname) then
                     Delete_File (Pname);
                  end if;

                  Rename (Fname, Pname);

                  --  Load it

                  P := Plugins.Load (Pname);
                  Loaded_DLLs.Include (Pname, P);
               end if;
            end;
         end loop;
      end loop;
   end Discover_Plugins;

begin
   Put ("Give a time increment in milliseconds (0 to abandon): ");
   Get (Increment);

   if Increment <= 0 then
      return;
   end if;

   loop
      Discover_Plugins;
      Dash_Board.Display;
      Dash_Board.Update (Increment);
      delay Duration (Increment/1000);
   end loop;
end Demo;
