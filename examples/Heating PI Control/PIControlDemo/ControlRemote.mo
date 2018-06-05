within PIControlDemo;

model ControlRemote "PI control implemented remotely (RPC server needed). TO BE IMPLEMENTED"
  extends PIControlDemo.ControlPartial;
  NumRPC.RCallPeriodic rCallPeriodicPI(fcode = 2, nin = 2, nout = 1, period = Ts)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex21 annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(multiplex21.y, rCallPeriodicPI.u) annotation(
    Line(points = {{-38, 0}, {-14, 0}, {-14, 0}, {-12, 0}}, color = {0, 0, 127}, thickness = 0.5));
  connect(ym, multiplex21.u2[1]) annotation(
    Line(points = {{-120, -40}, {-80, -40}, {-80, -6}, {-62, -6}, {-62, -6}}, color = {0, 0, 127}));
  connect(ysp, multiplex21.u1[1]) annotation(
    Line(points = {{-120, 20}, {-80, 20}, {-80, 6}, {-62, 6}, {-62, 6}}, color = {0, 0, 127}));
  connect(rCallPeriodicPI.y[1], u) annotation(
    Line(points = {{12, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}, thickness = 0.5));

annotation(
    Diagram(graphics = {Text(origin = {-9, 71}, extent = {{-91, 9}, {109, -31}}, textString = "TO BE CONTINUED (e.g. add state and parameters management)", textStyle = {TextStyle.Italic})}));end ControlRemote;