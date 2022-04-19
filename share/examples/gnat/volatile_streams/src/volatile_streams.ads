-----------------------------------------
--
--  Copyright (C) 2008-2011, AdaCore
--
-----------------------------------------

with Ada.Streams; use Ada.Streams;

package Volatile_Streams is

   type Memory_Resident_Stream (Size : Stream_Element_Count) is
      new Root_Stream_Type with private;
   --  A stream type that holds the stream elements in memory

   procedure Read (This : in out Memory_Resident_Stream;
                   Item :    out Stream_Element_Array;
                   Last :    out Stream_Element_Offset);
   --  Reads the entire value of Item from the stream This,
   --  setting Last to the last index of Item that is assigned.
   --  If the length of Item is greater than the number of
   --  elements in the stream, reading stops and Last will not
   --  be equal to Item'Last.

   procedure Write (This : in out Memory_Resident_Stream;
                    Item :        Stream_Element_Array);
   --  Writes the elements in Item to the stream.

   procedure Reset_Reading (This : access Memory_Resident_Stream);
   --  Start reading from the beginning of the stream.

   procedure Reset_Writing (This : access Memory_Resident_Stream);
   --  Start writing to the beginning of the stream.

   function Empty (This : Memory_Resident_Stream) return Boolean;
   --  Returns whether the stream contains any stream elements.

   procedure Reset (This : access Memory_Resident_Stream);
   --  Performs a complete reset, as if no reading or writing
   --  had ever occurred.

   function Extent (This : Memory_Resident_Stream) return Stream_Element_Count;
   --  Returns the number of elements in the stream.

private

   type Memory_Resident_Stream (Size : Stream_Element_Count) is
      new Root_Stream_Type with
         record
            Count    : Stream_Element_Count := 0;
            --  The number of stream elements currently held
            Next_In  : Stream_Element_Offset := 1;
            --  The index of the next stream element to be written
            Next_Out : Stream_Element_Offset := 1;
            --  The index of the next stream element to be read
            Values   : Stream_Element_Array (1 .. Size);
            --  The stream elements currently held
         end record;

end Volatile_Streams;
