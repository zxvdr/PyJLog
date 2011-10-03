#!/usr/bin/env python

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

import jlog

LOG_PATH = '/tmp/testing'
SUBSCRIBER = 'subscriber'

writer = jlog.Writer(LOG_PATH)

try:
    writer.add_subscriber(SUBSCRIBER, jlog.BEGIN)
except jlog.JLogError:
    pass

writer.write('log entry 1')
writer.write('2nd log entry')
writer.write('the last log entry')

reader = jlog.Reader(LOG_PATH, SUBSCRIBER)
for item in reader:
    print item
