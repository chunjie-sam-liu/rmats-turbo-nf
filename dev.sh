#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-12-22 22:02:15
# @DESCRIPTION:

# Number of input parameters
[ -d venv ] || eval '`which python3` -m venv venv'

[ -f venv/bin/activate ] && source venv/bin/activate
[ -f venv/Scripts/activate ] && source venv/Scripts/activate
pip install --upgrade pip
pip install -r requirements.txt