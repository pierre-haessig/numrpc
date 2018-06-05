#ifndef _ZMQ_RPC_
#define _ZMQ_RPC_


#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ModelicaUtilities.h>

typedef struct {
    int fcode;
    unsigned int nargs;
} header_t;

/*helper functions*/

int send_call(void* requester, header_t* call_h_p, double* call_args) {
    int rc;
    char* msg1 = (char*) call_h_p;
    char* msg2 = (char*) call_args;
    
    int nargs = call_h_p->nargs;
    
    ModelicaFormatMessage("Sending request for func %d with %d args...", call_h_p->fcode, nargs);
    
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
    int rcode = header_p->fcode;
    
    if (rcode == -1) ModelicaError("Server error: requested function code not found");
    if (rcode == -2) ModelicaError("Server error: wrong number of calling args");
    if (rcode == -3) ModelicaError("Server error: arg decoding error");
    if (rcode !=  0) ModelicaError("Server error of unknown kind");
    
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


/*Make the remote call. Returns the rcode (0 if success)*/
int rcall(void *object, int fcode, double* inputs, size_t nin, double* outputs, size_t nout) {

    ZmqReqClient *client = (ZmqReqClient *) object;
    
    // Send the call
    header_t call_h;
    call_h.fcode = fcode;
    call_h.nargs = nin;
    
    send_call(client->socket, &call_h, inputs);
    
    // get the response
    header_t head;
    int more = recv_header(client->socket, &head);
    ModelicaFormatMessage("Response rcode %d, nargs %d. More msg parts=%d", 
        head.fcode, head.nargs, more);
    
    if (head.nargs == 0) {
        ModelicaMessage("No args to receive.");
    }
    
    else if (head.nargs>0 && head.nargs == nout) {
        ModelicaMessage("Receiving args...");
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

    return head.fcode;
}

#endif