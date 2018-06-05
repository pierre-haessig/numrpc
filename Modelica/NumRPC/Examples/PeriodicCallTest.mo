within NumRPC.Examples;

model PeriodicCallTest
  extends Modelica.Icons.Example;
  NumRPC.RCallPeriodic rCallPeriodic1(fcode = 1, nin = 2, period = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex21 annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.5)  annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp1(duration = 1, height = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner NumRPC.Connection numrpcConn annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
equation
  connect(ramp1.y, multiplex21.u1[1]) annotation(
    Line(points = {{-59, -30}, {-50, -30}, {-50, -44}, {-46.5, -44}, {-46.5, -44}, {-43, -44}}, color = {0, 0, 127}));
  connect(const.y, multiplex21.u2[1]) annotation(
    Line(points = {{-59, -70}, {-51, -70}, {-51, -56}, {-43, -56}, {-43, -57}, {-43, -57}, {-43, -56}}, color = {0, 0, 127}));
  connect(multiplex21.y, rCallPeriodic1.u) annotation(
    Line(points = {{-19, -50}, {-2, -50}, {-2, -50}, {15, -50}, {15, -50}, {16, -50}, {16, -50}, {17, -50}}, color = {0, 0, 127}, thickness = 0.5));

annotation(
    Diagram(graphics = {Text(origin = {-9, 88}, extent = {{-91, 12}, {109, -28}}, textString = "Test of a periodic remote call"), Text(origin = {29, 48}, extent = {{-109, 12}, {51, -8}}, textString = "needs a running NumRPC server \n which implements at fcode=1\na function taking 2 arguments", textStyle = {TextStyle.Italic})}, coordinateSystem(initialScale = 0.1)));
end PeriodicCallTest;