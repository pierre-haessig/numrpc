within NumRPC.Interfaces;

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
