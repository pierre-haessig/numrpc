within NumRPC.Interfaces;

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
