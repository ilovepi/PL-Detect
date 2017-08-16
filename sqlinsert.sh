#!/bin/sh

source sqlinsert.conf

PROJECTNAME="set @projectName=\"$1\";"
TESTNAME="set @testName=\"$2\";"
TESTDATE="set @testDate=NOW();"
COMMANDNAME="set @commandName=\"$3\";"
IS_SUCCESS="set @isSuccess=$4;"
if [ $# -gt 5 ]
then
    PROTOCOL_NAME="set @protocolName=\"${5}\";"
    HOSTIP="set @hostIP=\"$6\";"
    DESTIP="set @destIP=\"$7\";"
    SRC_PORT="set @srcPort=${8};"
    DEST_PORT="set @destPort=${9};"
    NUM_PACKETS="set @numPackets=${10};"
    NUM_TAIL="set @numTail=${11};"
    PACKET_SIZE="set @packetSize=${12};"
    TAIL_WAIT="set @tailWait=${13}"
    HIGH_LOSSSES="set @highLosses=\"${14}\";"
    LOW_LOSSES="set @lowLosses=\"${15}\";"
    HIGH_TIME="set @highTime=${16};"
    LOW_TIME="set @lowTime=${17};"
fi

SQL_VARIABLES="$PROJECTNAME $TESTNAME $TESTDATE $COMMANDNAME $HOSTIP $DESTIP $IS_SUCCESS $HIGH_TIME $LOW_TIME $HIGH_LOSSSES $LOW_LOSSES $NUM_TAIL $DEST_PORT $SRC_PORT $NUM_PACKETS $PACKET_SIZE $PROTOCOL_NAME"

SQL_COMMAND="$SQL_VARIABLES insert into data (project,test_name,test_date,command,host_ip, dest_ip, success, high_time, low_time, high_losses, low_losses, num_tail, dest_port, src_port, num_packets, packet_size, protocol) \
          Values (@projectName, @testName, @testDate, @commandName, @hostIP, @destIP , @isSuccess, @highTime, @lowTime, @highLosses, @lowLosses, @numTail, @destPort, @srcPort, @numPackets, @packetSize, @protocolName);"

#echo $SQL_COMMAND

mysql -u SLICE_NAME $PROJ -p$PSSWD -e "$SQL_COMMAND"
