# file: cjlog.pxd

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

cdef extern from "jlog.h":

    ctypedef struct jlog_ctx:
        pass

    ctypedef struct jlog_message_header:
        int reserved
        int tv_sec
        int tv_usec
        int mlen

    ctypedef struct jlog_id:
        int log
        int marker

    ctypedef struct jlog_message:
        jlog_message_header *header
        int mess_len
        void *mess
        jlog_message_header aligned_header


    ctypedef enum jlog_position:
        JLOG_BEGIN
        JLOG_END

    ctypedef enum jlog_safety:
        JLOG_UNSAFE,
        JLOG_ALMOST_SAFE,
        JLOG_SAFE

    ctypedef enum jlog_err:
        JLOG_ERR_SUCCESS = 0
        JLOG_ERR_ILLEGAL_INIT
        JLOG_ERR_ILLEGAL_OPEN
        JLOG_ERR_OPEN
        JLOG_ERR_NOTDIR
        JLOG_ERR_CREATE_PATHLEN
        JLOG_ERR_CREATE_EXISTS
        JLOG_ERR_CREATE_MKDIR
        JLOG_ERR_CREATE_META
        JLOG_ERR_LOCK
        JLOG_ERR_IDX_OPEN
        JLOG_ERR_IDX_SEEK
        JLOG_ERR_IDX_CORRUPT
        JLOG_ERR_IDX_WRITE
        JLOG_ERR_IDX_READ
        JLOG_ERR_FILE_OPEN
        JLOG_ERR_FILE_SEEK
        JLOG_ERR_FILE_CORRUPT
        JLOG_ERR_FILE_READ
        JLOG_ERR_FILE_WRITE
        JLOG_ERR_META_OPEN
        JLOG_ERR_ILLEGAL_WRITE
        JLOG_ERR_ILLEGAL_CHECKPOINT
        JLOG_ERR_INVALID_SUBSCRIBER
        JLOG_ERR_ILLEGAL_LOGID
        JLOG_ERR_SUBSCRIBER_EXISTS
        JLOG_ERR_CHECKPOINT
        JLOG_ERR_NOT_SUPPORTED

    jlog_ctx* jlog_new(char *path)
    #voidjlog_set_error_func(jlog_ctx *ctx, jlog_error_func Func, void *ptr);
    #size_t jlog_raw_size(jlog_ctx *ctx)
    int jlog_ctx_init(jlog_ctx *ctx)
    #int jlog_get_checkpoint(jlog_ctx *ctx, const char *s, jlog_id *id)
    #int jlog_ctx_list_subscribers_dispose(jlog_ctx *ctx, char **subs)
    #int jlog_ctx_list_subscribers(jlog_ctx *ctx, char ***subs)

    int jlog_ctx_err(jlog_ctx *ctx)
    char * jlog_ctx_err_string(jlog_ctx *ctx)
    int jlog_ctx_errno(jlog_ctx *ctx)
    int jlog_ctx_open_writer(jlog_ctx *ctx)
    int jlog_ctx_open_reader(jlog_ctx *ctx, char *subscriber)
    int jlog_ctx_close(jlog_ctx *ctx)

    #int jlog_ctx_alter_mode(jlog_ctx *ctx, int mode)
    #int jlog_ctx_alter_journal_size(jlog_ctx *ctx, size_t size)
    #int jlog_ctx_alter_safety(jlog_ctx *ctx, jlog_safety safety)
    int jlog_ctx_add_subscriber(jlog_ctx *ctx, char *subscriber,
            jlog_position whence)
    int jlog_ctx_remove_subscriber(jlog_ctx *ctx, char *subscriber)

    int jlog_ctx_write(jlog_ctx *ctx, void *message, size_t mess_len)
    #int jlog_ctx_write_message(jlog_ctx *ctx, jlog_message *msg, struct timeval *when)
    int jlog_ctx_read_interval(jlog_ctx *ctx,
            jlog_id *first_mess, jlog_id *last_mess)
    int jlog_ctx_read_message(jlog_ctx *ctx, jlog_id *, jlog_message *)
    int jlog_ctx_read_checkpoint(jlog_ctx *ctx, jlog_id *checkpoint)
    #int jlog_snprint_logid(char *buff, int n, jlog_id *checkpoint)

    #int __jlog_pending_readers(jlog_ctx *ctx, int log)
    #int jlog_ctx_first_log_id(jlog_ctx *ctx, jlog_id *id)
    #int jlog_ctx_last_log_id(jlog_ctx *ctx, jlog_id *id)
    #int jlog_ctx_advance_id(jlog_ctx *ctx, jlog_id *cur,
    #        jlog_id *start, jlog_id *finish)
    void JLOG_ID_ADVANCE(jlog_id *)

BEGIN = JLOG_BEGIN
END = JLOG_END
