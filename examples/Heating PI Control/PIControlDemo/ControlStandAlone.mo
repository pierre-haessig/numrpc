within PIControlDemo;

model ControlStandAlone "PI control, implemented purely in Modelica (no RPC needed)"
  extends PIControlDemo.ControlPartial;
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = 10, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Discrete.StateSpace PI_discrete(A = [1], B = [Ts / Ti], C = [k], D = [k], samplePeriod = Ts)  annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  PI_discrete.x[1] = 0.;
  PI_discrete.y[1] = 0.;
equation
  connect(feedback1.y, PI_discrete.u[1]) annotation(
    Line(points = {{-20, 0}, {-4, 0}, {-4, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(PI_discrete.y[1], limiter1.u) annotation(
    Line(points = {{22, 0}, {58, 0}, {58, 0}, {58, 0}}, color = {0, 0, 127}, thickness = 0.5));
  connect(limiter1.y, u) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(ym, feedback1.u2) annotation(
    Line(points = {{-120, -40}, {-30, -40}, {-30, -8}, {-30, -8}}, color = {0, 0, 127}));
  connect(ysp, feedback1.u1) annotation(
    Line(points = {{-120, 20}, {-60, 20}, {-60, 0}, {-38, 0}, {-38, 0}}, color = {0, 0, 127}));
end ControlStandAlone;