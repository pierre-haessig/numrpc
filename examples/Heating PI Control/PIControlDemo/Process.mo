within PIControlDemo;

block Process "the physical heating process to control"
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1, initType = Modelica.Blocks.Types.Init.InitialState, k = 0.25, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lag( T = 0.2,initType = Modelica.Blocks.Types.Init.InitialState, k = 1, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u "heating power, in [0, 10]" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y "temperature, in [0, 10]" annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 10, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant y0(k = 3)  annotation(
    Placement(visible = true, transformation(origin = {10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = 10, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(limiter2.y, lag.u) annotation(
    Line(points = {{-58, 0}, {-52, 0}, {-52, 20}, {-42, 20}, {-42, 20}}, color = {0, 0, 127}));
  connect(u, limiter2.u) annotation(
    Line(points = {{-120, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, y) annotation(
    Line(points = {{102, 0}, {122, 0}, {122, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(add1.y, limiter1.u) annotation(
    Line(points = {{62, 0}, {76, 0}, {76, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(lag.y, firstOrder1.u) annotation(
    Line(points = {{-19, 20}, {-3, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add1.u1) annotation(
    Line(points = {{21, 20}, {29.5, 20}, {29.5, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(y0.y, add1.u2) annotation(
    Line(points = {{22, -30}, {28, -30}, {28, -6}, {38, -6}}, color = {0, 0, 127}));
annotation(
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1), graphics = {Text(origin = {4, 75}, extent = {{-144, 15}, {136, -15}}, textString = "Heating process (first order with a small extra lag and offset)")}),
    __OpenModelica_commandLineOptions = "",
  Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, 80}, {80, -80}}, textString = "Heating\nProcess")}));end Process;