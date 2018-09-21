#!/usr/bin/env bash
sudo apt-get update -y
sudo apt-get install nagios-nrpe-server nagios-plugins -y
echo "#############################################################################
# Sample NRPE Config File 
# Written by: Ethan Galstad (nagios@nagios.org)
# 
# Last Modified: 11-23-2007
#
# NOTES:
# This is a sample configuration file for the NRPE daemon.  It needs to be
# located on the remote host that is running the NRPE daemon, not the host
# from which the check_nrpe client is being executed.
#############################################################################


# LOG FACILITY
# The syslog facility that should be used for logging purposes.

log_facility=daemon



# PID FILE
# The name of the file in which the NRPE daemon should write it's process ID
# number.  The file is only written if the NRPE daemon is started by the root
# user and is running in standalone mode.

pid_file=/var/run/nagios/nrpe.pid



# PORT NUMBER
# Port number we should wait for connections on.
# NOTE: This must be a non-priviledged port (i.e. > 1024).
# NOTE: This option is ignored if NRPE is running under either inetd or xinetd

server_port=5666" > /etc/nagios/nrpe.cfg
sudo /etc/init.d/nagios-nrpe-server restart
 
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

