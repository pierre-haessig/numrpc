within NumRPC;

block Connection "NumRPC block which holds the client connection"
  parameter String endpoint="tcp://localhost:5555" "connection endpoint of the ZMQ socket";
  output ZmqReqClient client = ZmqReqClient(endpoint);

  impure function rcall "remote call over ZMQ REQ socket"
    input ZmqReqClient client;
    input Integer fcode;
    input Real inputs[:];
    input Integer nout;
    output Integer success;
    output Real outputs[nout];
    
    external "C" success=rcall(client, fcode, inputs, size(inputs,1), outputs, nout) annotation (Include="#include \"zmqRPC.c\"",
      IncludeDirectory="modelica://NumRPC/source");
  end rcall;

protected
  type ZmqReqClient "state for a ZMQ REQ client, implemented in C"
    extends ExternalObject;
    
    function constructor "create connection client to a given endpoint"
      input String endpoint="tcp://localhost:5555" "endpoint of the ZMQ socket connection. format is 'transport://address'";
      output ZmqReqClient client;
      external "C" client=createZmqReqClient(endpoint)
        annotation(IncludeDirectory="modelica://NumRPC/source",
                   Library="zmq",
                   Include="#include \"zmqReqClient.c\"");
    end constructor;
  
    function destructor "close and destroy client"
      input ZmqReqClient client;
      external "C" destroyZmqReqClient(client)
        annotation(IncludeDirectory="modelica://NumRPC/source",
                   Library="zmq",
                   Include="#include \"zmqReqClient.c\"");
    end destructor;
  end ZmqReqClient;
  
  annotation(
      defaultComponentName = "numrpcConn",
      defaultComponentPrefixes="inner",
  Icon(graphics = {Rectangle(lineColor = {136, 138, 133},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-200, 100}, {200, -100}}), Text(origin = {0, 70}, extent = {{-200, 20}, {200, -20}}, textString = "NumRPC Connection"), Text(origin = {0, -80}, lineColor = {0, 50, 127}, extent = {{-190, 20}, {190, -20}}, textString = "%endpoint"), Ellipse(origin = {-60, 0}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Ellipse(origin = {60, 0}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Line(points = {{-40, 0}, {40, 0}}, color = {0, 50, 127}, pattern = LinePattern.Dot, thickness = 0.5)}, coordinateSystem(extent = {{-200, -100}, {200, 100}})),
  __OpenModelica_commandLineOptions = "");
end Connection;