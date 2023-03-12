
Q1.1 What is the output of “nodes” and “net”? 
        nodes:
        available nodes are: 
        h1 h2 h3 h4 h5 h6 h7 h8 s1 s2 s3 s4 s5 s6 s7
    
        net:
        h1 h1-eth0:s3-eth2
        h2 h2-eth0:s3-eth3
        h3 h3-eth0:s4-eth2
        h4 h4-eth0:s4-eth3
        h5 h5-eth0:s6-eth2
        h6 h6-eth0:s6-eth3
        h7 h7-eth0:s7-eth2
        h8 h8-eth0:s7-eth3
        s1 lo:  s1-eth1:s2-eth1 s1-eth2:s5-eth1
        s2 lo:  s2-eth1:s1-eth1 s2-eth2:s3-eth1 s2-eth3:s4-eth1
        s3 lo:  s3-eth1:s2-eth2 s3-eth2:h1-eth0 s3-eth3:h2-eth0
        s4 lo:  s4-eth1:s2-eth3 s4-eth2:h3-eth0 s4-eth3:h4-eth0
        s5 lo:  s5-eth1:s1-eth2 s5-eth2:s6-eth1 s5-eth3:s7-eth1
        s6 lo:  s6-eth1:s5-eth2 s6-eth2:h5-eth0 s6-eth3:h6-eth0
        s7 lo:  s7-eth1:s5-eth3 s7-eth2:h7-eth0 s7-eth3:h8-eth0

Q1.2 What is the output of “h7 ifconfig”? 

        h7-eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
                inet 10.0.0.7  netmask 255.0.0.0  broadcast 10.255.255.255
                inet6 fe80::e0e3:8dff:fecb:f806  prefixlen 64  scopeid 0x20<link>
                ether e2:e3:8d:cb:f8:06  txqueuelen 1000  (Ethernet)
                RX packets 172  bytes 16256 (16.2 KB)
                RX errors 0  dropped 0  overruns 0  frame 0
                TX packets 13  bytes 1006 (1.0 KB)
                TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

        lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
                inet 127.0.0.1  netmask 255.0.0.0
                inet6 ::1  prefixlen 128  scopeid 0x10<host>
                loop  txqueuelen 1000  (Local Loopback)
                RX packets 0  bytes 0 (0.0 B)
                RX errors 0  dropped 0  overruns 0  frame 0
                TX packets 0  bytes 0 (0.0 B)
                TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Q2.1  Draw the function call graph of this controller. For example, once a packet comes to the
      controller, which function is the first to be called, which one is the second, and so forth?

launch() --> __init__() --> start_switch() --> _handle_PacketIn() --> act_like_hub() --> resend_packet() --> send(msg)

Q2.2  Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 p2).
      a. How long does it take (on average) to ping for each case?

         h1 ping h2                      h1 ping h8
            ----------                      ----------
         avg=2.361ms                     avg=7.976ms

      b. What is the minimum and maximum ping you have observed?
         
         min=1.679ms max=5.494ms         min=7.008ms max=14.624ms
         

      c. What is the difference, and why? 

         The difference is 5.615 ms for avg. The reason for the difference in ping time is different distances between hosts.
      h1 --> h2 only needs to go through 1 switch (s3), while h1 --> h6 needs to go through 5 switches (s3,s2,s1,s5,s6).
         

 

Q2.3  Run “iperf h1 h2” and “iperf h1 h8”
      a. What is “iperf” used for?
         
         "iperf" is a tool used to measure the maximum achievable bandwidth.
         In this case, it is being used to measure the TCP bandwidth between hosts in the network.

      b. What is the throughput for each case?

         h1 --> h2                       h1 --> h8
         ---------                       ---------
      8.24 Mbits/s, 8.93 Mbits/s   2.31 Mbits/s, 2.69 Mbits/s
      
      c. What is the difference, and explain the reasons for the difference.

         The differenece is about 5.93 Mbits/s. Similar to the reason for the difference in ping time between hosts, 
      it has to do with the number of switches that a connection needs to pass through to contact the other host.

      
 
Q2.4  Which of the switches observe traffic? Please describe your way for observing such
      traffic on switches (e.g., adding some functions in the “of_tutorial” controller).
   
      Each switch observes traffic. This is because act_like_hub() sends packets to all the switches in the network.
      To be able to observe traffic, you can add a print statement in the _handle_PacketIn() function.
      By getting the id of the switch (self.connection.dpid), its value can be printed when that switch receives traffic. 



Q3.1 Describe how the above code works, such as how the "MAC to Port" map is established.
You could use a ‘ping’ example to describe the establishment process (e.g., h1 ping h2).

The MAC to Port map is established by first checking the map to see if the destination MAC already exists.
   If it does exist, the packet can be directly sent to the destination, reducing unnecessary traffic.
   However, if the destination MAC does not exist in the map, then the code will flood all the packets to every host to find the correct destination. 
   Once it is found, it is added to the map for future use.

Q3.2. (Comment out all prints before doing this experiment) Have h1 ping h2, and h1 ping
      h8 for 100 times (e.g., h1 ping -c100 p2).
      a. How long did it take (on average) to ping for each case?

      h1 ping h2                      h1 ping h8
            ----------                      ----------
      avg=1.899ms                     avg=6.410ms
      
      b. What is the minimum and maximum ping you have observed?

      min=1.664ms max=4.242ms         min=4.327ms max=12.243ms
      
      c. Any difference from Task 2 and why do you think there is a change if there is?

         Overall, compared to task 2, the ping times are lower when using the new function (act_like_switch).
      The reason is the controller can now get the MAC addresses and send them to the appropriate destination port using the map.
      This is more efficient then the packet flooding.

Q3.3. Q.3 Run “iperf h1 h2” and “iperf h1 h8”.
      a. What is the throughput for each case?

      h1 --> h2                       h1 --> h8
      ---------                       ---------
      32.5 Mbits/s, 33.5 Mbits/s   3.62 Mbits/s, 4.08 Mbits/s
      
      b. What is the difference from Task 2 and why do you think there is a change if there is?

      Once again, the increase in throughput is due to the MAC learning. Through the mapping, congestion is reduced which in turn increases throughput.



