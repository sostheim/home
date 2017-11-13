#/bin/sh

UNUSED=("ac-staging-internal-lb", "10.142.15.204:30203",
"gtc-staging-internal-lb", "10.142.15.203:30222",
"gprsd-staging-internal-lb", "10.142.15.201:30162",
"test-internal-lb", "10.142.15.111:30091" )

GPRSD_PING="\x02\x01\x09\x81\x04\x03\xbb\x2c\x03"

# NOTE: These pod IP addresses, the one's at the end of the line,
#       are only valid for the life of the current pod.  They need
#       to be updated every time the pod restarts.
VIPS=( 
"admin-console-internal-lb" "10.142.14.100:30100" "TCP" "10.142.0.11:30100" 
"gprsd-internal-lb" "10.142.15.14:30062" "UDP" "10.142.0.5:30062" 
"gtc-internal-lb" "10.142.14.102:30102" "TCP" "10.142.0.5:30102"
"jenkins-internal-lb" "10.142.15.15:30061" "TCP" "10.142.0.4:30061"
)

VIPS_LEN=${#VIPS[@]}

echo "Running VIP connectivity check"
echo "*** curl -V ***"
curl -V
echo "*** *** *** *** *** Begin Test *** *** *** *** ***"
for (( i=0; i<${VIPS_LEN}; i+=4 ));
do
  echo "***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** "
  echo "----> Attempting to contact load balancer: ${VIPS[$i]}, at: ${VIPS[$i+1]}, proto: ${VIPS[$i+2]} **** "
  lbip=$( echo ${VIPS[$i+1]} | cut -d\: -f1 )
  lbport=$( echo ${VIPS[$i+1]} | cut -d\: -f2 )
  if [ "${VIPS[$i+2]}" == "TCP" ]; then
    echo "----> curl --connect-timeout 10 -m 15 -vsk http://${VIPS[$i+1]}/"
    curl --connect-timeout 10 -m 15 -vsk http://${VIPS[$i+1]}/
  else 
    echo "----> nc -w 10 -n -v ${lbip} ${lbport}"
    echo ${GPRSD_PING} | nc -v -w 10 -n -u ${lbip} ${lbport}
  fi 
  echo "----> traceroute load balancer ip: ${lbip}"
  traceroute ${lbip}


  echo "----> Attempting to contact service directly at node address: ${VIPS[$i+3]} **** "
  nodeip=$( echo ${VIPS[$i+3]} | cut -d\: -f1 )
  nodeport=$( echo ${VIPS[$i+3]} | cut -d\: -f2 )
  if [ "${VIPS[$i+2]}" == "TCP" ]; then
    echo "----> curl --connect-timeout 10 -m 15 -vsk http://${VIPS[$i+3]}/"
    curl --connect-timeout 10 -m 15 -vsk http://${VIPS[$i+3]}/
  else 
    echo "----> nc -w 10 -n -v ${nodeip} ${nodeport}"
    echo ${GPRSD_PING} | nc -v -w 10 -n -u ${nodeip} ${nodeport}
  fi 

  echo "----> traceroute node ip: ${nodeip}"
  traceroute ${nodeip}
  if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "----> get route for node ip: ${nodeip}"
    ip route get ${nodeip}   
  fi
  echo "----> ping -c 3 ${nodeip}"
  ping -c 3 ${nodeip}
done

