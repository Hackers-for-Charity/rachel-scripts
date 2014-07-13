#!/bin/bash
##############################################################################
# Hackers for Charity (http://hackersforcharity.org/education)
# setwanip.sh Setup Script (sam@hfc)
#
# Description:  Sets WAN IP in index.html for KA-Lite to eth0 IP (set by
# DHCP or to the default IP of 10.10.10.10.  
#
# Usage: You only need to run this script one time. Cut and paste or just 
# run this script to set the IPs in the index.html file to the current IP 
# on the eth0 interface. Once run, you must leave the script in the 
# scripts folder located here:  /home/pi/scripts/setwanip.sh
##############################################################################
mdkir -p /home/pi/scripts
cat > /home/pi/scripts/setwanip.sh << 'EOF'
#!/bin/bash
newip=$(/sbin/ifconfig |grep -A1 "eth0"| awk '{ if ( $1 == "inet" ) { print $2 }}'|cut -f2 -d":")
if [[ -z "$newip" ]]
then sed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/10.10.10.10/ /var/www/index.html
else
sed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$newip/ /var/www/index.html
fi
EOF
chmod +x /home/pi/scripts/setwanip.sh
sudo sed -i '13i\# Set the KA-Lite IP to the current WAN IP' /etc/rc.local
sudo sed -i '14i\/home\/pi\/setwanip.sh&' /etc/rc.local
