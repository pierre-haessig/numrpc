#ifndef _ZMQ_RPC_
#define _ZMQ_RPC_


#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ModelicaUtilities.h>

#define ROK      0
#define RE_FNF  -1
#define RE_WNA  -2
#define RE_DEC  -3
#define RE_STI  -4
#define RE_SES  -5

typedef struct {
    int cmd; /*requested command id, or return code */
    int st;  /*state id*/
    unsigned int nargs;
} header_t;

/*helper functions*/

int send_call(void* requester, header_t* call_h_p, double* call_args) {
    int rc;
    char* msg1 = (char*) call_h_p;
    char* msg2 = (char*) call_args;
    
    int nargs = call_h_p->nargs;
    
    //ModelicaFormatMessage("Sending request for func %d with %d args...", call_h_p->cmd, nargs);
    
    if (nargs>0) {
        rc = zmq_send(requester, msg1, sizeof(header_t), ZMQ_SNDMORE);
        if (rc != sizeof(header_t)) {
            ModelicaFormatError(
                "Error sending header: %s", zmq_strerror(zmq_errno())
                );
            
            }
        
        rc = zmq_send(requester, msg2, nargs * sizeof(double), 0);
        if (rc != nargs * sizeof(double)) ModelicaFormatError(
            "Error sending args: %s", zmq_strerror(zmq_errno())
            );
    }
    else {
        rc = zmq_send(requester, msg1, sizeof(header_t), 0);
        if (rc != sizeof(header_t)) ModelicaFormatError(
            "Error sending header alone: %s", zmq_strerror(zmq_errno())
            );
    }
    
    return 0;
}

/* helper to check if another message part should be received */
int msg_more(void* socket) {
    int more;
    size_t more_size = sizeof (more);
    zmq_getsockopt (socket, ZMQ_RCVMORE, &more, &more_size);
    return more;
}


int recv_header(void* requester, header_t* header_p) {
    int rc;
    char* msg = (char*) header_p;
    
    rc = zmq_recv(requester, msg, sizeof(header_t), 0);
    if (rc != sizeof(header_t)) ModelicaFormatError(
        "Error receiving header: %s", zmq_strerror(zmq_errno())
        );
        
    /* Check if a next message is coming*/
    int more = msg_more(requester);
    /* Check header coherence */
    if (more > 0 && header_p->nargs <= 0) ModelicaError(
        "Incoherent header: more msg parts to receive but no args announced!");
    if (more == 0 && header_p->nargs > 0) ModelicaError(
        "Incoherent header: args announced, but no further msg parts to receive");
    
    /* Check rcode */
    int rcode = header_p->cmd;
    
    if (rcode == RE_FNF) ModelicaError("NumRPC server error: requested function code not found");
    if (rcode == RE_WNA) ModelicaError("NumRPC server error: wrong number of calling args");
    if (rcode == RE_DEC) ModelicaError("NumRPC server error: arg decoding error");
    if (rcode != ROK) ModelicaFormatError("NumRPC server error of unknown kind: rcode=%d", rcode);
    
    return more;
}


void recv_args(void* requester, unsigned int nargs, double* call_args) {    
    int rc;
    char* msg = (char*) call_args;
    
    rc = zmq_recv(requester, msg, nargs * sizeof(double), 0);
    if (rc != nargs * sizeof(double)) ModelicaFormatError(
        "Error receiving args: %s", zmq_strerror(zmq_errno())
        );
}


/*function exposed in Modelica*/


/* Make the remote call, with state */
int scall(void *object, int cmd, int st, double* inputs, size_t nin, double* outputs, size_t nout) {

    ZmqReqClient *client = (ZmqReqClient *) object;
    
    // Send the call
    header_t call_h;
    call_h.cmd = cmd;
    call_h.st = st;
    call_h.nargs = nin;
    
    send_call(client->socket, &call_h, inputs);
    
    // Get the response
    header_t head;
    int more = recv_header(client->socket, &head);
    //ModelicaFormatMessage("Response rcode %d, nargs %d. More msg parts=%d", 
    //    head.cmd, head.nargs, more);
    
    if (head.nargs == 0) {
    //    ModelicaMessage("No args to receive.");
    }
    
    else if (head.nargs>0 && head.nargs == nout) {
    //    ModelicaMessage("Receiving args...");
        recv_args(client->socket, head.nargs, outputs);
    }
    else if (head.nargs>0 && head.nargs != nout) {
        ModelicaFormatError(
            "Cannot receive args: %d args expected, but %d advertised in header!",
            nout, head.nargs);
    }
    else {
        ModelicaError("Cannot receive args for unexpected reason");
    }
    return head.st;
}


int scall_no_io(void *object, int cmd, int st) {

    ZmqReqClient *client = (ZmqReqClient *) object;
    
    // Send the call
    header_t call_h;
    call_h.cmd = cmd;
    call_h.st = st;
    call_h.nargs = 0;
    
    send_call(client->socket, &call_h, (double*) NULL);
    
    // Get the response
    header_t head;
    int more = recv_header(client->socket, &head);
    //ModelicaFormatMessage("Response rcode %d, nargs %d. More msg parts=%d", 
    //    head.cmd, head.nargs, more);
    
   if (head.nargs>0) {
        ModelicaFormatError(
            "No args expected in response, but %d advertised in header!",
            head.nargs);
    }
    return head.st;
}

#endif
