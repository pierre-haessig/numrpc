within NumRPC.Examples;

model StateTest "Test the state management aspect of remote calls"
  extends Modelica.Icons.Example;
  NumRPC.RCallPeriodic rCPer_Int(cmd = 4, nin = 1, period = 0.2, state_use = NumRPC.Interfaces.RCallTrigBase.StateUsage.int) annotation(
    Placement(visible = true, transformation(origin = {-10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner NumRPC.Connection numrpcConn annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  NumRPC.RCallPeriodic rCPer_Ext1(cmd = 4, nin = 1, period = 0.2, state_use = NumRPC.Interfaces.RCallTrigBase.StateUsage.ext) annotation(
    Placement(visible = true, transformation(origin = {-10, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.RCallPeriodic rCPer_Ext2(cmd = 4, nin = 1, period = 0.2, start = 0.02, state_use = NumRPC.Interfaces.RCallTrigBase.StateUsage.ext) annotation(
    Placement(visible = true, transformation(origin = {-10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.ExtState extState1(cmd = 4) annotation(
    Placement(visible = true, transformation(origin = {-70, -118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(extState1.st, rCPer_Ext1.st_ext) annotation(
    Line(points = {{-58, -118}, {-46, -118}, {-46, -78}, {-22, -78}, {-22, -78}}, color = {255, 127, 0}));
  connect(extState1.st, rCPer_Ext2.st_ext) annotation(
    Line(points = {{-58, -118}, {-24, -118}, {-24, -118}, {-22, -118}}, color = {255, 127, 0}));
  connect(const2.y, rCPer_Ext2.u[1]) annotation(
    Line(points = {{-58, -70}, {-34, -70}, {-34, -110}, {-22, -110}}, color = {0, 0, 127}));
  connect(const2.y, rCPer_Ext1.u[1]) annotation(
    Line(points = {{-58, -70}, {-22, -70}}, color = {0, 0, 127}));
  connect(const1.y, rCPer_Int.u[1]) annotation(
    Line(points = {{-59, -30}, {-22, -30}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics = {Text(origin = {-9, 88}, extent = {{-91, 12}, {109, -28}}, textString = "Test remote calls with state management"), Text(origin = {29, 48}, extent = {{-109, 12}, {51, -12}}, textString = "needs a running NumRPC server
which implements at cmd=4
a stateful function taking 1 arguments and returning 1
 (e.g. cumsum)", textStyle = {TextStyle.Italic}), Text(origin = {52, -22}, extent = {{-32, 2}, {28, -18}}, textString = "internal state init"), Text(origin = {52, -82}, extent = {{-32, 2}, {28, -18}}, textString = "external state init")}, coordinateSystem(extent = {{-100, -140}, {100, 100}})),
    __OpenModelica_commandLineOptions = "");
end StateTest;