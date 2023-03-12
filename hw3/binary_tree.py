from mininet.topo import Topo

class BinaryTreeTopo( Topo ):

    def __init__( self ):

    
        Topo.__init__( self )

        host1 = self.addHost('h1')
        host2 = self.addHost('h2')
        host3 = self.addHost('h3')
        host4 = self.addHost('h4')
        host5 = self.addHost('h5')
        host6 = self.addHost('h6')
        host7 = self.addHost('h7')
        host8 = self.addHost('h8')

        switch1 = self.addSwitch('s1')
        switch2 = self.addSwitch('s2')
        switch3 = self.addSwitch('s3')
        switch4 = self.addSwitch('s4')
        switch5 = self.addSwitch('s5')
        switch6 = self.addSwitch('s6')
        switch7 = self.addSwitch('s7')

        
        self.addLink(switch2, switch1) 
        self.addLink(switch1, switch5)
        self.addLink(switch3, switch2)
        self.addLink(switch2, switch4)
        self.addLink(switch6, switch5)
        self.addLink(switch5, switch7)

        self.addLink(host1, switch3)
        self.addLink(switch3, host2)
        self.addLink(host3, switch4)
        self.addLink(switch4, host4)
        self.addLink(host5, switch6)
        self.addLink(switch6, host6)
        self.addLink(host7, switch7)
        self.addLink(switch7, host8)

topos = { 'binary_tree': ( lambda: BinaryTreeTopo() ) }
