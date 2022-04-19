
--  This is a simple demo of the new Ada.Tags.Generic_Dispatching_Constructor
--  feature. It make it possible to dispatch to a given constructor based on a
--  tag. This example create an simple object hierarchy:
--
--     Object (abstract)
--        |
--        |-> Square
--        |
--        --> Circle
--
--  Read and Write attributes are redefined on Square and Circle to support XML
--  streaming.
--  Class'Input and Class'Output are redefined on Object to handle object's tag
--  as XML string.

with Ada.Streams;
with Ada.Tags;

package Graphic is

   use Ada;

   -----------
   -- Color --
   -----------

   type Color is (Red, Green, Blue);

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Color);
   for Color'Write use Write;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Color);
   for Color'Read use Read;

   ------------
   -- Object --
   ------------

   type Object is abstract tagged record
      Outline_Color : Color;
   end record;

   type Object_Access is access all Object'Class;

   procedure XML_Output
     (S : access Streams.Root_Stream_Type'Class; O : Object'Class);
   for Object'Class'Output use XML_Output;
   --  Stream object O using XML

   function XML_Input
     (S : access Streams.Root_Stream_Type'Class) return Object'Class;
   for Object'Class'Input use XML_Input;
   --  Read an XML object from the Stream and return the corresponding object

   -----------
   -- Point --
   -----------

   type Point is record
      X, Y : Integer;
   end record;

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Point);
   for Point'Write use Write;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Point);
   for Point'Read use Read;

   ----------
   -- Size --
   ----------

   type Size is new Natural;

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Size);
   for Size'Write use Write;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Size);
   for Size'Read use Read;

   ------------
   -- Square --
   ------------

   type Square is new Object with record
      Corner1, Corner2 : Point;
   end record;

   for Square'External_Tag use "square";

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Square);
   for Square'Write use Write;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Square);
   for Square'Read use Read;

   ------------
   -- Circle --
   ------------

   type Circle is new Object with record
      Center : Point;
      Radius : Size;
   end record;

   for Circle'External_Tag use "circle";

   procedure Write
     (S : access Streams.Root_Stream_Type'Class; O : Circle);
   for Circle'Write use Write;

   procedure Read
     (S : access Streams.Root_Stream_Type'Class; O : out Circle);
   for Circle'Read use Read;

end Graphic;
