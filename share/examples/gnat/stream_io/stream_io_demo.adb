with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Streams.Stream_IO;  use Ada.Streams;
with Hierarchy;  -- for usr-defined tagged types

with Ada.Unchecked_Conversion;
with System;
with Interfaces;

procedure Stream_IO_Demo is

   type R is record
      A : Float;
      B : Long_Float;
   end record;

   type R_Pointer is access all R;

   procedure Read_R_Pointer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : out R_Pointer);

   procedure Write_R_Pointer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : in R_Pointer);

   --  We override the default stream attributes for the access type so that raw
   --  access values are not written to the file.
   for R_Pointer'Read  use Read_R_Pointer;
   for R_Pointer'Write use Write_R_Pointer;

   type Buffer is array (1..32) of Interfaces.Unsigned_16;

   procedure Read_Buffer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : out Buffer);

   procedure Write_Buffer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : in Buffer);

   for Buffer'Read  use Read_Buffer;
   for Buffer'Write use Write_Buffer;

   --------------------
   -- Read_R_Pointer --
   --------------------

   procedure Read_R_Pointer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : out R_Pointer)
      --  Read a flag indicating whether a value of the designated type is
      --  present in the file. If a value is present we allocate an object via
      --  Item and read the value in the file into that object, otherwise we
      --  just set Item to the null access value.
   is
      Not_Null : Boolean;
   begin
      Boolean'Read (Stream, Not_Null);
      if Not_Null then
         Item := new R;
         R'Read (Stream, Item.all);
      else
         Item := null;
      end if;
   end Read_R_Pointer;

   ---------------------
   -- Write_R_Pointer --
   ---------------------

   procedure Write_R_Pointer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : in R_Pointer)
      --  Write a boolean flag indicating whether Item designates an object.
      --  If Item designates an object we also write the value of that object.
   is
   begin
      if Item = null then
         Boolean'Write (Stream, False);
      else
         Boolean'Write (Stream, True);
         R'Write (Stream, Item.all);
      end if;
   end Write_R_Pointer;

   -----------------
   -- Read_Buffer --
   -----------------

   procedure Read_Buffer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : out Buffer)
   is
      Item_Size : constant Stream_Element_Offset :=
                    Buffer'Object_Size / Stream_Element'Size;

      type SEA_Pointer is
         access all Stream_Element_Array (1 .. Item_Size);

      function As_SEA_Pointer is
         new Ada.Unchecked_Conversion (System.Address, SEA_Pointer);

      Last : Ada.Streams.Stream_Element_Offset;
   begin
      Ada.Streams.Read (Stream.all, As_SEA_Pointer (Item'Address).all, Last);
   end Read_Buffer;

   ------------------
   -- Write_Buffer --
   ------------------

   procedure Write_Buffer
      (Stream : access Ada.Streams.Root_Stream_Type'Class;
       Item   : in Buffer)
   is
      Item_Size : constant Stream_Element_Offset :=
                     Buffer'Object_Size / Stream_Element'Size;

      type SEA_Pointer is
         access all Stream_Element_Array (1 .. Item_Size);

      function As_SEA_Pointer is
         new Ada.Unchecked_Conversion (System.Address, SEA_Pointer);
   begin
      Ada.Streams.Write (Stream.all, As_SEA_Pointer (Item'Address).all);
   end Write_Buffer;

begin
   Writing : declare
      File        : Stream_IO.File_Type;
      File_Stream : Stream_IO.Stream_Access;
      Buff        : Buffer;
   begin
      Stream_IO.Create (File, Stream_IO.Out_File, "Demo_Output");
      --  Get access to the stream representing the file.
      File_Stream := Stream_IO.Stream (File);

      Put_Line ("Writing record to file: (10.0, 20.0)");
      R'Write (File_Stream, R'(10.0, 20.0));

      Put_Line ("Writing integer to file: 2005");
      Integer'Write (File_Stream, 2005);

      --  We use the 'Output stream attribute to write both the value of this
      --  unconstrained type as well as the constraint (in this case, the array
      --  bounds).
      Put_Line ("Writing string to file: ""Hello World!""");
      String'Output (File_Stream, "Hello World!");

      Put_Line ("Writing access value designating record (1.0, -1.0) to file");
      R_Pointer'Write (File_Stream, new R'(1.0, -1.0));

      Put_Line ("Writing tagged value Child'(Priority => 10, Value => 'A')");
      Hierarchy.Child'Class'Output
         (File_Stream, Hierarchy.Child'(Priority => 10, Value => 'A'));

      Put_Line ("Writing buffer of 1 .. 32");
      for K in Buff'Range loop
         Buff (K) := Interfaces.Unsigned_16 (K);
      end loop;
      Buffer'Write (File_Stream, Buff);

      Stream_IO.Close (File);
   end Writing;

   --  Output a blank line for the sake of reading the printed results
   New_Line;

   Reading : declare
      R_Obj : R;
      New_R : R_Pointer;
      Int   : Integer;
      Buff  : Buffer := (others => 0);

      File        : Stream_IO.File_Type;
      File_Stream : Stream_IO.Stream_Access;
   begin
      Stream_IO.Open (File, Stream_IO.In_File, "Demo_Output");
      --  Get access to the stream representing the file.
      File_Stream := Stream_IO.Stream (File);

      R'Read (File_Stream, R_Obj);
      Put_Line ("Read record from file: (" &
                R_Obj.A'Img & ", " &
                R_Obj.B'Img & ")");

      Integer'Read (File_Stream, Int);
      Put_Line ("Read integer from file: " & Int'Img);

      --  Objects of unconstrained types cannot be declared without constraints
      --  so we read the value, along with its constraints, from the file
      --  and use them to declare a string object.
      declare
         S : String := String'Input (File_Stream);
      begin
         Put_Line ("Read string from file: """ & S & """");
      end;

      R_Pointer'Read (File_Stream, New_R);
      if New_R = null then
         Put_Line ("No allocated record value in file");
      else
         Put_Line ("Read allocated record from file: (" &
                    New_R.A'Img & ", " &
                    New_R.B'Img & ")");
      end if;

      --  As for the string above, class-wide objects are "indefinite" and must
      --  have their constraints (in this case the tag) specified when created.
      --  We get the tag and the value of the specific type from the file via
      --  the class-wide stream attribute 'Class'Input.
      declare
         Any : Hierarchy.Base'Class := Hierarchy.Base'Class'Input (File_Stream);
      begin
         --  Dynamically dispatch at run-time to the Print procedure for the
         --  specific type read from the file. Because the object 'Any' is
         --  class-wide, the specific type of the value can be either 'Base' or
         --  'Child' (or any other type in the derivation class).
         Hierarchy.Print (Any);
      end;

     Buffer'Read (File_Stream, Buff);

     Put_Line ("Read buffer from file:");
     for K in Buff'Range loop
        Put (Buff(K)'Img);
     end loop;
     New_Line;

     Stream_IO.Close (File);
   end Reading;
end Stream_IO_Demo;


