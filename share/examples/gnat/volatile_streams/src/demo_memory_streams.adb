with Ada.Text_IO;       use Ada.Text_IO;
with Application_Data;  use Application_Data;
with Volatile_Streams;  use Volatile_Streams;
with Ada.Streams;       use Ada.Streams;

procedure Demo_Memory_Streams is

   Number_To_Hold : constant := 10; -- arbitrary
   --  The maximum number of Data items for the stream to contain at any moment

   Data_Size_In_Storage_Units : constant Stream_Element_Count :=
      Data'Object_Size / Stream_Element'Size;
   --  The size of objects of type Data in terms of stream elements

   Stream_Size : constant Stream_Element_Count :=
      Data_Size_In_Storage_Units * Number_To_Hold;
   --  The total number of stream elements for the memory-resident stream
   --  to contain

   Container : aliased Memory_Resident_Stream (Stream_Size);
   --  The memeory_resident stream object

begin
   --  Write arbitrary data values to the stream.  In this case we simply
   --  write the values of the for-loop parameter.
   for K in Integer range 1 .. 5 loop
      Data'Write (Container'Access, Data'(Int => K, Flt => Float (K)));
   end loop;

   --  Read the content of the stream into object X and display the value.
   --  The expected output is thus:
   --     X is read as  1, 1.00000E+00
   --     X is read as  2, 2.00000E+00
   --     X is read as  3, 3.00000E+00
   --     X is read as  4, 4.00000E+00
   --     X is read as  5, 5.00000E+00
   declare
      X : Data;
      --  An object of the application-specific type
   begin
      for K in Integer range 1 .. 5 loop
         Data'Read (Container'Access, X);
         Put_Line ("X is read as " & X.Int'Img & "," & X.Flt'Img);
      end loop;
   end;
end Demo_Memory_Streams;

