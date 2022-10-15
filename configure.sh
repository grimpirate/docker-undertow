#!/bin/sh

/home/jre/bin/java -jar /home/undertow-2022101501.jar 0.0.0.0 80 /home/public &> /dev/null &

exec sh