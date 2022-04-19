

with Ada.Tags.Generic_Dispatching_Constructor;

package body Graphic is

   --  Tags

   O_Color  : constant String := "<color>";
   C_Color  : constant String := "</color>";
   O_Size   : constant String := "<size>";
   C_Size   : constant String := "</size>";
   O_Point  : constant String := "<point>";
   C_Point  : constant String := "</point>";

   O_Circle : constant String := "<circle>";
   C_Circle : constant String := "</circle>";
   O_Square : constant String := "<square>";
   C_Square : constant String := "</square>";

   procedure Skip
     (S : access Streams.Root_Stream_Type'Class; N : Positive);
   --  Skip N characters from the stream

   function Read_Value
     (S : access Streams.Root_Stream_Type'Class) return String;
   --  Read an XML value (up to an opening bracket) and return it. Note that
   --  Read_Value will eat up the opening bracket.

   ----------
   -- Read --
   ----------

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Square) is
   begin
      Color'Read (S, O.Outline_Color);
      Point'Read (S, O.Corner1);
      Point'Read (S, O.Corner2);
   end Read;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Circle) is
   begin
      Color'Read (S, O.Outline_Color);
      Point'Read (S, O.Center);
      Size'Read (S, O.Radius);
   end Read;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Color) is
   begin
      Skip (S, O_Color'Length);
      O := Color'Value (Read_Value (S));
      Skip (S, C_Color'Length - 1);
   end Read;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Size) is
   begin
      Skip (S, O_Size'Length);
      O := Size'Value (Read_Value (S));
      Skip (S, C_Size'Length - 1);
   end Read;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Point) is
   begin
      Skip (S, O_Point'Length + 3);  -- skip also <x>
      O.X := Integer'Value (Read_Value (S));
      Skip (S, 6);                   --  skip /x><y>
      O.Y := Integer'Value (Read_Value (S));
      Skip (S, C_Point'Length + 3);  -- skip also /y>
   end Read;

   ----------------
   -- Read_Value --
   ----------------

   function Read_Value
     (S : access Streams.Root_Stream_Type'Class) return String
   is
      Buffer : String (1 .. 100);
      Last   : Natural := 0;
   begin
      loop
         Last := Last + 1;
         Character'Read (S, Buffer (Last));
         exit when Buffer (Last) = '<';
      end loop;

      return Buffer (1 .. Last - 1);
   end Read_Value;

   ----------
   -- Skip --
   ----------

   procedure Skip
     (S : access Streams.Root_Stream_Type'Class; N : Positive)
   is
      Buffer : String (1 .. N);
   begin
      String'Read (S, Buffer);
   end Skip;

   -----------
   -- Write --
   -----------

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Color) is
   begin
      String'Write (S, O_Color);
      String'Write (S, Color'Image (O));
      String'Write (S, C_Color);
   end Write;

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Size) is
   begin
      String'Write (S, O_Size);
      String'Write (S, Size'Image (O));
      String'Write (S, C_Size);
   end Write;

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Point) is
   begin
      String'Write (S, O_Point);
      String'Write (S, "<X>");
      String'Write (S, Integer'Image (O.X));
      String'Write (S, "</X>");
      String'Write (S, "<Y>");
      String'Write (S, Integer'Image (O.Y));
      String'Write (S, "</Y>");
      String'Write (S, C_Point);
   end Write;

   procedure Write
     (S : access Streams.Root_Stream_Type'Class;
      O : Square) is
   begin
      Color'Write (S, O.Outline_Color);
      Point'Write (S, O.Corner1);
      Point'Write (S, O.Corner2);
   end Write;

   procedure Write
     (S : access Streams.Root_Stream_Type'Class;
      O : circle) is
   begin
      Color'Write (S, O.Outline_Color);
      Point'Write (S, O.Center);
      Size'Write (S, O.Radius);
   end Write;

   ----------------
   -- XML_Output --
   ----------------

   procedure XML_Output
     (S : access Streams.Root_Stream_Type'Class;
      O : Object'Class)
   is
      Tag : constant String := Tags.External_Tag (O'Tag);
   begin
      String'Write (S, '<' & Tag & '>');
      Object'Output (S, O); --  Dispatching call; calls Object'Write.
      String'Write (S, "</" & Tag & '>');
   end XML_Output;

   -----------------------
   -- Dispatching_Input --
   -----------------------

   function Dispatching_Input is new Tags.Generic_Dispatching_Constructor
     (T           => Object,
      Parameters  => Streams.Root_Stream_Type'Class,
      Constructor => Object'Input);

   ---------------
   -- XML_Input --
   ---------------

   function XML_Input
     (S : access Streams.Root_Stream_Type'Class) return Object'Class
   is
      --  Read a tag of the form "<External_Tag>", then dispatch to reading
      --  the object.
      Buffer : String (1 .. 20);
      Last   : Natural := 0;
   begin
      --  First character must be a <

      Character'Read (S, Buffer (1));

      if Buffer (1) /= '<' then
         raise Ada.Tags.Tag_Error;
      end if;

      --  Read characters up to the closing >

      Last := 0;

      for I in Buffer'range loop
         Character'Read (S, Buffer (I));
         Last := I;
         exit when Buffer (I) = '>';
      end loop;

      if Last <= 1 or else Buffer (Last) /= '>' then
         --  No closing < or empty tag Empty tag
         raise Ada.Tags.Tag_Error;
      else
         Last := Last - 1;
      end if;

      declare
         Result : constant Object'Class :=
                 Dispatching_Input (Tags.Internal_Tag (Buffer (1 .. Last)), S);
         --  Dispatches to appropriate Object'Input for the tag read
      begin
         --  Before returning the object we want to skip the ending XML tag
         loop
            Character'Read (S, Buffer (1));
            exit when Buffer (1) = '>';
         end loop;

         return Result;
      end;
   end XML_Input;

end Graphic;
