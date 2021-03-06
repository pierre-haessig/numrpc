within PIControlDemo;

model ControlRemote "PI control implemented remotely (RPC server needed). TO BE IMPLEMENTED"
  extends PIControlDemo.ControlPartial;
  NumRPC.RCallPeriodic rCallPeriodicPI(cmd = 4, nin = 3, nout = 1, period = Ts)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex3 multiplex31 annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.RCallInit rCallInitPIState(cmd = 1,nin = 0, nout = 1)  "pi_state_init" annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.RCallInit rCallInit2(cmd = 2,nin = 4, nout = 1)  "pi_set_params" annotation(
    Placement(visible = true, transformation(origin = {66, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex4 multiplex41 annotation(
    Placement(visible = true, transformation(origin = {30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = Ts)  annotation(
    Placement(visible = true, transformation(origin = {-90, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = k) annotation(
    Placement(visible = true, transformation(origin = {-60, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = Ti) annotation(
    Placement(visible = true, transformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(multiplex31.u1[1], rCallInitPIState.y[1]) annotation(
    Line(points = {{-2, 7}, {-32, 7}, {-32, -50}, {-38, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(ysp, multiplex31.u2[1]) annotation(
    Line(points = {{-120, 20}, {-80, 20}, {-80, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(ym, multiplex31.u3[1]) annotation(
    Line(points = {{-120, -40}, {-80, -40}, {-80, -7}, {-2, -7}}, color = {0, 0, 127}));
  connect(multiplex31.y, rCallPeriodicPI.u) annotation(
    Line(points = {{21, 0}, {58, 0}}, color = {0, 0, 127}, thickness = 0.5));
  connect(rCallPeriodicPI.y[1], u) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}, thickness = 0.5));
  connect(const2.y, multiplex41.u4[1]) annotation(
    Line(points = {{-18, -110}, {-8, -110}, {-8, -78}, {18, -78}, {18, -80}}, color = {0, 0, 127}));
  connect(const1.y, multiplex41.u3[1]) annotation(
    Line(points = {{-48, -90}, {-34, -90}, {-34, -74}, {18, -74}, {18, -74}}, color = {0, 0, 127}));
  connect(const.y, multiplex41.u2[1]) annotation(
    Line(points = {{-78, -70}, {-44, -70}, {-44, -67}, {18, -67}}, color = {0, 0, 127}));
  connect(rCallInitPIState.y[1], multiplex41.u1[1]) annotation(
    Line(points = {{-38, -50}, {-32, -50}, {-32, -61}, {18, -61}}, color = {0, 0, 127}, thickness = 0.5));
  connect(multiplex41.y, rCallInit2.u) annotation(
    Line(points = {{41, -70}, {55, -70}, {55, -70}, {53, -70}}, color = {0, 0, 127}, thickness = 0.5));

annotation(
    Diagram(graphics = {Text(origin = {-9, 71}, extent = {{-91, 9}, {109, -31}}, textString = "NumRPC implementation of the controller. \n Version without state support of NumRPC. \n Needs PI_Control_server_nostate.py running.", textStyle = {TextStyle.Italic})}, coordinateSystem(initialScale = 0.1)));end ControlRemote;