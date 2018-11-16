#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""Demo of a NumRPC server

Pierre Haessig — October 2018
"""

import numrpc

# Functions to serve:
def square(a):
    return a*a

def substract(a, b):
    return a - b

def give42():
    return 42

def cumsum_state_init(state):
    state['sum'] = 0

def cumsum(state, a):
    state['sum'] += a
    return state['sum']

def fail_fun():
    raise Exception('failing func')


server = numrpc.Server("tcp://*:5555")
server.register(1, square, 1, 1)
server.register(2, substract, 2, 1)
server.register(3, give42, 0, 1)
server.register(4, cumsum, 1, 1, state_init=cumsum_state_init)
server.register(99, fail_fun, 0, 0)

server.start()
