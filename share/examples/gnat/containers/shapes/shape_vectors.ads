with Ada.Containers.Vectors;
pragma Elaborate_All (Ada.Containers.Vectors);

with Shapes;  use Shapes;

package Shape_Vectors is
   new Ada.Containers.Vectors (Positive, Shape_Class_Access);

--pragma Preelaborate (Shape_Vectors);
