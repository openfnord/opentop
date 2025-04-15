
  ip link add br10 type bridge
  ip addr add 10.10.10.0/255.255.255.0 dev br10
  ip link set br10 up

  iptables -t nat -A POSTROUTING -s 10.10.10.0/255.255.255.0 \
        -o eth0 -j MASQUERADE >/dev/null 2>&1

  ip netns add thenamespace
  ip link add dev veth0_42 type veth peer name veth1_42
  ip link set dev veth0_42 up
  ip link set veth0_42 master br10
  ip link set veth1_42 netns thenamespace
  ip netns exec thenamespace ip link set dev lo up
  ip netns exec thenamespace ip link set veth1_42 address "00:80:41:00:00:01"
  ip netns exec thenamespace ip addr add 10.10.10.23/255.255.255.0 dev veth1_42
  ip netns exec thenamespace ip link set dev veth1_42 up

 #this is what the network looks like
 #inside
 ip netns exec thenamespace ip addr
 #outside
 ip addr

 #now we run a server in the namespace thenamespace and try to connect from outside and from inside
 ip netns exec thenamespace nc -l 2000

 #now we connect from outside without success
 telnet 10.10.10.23 2000

 #now we enter the namespace and connect to the server sucessfully and type the magic words
 ip netns exec thenamespace telnet 10.10.10.23 2000
 Trying 10.10.10.23...
 Connected to 10.10.10.23.
 Escape character is '^]'.




