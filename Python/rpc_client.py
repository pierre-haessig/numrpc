#   Minimal RPC client
#   Connects REQ socket to tcp://localhost:5555
#   Sends a stucture with 1 int code + list of doubles
#   Expects a list of doubles floats in return
#   PH May 2017


import time
import struct
import zmq
import ph_rpc as rpc

context = zmq.Context()

endpoint = "tcp://localhost:5555"

#  Socket to talk to server
print("Connecting to RPC server {}...".format(endpoint), end=' ')
socket = context.socket(zmq.REQ)
socket.connect(endpoint)
print('DONE.')

req_list = [
    (1, [3.0]), # -> call square(3.0)
    (2, [3.0, 2.5]), # -> call substract(3.0, 2.5)
    (5, [3.0]), # -> call unexisting function
    (1, [3.0, 2.5]), # -> wrong number of arguments
    (99, []) # -> function which raises an Exception

]

for request in req_list:
    print("Request: %s" % str(request))
    req_msg1, req_msg2 = rpc.pack(request[0],  request[1])
    print("Sending request:  %s..." % rpc.hexfmt(req_msg1, req_msg2))

    if req_msg2:
        socket.send(req_msg1, zmq.SNDMORE)
        socket.send(req_msg2)
    else:
        socket.send(req_msg1)

    #  Get the reply.
    messages = socket.recv_multipart()
    print("  Received reply: %s" % rpc.hexfmt(*messages))

    fcode, nargs = rpc.unpack_header(messages[0])

    if fcode == 0:
        print('  func found (fcode == 0)')
        try:
            out = rpc.unpack_payload(messages[1], 1)[0]
            print('  func output: %f' % out)
        except struct.error as e:
            print(e)

    elif fcode == -1:
        print('  func not found (fcode == -1)')
    elif fcode == -2:
        print('  wrong number of arguments (fcode == -2)')
    elif fcode == -3:
            print('  server could not decode args (fcode == -3)')
    elif fcode == -4:
        print('  func raised an Exception (fcode == -4)')
    else:
        print('  unexpected reply fcode %d' % fcode)

    print('')
    time.sleep(1)
