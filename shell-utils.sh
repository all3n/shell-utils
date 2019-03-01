#!/usr/bin/env bash
bin=`dirname "$0"`
export APP_DIR=`cd "$bin/"; pwd`

#
# shell-utils.sh
# Copyright (C) 2019 wanghuacheng <wanghuacheng@wanghuacheng-PC>
#
# Distributed under terms of the MIT license.
#
##### load utils start
source $APP_DIR/utils/common-utils.sh


UTILS_SCRIPT=`ls $APP_DIR/utils/*.sh|grep -v common-utils.sh`
for UTS in $UTILS_SCRIPT;do
    source $UTS
done

