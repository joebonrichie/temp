
with Ada.Text_IO.Text_Streams;

with Graphic;

procedure Main is

   use Ada;

   procedure Output (Object : Graphic.Object'Class);
   --  Output Object string representation into the screen

   ------------
   -- Output --
   ------------

   procedure Output (Object : Graphic.Object'Class) is
   begin
      Graphic.Object'Write
        (Text_IO.Text_Streams.Stream (Text_IO.Standard_Output), Object);
      Text_IO.New_Line;
   end Output;

   type Set is array (1 .. 2) of Graphic.Object_Access;

   Objects   : Set;
   R_Objects : Set;

   File    : Text_IO.File_Type;
   Stream  : Text_IO.Text_Streams.Stream_Access;

   Buffer  : String (1 .. 100);

begin
   Objects (1) := new Graphic.Square'
     (Graphic.Red, Corner1 => (0, 0), Corner2 => (10, 3));
   Objects (2) := new Graphic.Circle'
     (Graphic.Blue, Center => (1, 8), Radius => 10);

   --  Stream graphic objects now

   Text_IO.Create (File, Text_IO.Out_File, "graphics.xml");
   Stream := Text_IO.Text_Streams.Stream (File);

   String'Write (Stream, "<objects>");

   for K in Objects'Range loop
      Graphic.Object'Class'Output (Stream, Objects (K).all);
   end loop;

   String'Write (Stream, "</objects>");

   Text_IO.Close (File);

   --  Now read back the objects

   Text_IO.Open (File, Text_IO.In_File, "graphics.xml");
   Stream := Text_IO.Text_Streams.Stream (File);

   --  Skip <objects>

   String'Read (Stream, Buffer (1 .. 9));

   for K in Objects'Range loop
      R_Objects (K) :=
        new Graphic.Object'Class'(Graphic.Object'Class'Input (Stream));
   end loop;

   Text_IO.Close (File);

   --  Check that the objects read are valid and display them

   Text_IO.New_Line;
   Text_IO.Put_Line ("Check items and output them...");
   Text_IO.New_Line;

   declare
      use Graphic;
   begin
      for K in Objects'Range loop
         if Objects (K).all = R_Objects (K).all then
            Output (R_Objects (K).all);
         else
            Text_IO.Put_Line
              ("Error: object number" & Integer'Image (K) & " is wrong!");
         end if;
      end loop;
   end;

   Text_IO.New_Line;
end Main;
