# file: jlog.pyx
# encoding: utf-8

# Copyright (c) 2011 David Robinson
#
# This file is part of PyJlog.
#
# PyJLog is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PyJLog is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with PyJlog.  If not, see <http://www.gnu.org/licenses/>.

from cpython cimport PyString_FromStringAndSize
from cpython cimport PyString_AsStringAndSize
from cpython cimport PyString_AsString
cimport cjlog

BEGIN = cjlog.JLOG_BEGIN
END = cjlog.JLOG_END


class JLogError(Exception):

    def __init__(self, num, msg):
        self.num = num
        self.msg = msg

    def __str__(self):
        return repr(self.num), repr(self.msg)


cdef class Reader:

    cdef cjlog.jlog_ctx *_ctx
    cdef cjlog.jlog_id begin
    cdef cjlog.jlog_id end
    cdef int empty

    def __cinit__(self, path, reader):
        self._ctx = cjlog.jlog_new(path)
        if cjlog.jlog_ctx_open_reader(self._ctx, PyString_AsString(reader)) != 0:
            raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))
        self.empty = 1

    def __len__(self):
        cdef cjlog.jlog_id begin
        cdef cjlog.jlog_id end
        return cjlog.jlog_ctx_read_interval(self._ctx, &begin, &end)

    def __iter__(self):
        return self

    def __next__(self):
        cdef cjlog.jlog_message jlog_msg
        if self.empty:
            if cjlog.jlog_ctx_read_interval(self._ctx, &self.begin, &self.end) > 0:
                self.empty = 0
            else:
                raise StopIteration()

        if self.begin.marker <= self.end.marker:
            #print 'begin:', self.begin.marker
            #print 'end:', self.end.marker
            if (cjlog.jlog_ctx_read_message(self._ctx, &self.begin, &jlog_msg) == 0):
                msg = PyString_FromStringAndSize(
                        <char *>jlog_msg.mess,
                        jlog_msg.mess_len)
                #print msg
            else:
                raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))
            cjlog.JLOG_ID_ADVANCE(&self.begin)
            return msg
        else:
            cjlog.jlog_ctx_read_checkpoint(self._ctx, &self.end)
            self.empty = 1
            self.__next__()

    def __dealloc__(self):
        if self._ctx is not NULL:
            if cjlog.jlog_ctx_close(self._ctx) != 0:
                raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))
            self._ctx = NULL


cdef class Writer:

    cdef cjlog.jlog_ctx *_ctx
    cdef char* path

    def __cinit__(self, path):
        self._ctx = cjlog.jlog_new(path)
        self.path = path

        # Create log
        if cjlog.jlog_ctx_init(self._ctx) != 0:
            if cjlog.jlog_ctx_err(self._ctx) != 6:
                raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))
        if cjlog.jlog_ctx_close(self._ctx) != 0:
            raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))

        # Open writer
        self._ctx = cjlog.jlog_new(path)
        if cjlog.jlog_ctx_open_writer(self._ctx) != 0:
            raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))

    def write(self, msg):
        cdef char *msg_c = NULL
        cdef Py_ssize_t msg_len_c=0
        PyString_AsStringAndSize(msg, &msg_c, &msg_len_c)
        if cjlog.jlog_ctx_write(self._ctx, <void *>msg_c, msg_len_c) != 0:
            raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))

    cpdef add_subscriber(self, subscriber, position):
        cdef cjlog.jlog_ctx *ctx
        ctx = cjlog.jlog_new(self.path)
        if cjlog.jlog_ctx_add_subscriber(ctx, PyString_AsString(subscriber), position) != 0:
            raise JLogError(cjlog.jlog_ctx_err(ctx), cjlog.jlog_ctx_err_string(ctx))
        if cjlog.jlog_ctx_close(ctx) != 0:
            raise JLogError(cjlog.jlog_ctx_err(ctx), cjlog.jlog_ctx_err_string(ctx))

    cpdef remove_subscriber(self, subscriber):
        cdef cjlog.jlog_ctx *ctx
        ctx = cjlog.jlog_new(self.path)
        if cjlog.jlog_ctx_remove_subscriber(ctx, PyString_AsString(subscriber)) != 1:
            raise JLogError(cjlog.jlog_ctx_err(ctx), cjlog.jlog_ctx_err_string(ctx))
        if cjlog.jlog_ctx_close(ctx) != 0:
            raise JLogError(cjlog.jlog_ctx_err(ctx), cjlog.jlog_ctx_err_string(ctx))

    def __dealloc__(self):
        if self._ctx is not NULL:
            if cjlog.jlog_ctx_close(self._ctx) != 0:
                raise JLogError(cjlog.jlog_ctx_err(self._ctx), cjlog.jlog_ctx_err_string(self._ctx))
            self._ctx = NULL
