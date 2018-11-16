within NumRPC.Examples;

model StateTest "Test the state management aspect of remote calls"
extends Modelica.Icons.Example;
  NumRPC.RCallPeriodic rCallPeriodic1(cmd = 4, nin = 1, period = 0.1, state_use = NumRPC.Interfaces.RCallTrigBase.StateUsage.int)  annotation(
    Placement(visible = true, transformation(origin = {10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 2)  annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner NumRPC.Connection numrpcConn annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
equation
  connect(const.y, rCallPeriodic1.u[1]) annotation(
    Line(points = {{-58, -50}, {-2, -50}, {-2, -50}, {-2, -50}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics = {Text(origin = {-9, 88}, extent = {{-91, 12}, {109, -28}}, textString = "Test remote calls with state management"), Text(origin = {29, 48}, extent = {{-109, 12}, {51, -12}}, textString = "needs a running NumRPC server
which implements at cmd=4
a stateful function taking 1 arguments and returning 1
 (e.g. cumsum)", textStyle = {TextStyle.Italic}), Text(origin = {8, -30}, extent = {{-32, 2}, {32, -2}}, textString = "internal state init")}, coordinateSystem(initialScale = 0.1)));

end StateTest;