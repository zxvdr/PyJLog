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

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
    name = 'pyjlog',
    version = '0.1',
    #packages = ['jlog',],
    author = "David Robinson",
    author_email = "zxvdr.au@gmail.com",
    url = 'http://github.com/zxvdr/pyjlog',
    download_url = 'http://github.com/zxvdr/pyjlog/downloads',
    description = "Python bindings for JLog.",
    license = 'GPL',
    cmdclass = {'build_ext': build_ext},
    ext_modules = [
    Extension("jlog", ["jlog.pyx"],
              libraries=["jlog"])
    ]
)
