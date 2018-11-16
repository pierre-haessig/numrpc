within NumRPC;

block Connection "NumRPC block which holds the client connection"
  parameter String endpoint="tcp://localhost:5555" "connection endpoint of the ZMQ socket";
  output ZmqReqClient client = ZmqReqClient(endpoint);


  impure function scall "remote call cmd(inputs), with state"
    input ZmqReqClient client;
    input Integer cmd;
    input Integer st;
    input Real inputs[:];
    input Integer nout;
    output Real outputs[nout];
    output Integer st_res;
    
    external "C" st_res=scall(client, cmd, st, inputs, size(inputs,1), outputs, nout) annotation (Include="#include \"zmqRPC.c\"",
      IncludeDirectory="modelica://NumRPC/source");
  end scall;
  
  
  impure function call "remote call cmd(inputs)"
    input ZmqReqClient client;
    input Integer cmd;
    input Real inputs[:];
    input Integer nout;
    output Real outputs[nout];
    
  algorithm
    (outputs,) := scall(client, cmd, ST0, inputs, nout);
  end call;
  

  impure function state_init "initialize state for cmd command"
    input ZmqReqClient client;
    input Integer cmd;
    output Integer st_res;
    
  algorithm
    st_res := scall_no_io(client, cmd=STI, st=cmd);
  end state_init;


protected
  final constant Real EMPTY = {42} "approximation of an empty Real array, which are not valid in Modelica";
  
  
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
  
  
  impure function scall_no_io "remote call cmd with state st but no inputs and outputs"
    input ZmqReqClient client;
    input Integer cmd;
    input Integer st;
    output Integer st_res;
    
    external "C" st_res=scall_no_io(client, cmd, st) annotation (Include="#include \"zmqRPC.c\"",
      IncludeDirectory="modelica://NumRPC/source");
  end scall_no_io;
    
  annotation(
      defaultComponentName = "numrpcConn",
      defaultComponentPrefixes="inner",
  Icon(graphics = {Rectangle(lineColor = {136, 138, 133},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-200, 100}, {200, -100}}), Text(origin = {0, 70}, extent = {{-200, 20}, {200, -20}}, textString = "NumRPC Connection"), Text(origin = {0, -80}, lineColor = {0, 50, 127}, extent = {{-190, 20}, {190, -20}}, textString = "%endpoint"), Ellipse(origin = {-60, 0}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Ellipse(origin = {60, 0}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Line(points = {{-40, 0}, {40, 0}}, color = {0, 50, 127}, pattern = LinePattern.Dot, thickness = 0.5)}, coordinateSystem(extent = {{-200, -100}, {200, 100}})),
  __OpenModelica_commandLineOptions = "");
end Connection;
