with System;               use System;
with Ada.Exceptions;       use Ada.Exceptions;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Ada.Unchecked_Deallocation;

package body Plugins is

   function dlerror return Interfaces.C.Strings.Chars_Ptr;
   pragma Import (C, dlerror, "dlerror");

   type Implementation is new System.Address;

   procedure Free is
     new Ada.Unchecked_Deallocation (Object => Implementation,
                                     Name   => Reference );

   ----------
   -- Load --
   ----------

   function Load (Path : String) return Plugin is

      function dlopen (Lib_Name : String; Mode : Interfaces.C.int)
         return System.Address;
      pragma Import(C, dlopen, "dlopen");

      RTLD_LAZY : constant := 1;
      C_Path    : constant String := Path & ASCII.Nul;
      Result    : Plugin;
   begin
      Result.Ref := new Implementation;

      Result.Ref.all := Implementation (dlopen (C_Path, RTLD_LAZY));

      if Result.Ref.all = Implementation (System.Null_Address) then
         Free (Result.Ref);
         Raise_Exception (Not_Found'Identity, Value (dlerror));
      end if;

      return Result;
   end Load;

   ----------
   -- Call --
   ----------

   procedure Call (P : Plugin; Unit_Name : String) is
      Ignored : Interfaces.C.int;
      pragma Unreferenced (Ignored);
   begin
      Ignored := Call (P, Unit_Name);
   end Call;

   ----------
   -- Call --
   ----------

   function Call (P : Plugin; Unit_Name : String) return Interfaces.C.int is

      type Shared_Func is access function return Interfaces.C.int;
      pragma Convention (C, Shared_Func);

      function dlsym (Handle : Implementation; Sym_Name : String)
         return Shared_Func;
      pragma Import(C, dlsym, "dlsym");

      C_Name : constant String := Unit_Name & ASCII.NUL;
      F      : Shared_Func;
      Result : Interfaces.C.int;
   begin
      F := dlsym (Handle => P.Ref.all, Sym_Name => C_Name);

      if F = null then
         Raise_Exception (Not_Found'Identity, Value (dlerror));
      end if;

      Result := F.all;
      return Result;
   end Call;

   ------------
   -- Unload --
   ------------

   procedure Unload (P : in out Plugin) is
      function dlclose (Handle : System.Address) return Interfaces.C.int;
      pragma Import(C, dlclose, "dlclose");

      Ignored : Interfaces.C.int;
      pragma Unreferenced (Ignored);
   begin
      Ignored := dlclose (System.Address (P.Ref.all));
      Free (P.Ref);
   end Unload;

   ---------------------
   -- Autoinitialized --
   ---------------------

   function Autoinitialized return Boolean is
   begin
      return True;
   end Autoinitialized;

end Plugins;
