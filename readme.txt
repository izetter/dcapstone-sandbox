Currently it works, only iy takes a few minutes after the EC2 has bein stopped and restarted for the Elastic IP to be removed.
Seems to work only if the instance is stopped and then started, because rebooting seems to not
change the state of the EC2 and keep the "running" all the time, thus the trigger never happens

Also, currently the restarted EC2 will get a new public but non Elastic IP address after the Elastic has been removed