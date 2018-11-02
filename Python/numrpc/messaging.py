#!/usr/bin/python3
# -*- coding: utf-8 -*-
""" Message formatting (e.g. serialization) part of NumRPC

Pierre Haessig — October 2018
"""

import struct
from itertools import zip_longest

# Byte alignment (cf. https://docs.python.org/3.6/library/struct.html)

# possible choices
BO_NAT_SZ_NAT = '@' # Native Byte order. Native Size & Alignment
BO_NAT_SZ_STD = '=' # Native Byte order. Standard Size & no Alignment
BO_LE_SZ_STD = '<'  # Little-endian Byte order. Standard Size & no Alignment
BO_BE_SZ_STD = '>'  # Big-endian Byte order. Standard Size & no Alignment

ALN = BO_NAT_SZ_NAT

# type of the function code
CODE_T = "i" # int (signed)


def ssize(fmt):
    '''size of the struct described by `fmt`, with proper alignment setting.

    struct.calcsize(ALN + fmt)
    '''
    return struct.calcsize(ALN + fmt)


def pack(cmd, st=0, args=None):
    '''pack message with cmd, st (option), args (optional)
    
    Returns:
    (msg1, msg2): header message and payload message, if args
    (msg1, ):     header message alone if no args
    '''
    nargs = len(args) if args is not None else 0

    msg1 = struct.pack(ALN + CODE_T + CODE_T + "I", cmd, st, nargs)

    if nargs > 0:
        msg2 = struct.pack("d"*nargs, *args)
        return (msg1, msg2)
    else:
        return (msg1, )


def unpack_header(msg1):
    '''unpack cmd and nargs from the header message'''
    cmd, st, nargs = struct.unpack(ALN + CODE_T + CODE_T + "I", msg1)
    return cmd, st, nargs


def unpack_payload(msg2, nargs):
    '''unpack args from the payload message, given the number of args'''
    fmt = ALN + "d"*nargs
    args = struct.unpack(fmt, msg2)
    return args


def _hexfmt(message):
    '''format byte message using nice hexadecimal string'''
    # grouper recipe
    gr_args = [iter(message)] * 4
    grouper = zip_longest(*gr_args)

    assert (len(message)%4) == 0, 'only message with len multiple of 4 supported'

    s_list = []
    for g in grouper:
        fmt = ':'.join(['{:02x}']*4)
        s_list.append(fmt.format(*g))
    s = ' '.join(s_list)
    return s

def hexfmt(*messages):
    '''format byte messages using nice hexadecimal string'''
    s_list = [_hexfmt(m) for m in messages if len(m)>0]
    s = ' | '.join(s_list)
    return s

#m = b'\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08@\x00\x00\x00\x00\x00\x00\x04@'
#hexfmt(m)
