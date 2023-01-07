with Ada.Text_IO;
use Ada.Text_IO;

procedure arrman is

   array_length : Integer := 1000;
   type my_array is array (1 .. array_length) of Integer;
   a : my_array;
   task_count : Integer := array_length / 10;

   function part_sum (left : Integer; Right : Integer) return Integer is
      sum : Integer := 0;
      i   : Integer;
   begin
      i := left;
      while i <= Right loop
            sum := sum + a (i);
         i := i + 1;
      end loop;
      return sum;
   end part_sum;

   procedure create_array is
   begin
      for i in a'Range loop
         a (i) := i;
      end loop;
   end create_array;

   task type my_task is
      entry start(left, RigHt : in Integer);
      entry finish(sum1 : out Integer);
   end my_task;

   task body my_task is
      left, RigHt : Integer;
      sum : Integer := 0;

   begin
      accept start(left, RigHt : in Integer) do
         my_task.left := left;
         my_task.right := Right;
      end start;
      sum := part_sum (left, right);
      accept finish (sum1 : out Integer) do
         sum1 := sum;
      end finish;
   end my_task;

   tasks : array(1..task_count) of my_task;

   parts : array(1..task_count) of Integer;

   sum00 : integer;
begin
   create_array;
   sum00 := 0;
   --find simple sum
   for i in a'Range loop
      sum00 := sum00 + a(i);
   end loop;

   Put_Line("Simple sum: " & sum00'img);
	--start tasks
   for i in tasks'Range loop
      tasks(i).start(array_length / task_count * (i - 1) + 1,
        array_length / task_count * i);
      end loop;
	--finish tasks & get partial sums
   for i in tasks'Range loop
      tasks(i).finish(sum00);
      parts(i) := sum00;
   end loop;
   sum00 := 0;
   --find sum of partial sums
   for i in parts'Range loop
      sum00 := sum00 + parts(i);
   end loop;
   Put_Line("Multi thread sum: " & sum00'img);

end arrman;
