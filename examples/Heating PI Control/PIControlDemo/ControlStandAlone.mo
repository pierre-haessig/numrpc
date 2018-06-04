within PIControlDemo;

model ControlStandAlone "PI control, implemented purely in Modelica (no RPC needed)"
  extends PIControlDemo.ControlPartial;
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 10, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI PI(T = T, initType = Modelica.Blocks.Types.Init.InitialState, k = k, x_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ym, feedback1.u2) annotation(
    Line(points = {{-120, -40}, {-30, -40}, {-30, -8}, {-30, -8}}, color = {0, 0, 127}));
  connect(ysp, feedback1.u1) annotation(
    Line(points = {{-120, 20}, {-60, 20}, {-60, 0}, {-38, 0}, {-38, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, u) annotation(
    Line(points = {{62, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(PI.y, limiter1.u) annotation(
    Line(points = {{22, 0}, {38, 0}, {38, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, PI.u) annotation(
    Line(points = {{-20, 0}, {-4, 0}, {-4, 0}, {-2, 0}}, color = {0, 0, 127}));

end ControlStandAlone;