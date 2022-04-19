with System;
with Ada.Unchecked_Conversion;

package body Application_Data is

--  The user-defined Read_Data and Write_Data routines will call the
--  stream-oriented Read and Write procedures (via dynamic dispatching) once
--  for the entire record value, instead of calling them once per record
--  component.

--  We cannot simply convert the value of Item, of record type Data, to a
--  value of type Stream_Element_Array, so we work with pointers instead.  We
--  define an access type designating a Stream_Element_Array that is the exact
--  size, in terms of Stream_Elements, of the incoming Data value.  Note the
--  use of the Data’Object_Size attribute in that computation.  That attribute
--  gives us the size of objects of the type Data, a wise approach since in
--  general the size of a type may not equal the size of objects of that type.
--  We can then use unchecked conversion to convert the address of the formal
--  parameter Item to this access type.  Dereferencing that converted access
--  value (via .all) gives us a value of type Stream_Element_Array that we can
--  pass to the call to Ada.Streams.Write.

   use Ada.Streams;

   ---------------
   -- Read_Data --
   ---------------

   procedure Read_Data
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       Item   : out Data)
   is
      Item_Size : constant Stream_Element_Offset :=
         Data'Object_Size / Stream_Element'Size;

      type SEA_Pointer is access all Stream_Element_Array (1 .. Item_Size);

      function As_SEA_Pointer is
         new Ada.Unchecked_Conversion (System.Address, SEA_Pointer);

      Dummy : Stream_Element_Offset;
   begin
      Ada.Streams.Read (Stream.all, As_SEA_Pointer (Item'Address).all, Dummy);
   end Read_Data;

   ----------------
   -- Write_Data --
   ----------------

   procedure Write_Data
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       Item   : in Data)
   is
      Item_Size : constant Stream_Element_Offset :=
         Data'Object_Size / Stream_Element'Size;

      type SEA_Pointer is access all Stream_Element_Array (1 .. Item_Size);

      function As_SEA_Pointer is
         new Ada.Unchecked_Conversion (System.Address, SEA_Pointer);

   begin
      Ada.Streams.Write (Stream.all, As_SEA_Pointer (Item'Address).all);
   end Write_Data;


end Application_Data;
