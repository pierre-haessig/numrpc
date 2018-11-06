within NumRPC.Examples;

model InitCallTest "Test a remote call in initial equation"
  extends Modelica.Icons.Example;
  inner NumRPC.Connection numrpcConn annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  NumRPC.RCallInit rCallInit42(cmd = 3, nin = 0, nout = 1) "give42" annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NumRPC.RCallInit rCallInitSquare(cmd = 1, nin = 1, nout = 1) "square"  annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(rCallInit42.y, rCallInitSquare.u) annotation(
    Line(points = {{2, -50}, {16, -50}, {16, -50}, {18, -50}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    Diagram(graphics = {Text(origin = {-9, 88}, extent = {{-91, 12}, {109, -28}}, textString = "Test remote calls in initial equation"), Text(origin = {29, 48}, extent = {{-109, 12}, {51, -14}}, textString = "needs a running NumRPC server
which implements at cmd=1 and cmd=3 \n a 1->1 function (e.g. square) \n and a 0->1 function (e.g. give42) respectively", textStyle = {TextStyle.Italic})}, coordinateSystem(initialScale = 0.1)));
end InitCallTest;