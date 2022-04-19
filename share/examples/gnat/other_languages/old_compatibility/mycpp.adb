with GNAT.Os_Lib; use GNAT.Os_Lib;
with Ada.Command_Line; use Ada.Command_Line;
with GNAT.IO;
procedure MyCpp is

   Arg : Argument_List (1 .. Argument_Count + 1);
   Res : Boolean;
   GPP : String_Access := Locate_Exec_On_Path ("g++");
   N   : natural;

begin
   if GPP = null or else GPP.all'Length <= 8 then
      GNAT.IO.Put_Line ("No g++ on path");
      OS_Exit (1);
   end if;

   if GPP.all (GPP'last - 3 .. GPP'last) = ".exe" then
      N := 12;
   else
      N := 8;
   end if;

   declare
      -- remove the trailing "/bin/g++[.exe]")
      GPP_Root : constant String := GPP (1 .. GPP.all'length - N);

   begin

      -- this wrapper can be called from a GNAT wrapper which has
      --  already set the below variables to values that are not
      --  appropriate for g++. So let set them right.

      Setenv ("BINUTILS_ROOT", GPP_Root);
      Setenv ("GCC_ROOT",      GPP_Root);


      -- Force verbosity

      Arg (1) := new String'("-v");

      -- Pass arguments along

      for I in 1 .. Arg'Last - 1  loop
         Arg (I + 1) := new String'(Argument (I));
      end loop;

      Spawn (GPP.all, Arg, Res);
   end;
end MyCpp;
