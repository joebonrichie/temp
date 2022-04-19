with Ada.Streams;

package Application_Data is

   type Data is
      record
         Int : Integer;
         Flt : Float;
      end record;
   --  An example application type (would probably be a private type
   --  but that does not affect anything pertinent here).

   procedure Read_Data
     (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
      Item   : out Data);

   procedure Write_Data
     (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
      Item   : in Data);

   for Data'Read  use Read_Data;
   for Data'Write use Write_Data;

end Application_Data;

