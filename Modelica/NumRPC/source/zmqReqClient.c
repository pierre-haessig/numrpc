#ifndef _ZMQ_REQ_CLIENT_
#define _ZMQ_REQ_CLIENT_


#include <zmq.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ModelicaUtilities.h>


typedef struct {
  void *context; /* ZMQ context*/
  void *socket; /* ZMQ socket */
} ZmqReqClient;


void* createZmqReqClient(char *endpoint) {
    ZmqReqClient *client = (ZmqReqClient *) malloc(sizeof(ZmqReqClient));
    if (client) {
        ModelicaFormatMessage("Creating ZMQ REQ socket to %s...", endpoint);
        client->context = zmq_ctx_new();
        client->socket = zmq_socket(client->context, ZMQ_REQ);
        int rc = zmq_connect(client->socket, endpoint);
        // TODO: check rc==0
        ModelicaFormatMessage("ZMQ REQ socket to %s is open.", endpoint);
    }
    else {
        free(client);
        client = NULL;
        ModelicaError("Memory allocation error");
    }
    return client;
}

void destroyZmqReqClient(void *object) {
    ZmqReqClient *client = (ZmqReqClient *) object;
    
    if (client==NULL) return;
    
    zmq_close(client->socket);
    zmq_ctx_destroy(client->context);
    //free(client->context);
    //free(client->socket);
    free(client);
    ModelicaFormatMessage("ZMQ REQ socket closed.");
}

#endif
