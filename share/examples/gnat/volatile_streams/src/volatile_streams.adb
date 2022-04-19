-----------------------------------------
--
--  Copyright (C) 2008-2011, AdaCore
--
-----------------------------------------

package body Volatile_Streams is

   -----------
   -- Reset --
   -----------

   procedure Reset (This : access Memory_Resident_Stream) is
   begin
      This.Count    := 0;
      This.Next_In  := 1;
      This.Next_Out := 1;
   end Reset;

   -----------
   -- Write --
   -----------

   procedure Write
      (This : in out Memory_Resident_Stream;
       Item :        Stream_Element_Array)
   is
   begin
      for K in Item'Range loop
         This.Values (This.Next_In) := Item (K);
         This.Next_In := (This.Next_In mod This.Size) + 1;
      end loop;
      This.Count := This.Count + Item'Length;
   end Write;

   ----------
   -- Read --
   ----------

   procedure Read
      (This : in out Memory_Resident_Stream;
       Item :    out Stream_Element_Array;
       Last :    out Stream_Element_Offset)
   is
   begin
      Last := Item'First - 1;
      while This.Count > 0 and then Last < Item'Last loop
         Last := Last + 1;
         Item (Last) := This.Values (This.Next_Out);
         This.Next_Out := (This.Next_Out mod This.Size) + 1;
         This.Count := This.Count - 1;
      end loop;
   end Read;

   -------------------
   -- Reset_Reading --
   -------------------

   procedure Reset_Reading (This : access Memory_Resident_Stream) is
   begin
      This.Next_Out := 1;
   end Reset_Reading;

   -------------------
   -- Reset_Writing --
   -------------------

   procedure Reset_Writing (This : access Memory_Resident_Stream) is
   begin
      This.Next_In := 1;
   end Reset_Writing;

   -----------
   -- Empty --
   -----------

   function Empty (This : Memory_Resident_Stream) return Boolean is
   begin
      return This.Count = 0;
   end Empty;

   ------------
   -- Extent --
   ------------

   function Extent
     (This : Memory_Resident_Stream) return Stream_Element_Count
   is
   begin
      return This.Count;
   end Extent;

end Volatile_Streams;
