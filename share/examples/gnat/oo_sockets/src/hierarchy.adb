with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Tags;     use Ada.Tags;

package body Hierarchy is

   -----------
   -- Print --
   -----------

   procedure Print (This : Base) is
   begin
      --  We display the type's name (strictly, the tag) and then the priority.
      --  Note the conversion of the formal parameter 'This' to the class-wide
      --  type. This conversion is for the sake of any potential redispatching,
      --  which does in fact occur in the overridden version for type Child.
      Put_Line ("Read value of tagged type " &
                External_Tag (Base'Class (This)'Tag));
      Put_Line ("   Priority:" & This.Priority'Img);
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (This : Child) is
   begin
      --  We first convert to the specific type Base to invoke the parent's
      --  version of the Print routine, a la "super" in Smalltalk ...
      Print (Base (This));
      --  ... and then display the extension-specific component.
      Put_Line ("   Value: " & This.Value);
   end Print;

end Hierarchy;
