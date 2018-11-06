within PIControlDemo;

model ControlRemoteNS "PI control implemented remotely (RPC server needed). No state version"
  extends PIControlDemo.ControlPartial;
  NumRPC.RCallPeriodic rCallPeriodicPI(cmd = 4, nin = 3, nout = 1, period = Ts) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex3 multiplex31 annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.RCallInit rCallInitPIState(cmd = 1, nin = 0, nout = 1) "pi_state_init" annotation(
    Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.RCallInit rCallInitSetParams(cmd = 2, nin = 4, nout = 1) "pi_set_params" annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex4 multiplex41 annotation(
    Placement(visible = true, transformation(origin = {30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = Ts) annotation(
    Placement(visible = true, transformation(origin = {-50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = k) annotation(
    Placement(visible = true, transformation(origin = {-50, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = Ti) annotation(
    Placement(visible = true, transformation(origin = {-50, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(const1.y, multiplex41.u3[1]) annotation(
    Line(points = {{-39, -100}, {-28, -100}, {-28, -74}, {18, -74}}, color = {0, 0, 127}));
  connect(const2.y, multiplex41.u4[1]) annotation(
    Line(points = {{-39, -130}, {-20, -130}, {-20, -78}, {18, -78}, {18, -80}}, color = {0, 0, 127}));
  connect(const.y, multiplex41.u2[1]) annotation(
    Line(points = {{-39, -70}, {-32, -70}, {-32, -67}, {18, -67}}, color = {0, 0, 127}));
  connect(rCallInitPIState.y[1], multiplex41.u1[1]) annotation(
    Line(points = {{-39, -30}, {-20, -30}, {-20, -61}, {18, -61}}, color = {0, 0, 127}, thickness = 0.5));
  connect(multiplex31.u1[1], rCallInitPIState.y[1]) annotation(
    Line(points = {{-2, 7}, {-20, 7}, {-20, -30}, {-39, -30}}, color = {0, 0, 127}, thickness = 0.5));
  connect(multiplex41.y, rCallInitSetParams.u) annotation(
    Line(points = {{41, -70}, {58, -70}}, color = {0, 0, 127}, thickness = 0.5));
  connect(ysp, multiplex31.u2[1]) annotation(
    Line(points = {{-120, 20}, {-80, 20}, {-80, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(ym, multiplex31.u3[1]) annotation(
    Line(points = {{-120, -40}, {-80, -40}, {-80, -7}, {-2, -7}}, color = {0, 0, 127}));
  connect(multiplex31.y, rCallPeriodicPI.u) annotation(
    Line(points = {{21, 0}, {58, 0}}, color = {0, 0, 127}, thickness = 0.5));
  connect(rCallPeriodicPI.y[1], u) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    Diagram(graphics = {Text(origin = {-9, 71}, extent = {{-91, 9}, {109, -31}}, textString = "NumRPC implementation of the controller. 
Version without state support of NumRPC. 
Needs PI_Control_server_nostate.py running.", textStyle = {TextStyle.Italic})}, coordinateSystem(extent = {{-100, -150}, {100, 100}})),
    __OpenModelica_commandLineOptions = "");
end ControlRemoteNS;
