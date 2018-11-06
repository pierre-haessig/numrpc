within PIControlDemo;

model DemoRemote "Demo using the remote controller (RPC server needed)"
  extends Modelica.Icons.Example;
  PIControlDemo.Process process annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  PIControlDemo.ControlRemoteNS control annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse y_set_point(amplitude = 1, offset = 4, period = 10)  annotation(
    Placement(visible = true, transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner NumRPC.Connection numrpcConn annotation(
    Placement(visible = true, transformation(origin = {-60, -70}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
equation
  connect(y_set_point.y, control.ysp) annotation(
    Line(points = {{-59, 10}, {-54.5, 10}, {-54.5, 8}, {-44, 8}}, color = {0, 0, 127}));
  connect(process.y, control.ym) annotation(
    Line(points = {{62, 0}, {80, 0}, {80, -40}, {-60, -40}, {-60, -8}, {-44, -8}}, color = {0, 0, 127}));
  connect(control.u, process.u) annotation(
    Line(points = {{2, 0}, {16, 0}}, color = {0, 0, 127}));

  annotation(experiment(StartTime = 0, StopTime = 20),
    Diagram(graphics = {Text(origin = {0, 70}, extent = {{-80, 10}, {80, -10}}, textString = "PI control demo, using remote controller")}));
end DemoRemote;