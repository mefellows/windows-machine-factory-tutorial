#!/bin/sh
nuget restore -NonInteractive

docker build -t mefellows/machine-factory .
