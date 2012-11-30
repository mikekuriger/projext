module IPAdmin
class CIDR

# instance variables
# @all_f
# @hostmask
# @ip
# @max_bits 
# @netmask
# @network
# @tag
# @version

#==============================================================================#
# attr_reader/attr_writer
#==============================================================================#

    # IP version 4 or 6.
    attr_reader :version

    # Hash of custom tags. Should be in the format tag => value.
    attr_reader :tag
    
    # Integer of either 32 or 128 bits in length, with all bits set to 1
    attr_reader :all_f

    # Hash of custom tags. Should be in the format tag => value.
    #
    # Example:
    #   cidr4.tag[:name] = 'IPv4 CIDR'
    #   puts cidr4.tag[:name]
    #
    def tag=(new_tag)
        if (!new_tag.kind_of? Hash)
            raise ArgumentError, "Expected Hash, but #{new_tag.class} provided."
        end
        @tag = new_tag
    end

#==============================================================================#
# initialize()
#==============================================================================#

# - Arguments:
#   * CIDR address as a String, or a Hash with the following fields:
#       - :CIDR -- CIDR address, single IP, or IP and Netmask in extended format - String (optional)
#       - :PackedIP -- Integer representation of an IP address (optional)
#       - :PackedNetmask -- Integer representation of an IP Netmask (optional)
#       - :Version -- IP version - Integer (optional)
#       - :Tag -- Custom descriptor tag - Hash, tag => value. (optional)
#
# - Notes:
#   * At a minimum, either :CIDR or :PackedIP must be provided.
#   * CIDR formatted netmasks take precedence over extended formatted ones.
#   * CIDR address defaults to a host network (/32 or /128) if netmask not provided.
#   * :PackedIP takes precedence over IP given within :CIDR.
#   * :PackedNetmask takes precedence over netmask given within :CIDR.
#   * Version will be auto-detected if not specified
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.1/24')
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1 255.255.255.0')
#   cidr4_2 = IPAdmin::CIDR.new(:PackedIP => 0x0a010001,
#                               :PackedNetmask => 0xffffff00
#                               :Version => 4)
#   cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64',
#                             :Tag => {'interface' => 'g0/1'})
#   cidr6_2 = IPAdmin::CIDR.new(:CIDR => '::ffff:192.168.1.1/96')
#
    def initialize(options)
        @tag = {}
        
        if (!options.kind_of?(Hash) && !options.kind_of?(String))
            raise ArgumentError, "Expected Hash or String, but #{options.class} provided."
        end

        if (options.kind_of? String)
            cidr = options
        end
                
        if (options.kind_of? Hash) 
            # packed_ip takes precedence over cidr
            if (options.has_key?(:PackedIP))
                packed_ip = options[:PackedIP]
                raise ArgumentError, "Expected Integer, but #{packed_ip.class} " +
                                     "provided for option :PackedIP." if (!packed_ip.kind_of?(Integer))
            elsif (options.has_key?(:CIDR))
                cidr =  options[:CIDR]
                raise ArgumentError, "Expected String, but #{cidr.class} " +
                                     "provided for option :CIDR." if (!cidr.kind_of?(String))      
            else
                raise ArgumentError, "Missing argument: CIDR or PackedIP."
            end        
        
            if (options.has_key?(:PackedNetmask))
                packed_netmask = options[:PackedNetmask]
                raise ArgumentError, "Expected Integer, but #{packed_netmask.class} " +
                                     "provided for option :PackedNetmask." if (!packed_netmask.kind_of?(Integer))
            end    
        
            if (options.has_key?(:Version))
                @version = options[:Version]
                if (@version != 4 && @version != 6)
                    raise ArgumentError, ":Version should be 4 or 6, but was '#{version}'."
                end
            end
        
            if (options.has_key?(:Tag))
                @tag = options[:Tag]
                if (!@tag.kind_of? Hash)
                    raise ArgumentError, "Expected Hash, but #{@tag.class} provided for option :Tag."
                end
            end
        end
        
        
        if (packed_ip) 
            # attempt to determine version if not provided
            if (!@version)
                if (packed_ip < 2**32)
                    @version = 4
                else
                    @version = 6
                end
            end
            
            # validate & store packed_ip
            IPAdmin.validate_ip_addr(:IP => packed_ip, :Version => @version)
            @ip = packed_ip
        
        else           
            netmask = nil
            
            # if extended netmask provided. should only apply to ipv4            
            if (cidr =~ /.+\s+.+/ )
                cidr,netmask = cidr.split(' ')
            end            
            
            # determine version if not set
            if (!@version)
                if (cidr =~ /\./ && cidr !~ /:/)
                    @version = 4
                elsif (cidr =~ /:/)
                    @version = 6
                end
            end
            
            # if ipv6 and extended netmask was provided, then raise exception
            raise ArgumentError, "Garbage provided at end of IPv6 address." if (@version == 6 && netmask)    
            
            # if netmask part of cidr, then over-ride any provided extended netmask.
            if (cidr =~ /\//) 
                ip,netmask = cidr.split(/\//)
                if (!ip || !netmask)
                    raise ArgumentError, "CIDR address is improperly formatted. Missing netmask after '/' character." 
                end
            else
                ip = cidr
            end
            
            # pack ip                
            @ip = IPAdmin.pack_ip_addr(:IP => ip, :Version => @version)           
        end

                
        # set vars based on version
        if (@version == 4)
            @max_bits = 32
            @all_f = 2**@max_bits - 1
        else
            @max_bits = 128
            @all_f = 2**@max_bits - 1
        end
        
        # if no netmask or packed_netmask, then set as /32 or /128.
        # else validate. packed_netmask takes precedence over netmask
        if (!netmask && !packed_netmask)
            @netmask = @all_f
        else            
            if (packed_netmask)
                IPAdmin.validate_ip_netmask(:Netmask => packed_netmask, :Packed => true, :Version => @version)
                @netmask = packed_netmask
            else
                IPAdmin.validate_ip_netmask(:Netmask => netmask, :Version => @version)
                @netmask = IPAdmin.pack_ip_netmask(:Netmask => netmask, :Version => @version)
            end
        end
        
        # set @network & @hostmask
        @network = (@ip & @netmask)
        @hostmask = @netmask ^ @all_f

    end

#==============================================================================#
# arpa()
#==============================================================================#

# Depending on the IP version of the current CIDR, 
# return either an in-addr.arpa. or ip6.arpa. string. The netmask will be used
# to determine the length of the returned string.
#
# - Arguments:
#   * none
#
# - Returns:
#   * String
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64')
#   puts "arpa for #{cidr4.desc()} is #{cidr4.arpa}"
#   puts "arpa for #{cidr6.desc(:Short => true)} is #{cidr6.arpa}"
#
    def arpa()

        base = self.ip()
        netmask = self.bits()

        if (@version == 4)
            net = base.split('.')

            if (netmask)
                while (netmask < 32)
                    net.pop
                    netmask = netmask + 8
                end
            end

            arpa = net.reverse.join('.')
            arpa << ".in-addr.arpa."

        elsif (@version == 6)
            fields = base.split(':')
            net = []
            fields.each do |field|
                (field.split("")).each do |x|
                    net.push(x)
                end
            end

            if (netmask)
                while (netmask < 128)
                    net.pop
                    netmask = netmask + 4
                end
            end

            arpa = net.reverse.join('.')
            arpa << ".ip6.arpa."

        end

        return(arpa)
    end

#==============================================================================#
# bits()
#==============================================================================#

# Provide number of bits in Netmask.
#
# - Arguments:
#   * none
#
# - Returns:
#   * Integer.
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64')
#   puts "cidr4 netmask in bits #{cidr4.bits()}"
#   puts "cidr6 netmask in bits #{cidr6.bits()}"
#
    def bits()
        return(IPAdmin.unpack_ip_netmask(:Integer => @netmask))
    end

#==============================================================================#
# contains?()
#==============================================================================#

# Determines if this CIDR contains (is supernet of)
# the provided CIDR address or IPAdmin::CIDR object.
#
# - Arguments:
#   * CIDR address or IPAdmin::CIDR object
#
# - Returns:
#   * true or false
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new('fec0::/64')
#   cidr6_2 = IPAdmin::CIDR.new('fec0::/96')
#   puts "#{cidr4.desc} contains 192.168.1.2" if ( cidr4.contains?('192.168.1.2') )
#   puts "#{cidr6.desc} contains #{cidr6_2.desc(:Short => true)}" if ( cidr6.contains?(cidr6_2) )
#
    def contains?(cidr)
        is_contained = false

        if (!cidr.kind_of?(IPAdmin::CIDR))
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end
        
        network = cidr.packed_network 
        netmask = cidr.packed_netmask


        if (cidr.version != @version)
            raise ArgumentError, "Attempted to compare a version #{cidr.version} CIDR " +
                                 "with a version #{@version} CIDR."
        end

        # if network == @network, then we have to go by netmask length
        # else we can tell by or'ing network and @network by @hostmask
        # and comparing the results
        if (network == @network)
            is_contained = true if (netmask > @netmask)

        else
            if ( (network | @hostmask) == (@network | @hostmask) )
                is_contained = true
            end
        end

        return(is_contained)
    end

#==============================================================================#
# desc()
#==============================================================================#

# Returns network/netmask in CIDR format.
#
# - Arguments:
#   * Optional hash with the following fields:
#       - :IP -- if true, return the original ip/netmask passed during initialization (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new('fec0::/64')
#   puts cidr4.desc(:IP => true)
#   puts "cidr4 description #{cidr4.desc()}"
#   puts "cidr6 description #{cidr6.desc()}"
#   puts "cidr6 short-hand description #{cidr6.desc(:Short => true)}"
#
    def desc(options=nil)
        short = false
        orig_ip = false

        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end
            
            if (options.has_key?(:Short) && options[:Short] == true)
                short = true
            end
            
            if (options.has_key?(:IP) && options[:IP] == true)
                orig_ip = true
            end
        end
        
        if (!orig_ip)
            ip = IPAdmin.unpack_ip_addr(:Integer => @network, :Version => @version)
        else
            ip = IPAdmin.unpack_ip_addr(:Integer => @ip, :Version => @version)
        end
        ip = IPAdmin.shorten(ip) if (short && @version == 6)
        mask = IPAdmin.unpack_ip_netmask(:Integer => @netmask)

        return("#{ip}/#{mask}")
    end

#==============================================================================#
# enumerate()
#==============================================================================#

# Provide all IP addresses contained within the IP space of this CIDR.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Bitstep -- enumerate in X sized steps - Integer (optional)
#       - :Limit -- limit returned list to X number of items - Integer (optional)
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new('fec0::/64')
#   puts "first 4 cidr4 addresses (bitstep 32)"
#   cidr4.enumerate(:Limit => 4, :Bitstep => 32).each {|x| puts "  #{x}"} 
#   puts "first 4 cidr6 addresses (bitstep 32)"
#   cidr6.enumerate(:Limit => 4, :Bitstep => 32, :Objectify => true).each {|x| puts "  #{x.desc}"}
#
    def enumerate(options=nil)
        bitstep = 1
        objectify = false
        limit = nil
        short = false

        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end
            
            if( options.has_key?(:Bitstep) )
                bitstep = options[:Bitstep]
            end

            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end

            if( options.has_key?(:Limit) )
                limit = options[:Limit]
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        end

        list = []
        my_ip = @network
        change_mask = @hostmask | my_ip

        until ( change_mask != (@hostmask | @network) ) 
            if (!objectify)
                my_ip_s = IPAdmin.unpack_ip_addr(:Integer => my_ip, :Version => @version)
                my_ip_s = IPAdmin.shorten(my_ip_s) if (short && @version == 6)
                list.push( my_ip_s )
            else
                list.push( IPAdmin::CIDR.new(:PackedIP => my_ip, :Version => @version) )
            end
            my_ip = my_ip + bitstep
            change_mask = @hostmask | my_ip
            if (limit)
                limit = limit -1
                break if (limit == 0)
            end
        end       
        
        return(list)
    end

#==============================================================================#
# fill_in()
#==============================================================================#

# Given a list of subnets of the current CIDR, return a new list with any
# holes (missing subnets) filled in.
#
# - Arguments:
#   * Array of CIDR addresses, Array of IPAdmin::CIDR objects,
#     or a Hash with the following fields:
#       - :List -- Array of CIDR addresses or IPAdmin::CIDR objects
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * Array of CIDR Strings or Array of IPAdmin::CIDR objects
#
# Examples:
#   subnets = cidr4.fill_in(['192.168.1.0/27','192.168.1.64/26','192.168.1.128/25'])
#   subnets = cidr4.fill_in(:List => ['192.168.1.0/27','192.168.1.64/26'], :Objectify => true)
#

    def fill_in(options)
        short = false
        objectify = false

        # validate options
        if ( options.kind_of?(Hash) )
            if (!options.has_key?(:List))
                raise ArgumentError, "Missing argument: List."
            end
    
            if (options.has_key?(:Short) && options[:Short] == true)
                short = true
            end
    
            if (options.has_key?(:Objectify) && options[:Objectify] == true)
                objectify = true
            end

            # make sure :List is an array
            if ( !options[:List].kind_of?(Array) )
                raise ArgumentError, "Expected Array for option :List, " +
                                     "but #{list.class} provided."
            end
            list = options[:List]
        
        elsif ( options.kind_of?(Array) )
            list = options
        else
            raise ArgumentError, "Array or Hash expected but #{options.class} provided."
        end

        # validate each cidr and store in cidr_list
        cidr_list = []
        list.each do |obj|
            if (!obj.kind_of?(IPAdmin::CIDR))
                begin
                    obj = IPAdmin::CIDR.new(:CIDR => obj)
                rescue Exception => error
                    aise ArgumentError, "A provided CIDR raised the following " +
                                        "errors: #{error}"
                end
            end

            if (!obj.version == self.version)
                raise "#{obj.desc(:Short => true)} is not a version #{self.version} address."
            end
            
            # make sure we contain the cidr
            if ( self.contains?(obj) == false )
                raise "#{obj.desc(:Short => true)} does not fit " +
                      "within the bounds of #{self.desc(:Short => true)}."
            end
            cidr_list.push(obj)
        end
        
        # sort our cidr's and see what is missing
        complete_list = []
        expected = self.packed_network
        IPAdmin.sort(cidr_list).each do |cidr|
            network = cidr.packed_network
            bitstep = (@all_f + 1) - cidr.packed_netmask
            
            if (network > expected)
                num_ips_missing = network - expected
                sub_list = make_subnets_from_base_and_ip_count(expected,num_ips_missing)
                complete_list.concat(sub_list)                               
            elsif (network < expected)
                next
            end
            complete_list.push(IPAdmin::CIDR.new(:PackedIP => network,
                                                 :PackedNetmask => cidr.packed_netmask,
                                                 :Version => self.version))
            expected = network + bitstep
        end
        
        # if expected is not the next subnet, then we're missing subnets 
        # at the end of the cidr
        next_sub = self.next_subnet(:Objectify => true).packed_network
        if (expected != next_sub)
            num_ips_missing = next_sub - expected
            sub_list = make_subnets_from_base_and_ip_count(expected,num_ips_missing)
            complete_list.concat(sub_list)
        end
        
        # decide what to return
        if (!objectify)
            subnets = []
            complete_list.each {|entry| subnets.push(entry.desc(:Short => short))}
            return(subnets)
        else
            return(complete_list)
        end
    end

#==============================================================================#
# hostmask_ext()
#==============================================================================#

# Provide IPv4 Hostmask in extended format (y.y.y.y).
#
# - Arguments:
#   * none
#
# - Returns:
#   * String
#
# Examples:
#   puts cidr4.hostmask_ext()
#
    def hostmask_ext()
        if (@version == 4)
            hostmask = IPAdmin.unpack_ip_addr(:Integer => @hostmask, :Version => @version)
        else
            raise "IPv6 does not support extended hostmask notation." 
        end

        return(hostmask)
    end

#==============================================================================#
# ip()
#==============================================================================#

# Provide original IP address passed during initialization.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Objectify -- if true, return IPAdmin::CIDR object (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String or IPAdmin::CIDR object.
#
# Examples:
#   puts cidr4.ip()
#   puts cidr4.ip(:Objectify => true).desc
#
    def ip(options=nil)
        objectify = false
        short = false
        
        if (options)
            if (!options.kind_of?(Hash))
                raise Argumenterror, "Expected Hash, but " +
                                     "#{options.class} provided."
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
            
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
        end

        
        
        if (!objectify)
            ip = IPAdmin.unpack_ip_addr(:Integer => @ip, :Version => @version)
            ip = IPAdmin.shorten(ip) if (short && @version == 6)
        else
            ip = IPAdmin::CIDR.new(:PackedIP => @ip, :Version => @version)
        end

        return(ip)
    end

#==============================================================================#
# last()
#==============================================================================#

# Provide last IP address in this CIDR object. 
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Objectify -- if true, return IPAdmin::CIDR object (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String or IPAdmin::CIDR object.
#
# - Notes:
#   * The broadcast() method is aliased to this method, and thus works for
#     IPv6 despite the fact that the IPv6 protocol does not support IP
#     broadcasting.
#
# Examples:
#   puts cidr4.last()
#
    def last(options=nil)
        objectify = false
        short = false
        
        if (options)
            if (!options.kind_of?(Hash))
                raise Argumenterror, "Expected Hash, but " +
                                     "#{options.class} provided."
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
            
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end

        end
        
        packed_ip = @network | @hostmask
        if (!objectify)
            ip = IPAdmin.unpack_ip_addr(:Integer => packed_ip, :Version => @version)
            ip = IPAdmin.shorten(ip) if (short && !objectify && @version == 6)
        else
            ip = IPAdmin::CIDR.new(:PackedIP => packed_ip, :Version => @version)
        end

        return(ip)
    end
    
    alias :broadcast :last

#==============================================================================#
# multicast_mac()
#==============================================================================#

# Assuming this CIDR is a valid multicast address (224.0.0.0/4 for IPv4 
# and ff00::/8 for IPv6), return its ethernet MAC address (EUI-48) mapping.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Objectify -- if true, return EUI objects (optional)
#
# - Returns:
#   * String or IPAdmin::EUI48 object
#
# - Note:
#   * MAC address is based on original IP address passed during initialization.
#
# Examples:
#   mcast = IPAdmin::CIDR.new('224.0.0.6')
#   puts mcast.multicast_mac.address
#
    def multicast_mac(options=nil)
        objectify = false
        
        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end
        
            if (options.has_key?(:Objectify) && options[:Objectify] == true)
                objectify = true
            end
        end
        
        if (@version == 4)
            if (@ip & 0xf0000000 == 0xe0000000)
                # map low order 23-bits of ip to 01:00:5e:00:00:00
                mac = @ip & 0x007fffff | 0x01005e000000
            else
                raise "#{self.ip} is not a valid multicast address. IPv4 multicast " +
                      "addresses should be in the range 224.0.0.0/4."
            end
        else
            if (@ip & (0xff << 120) == 0xff << 120)
                # map low order 32-bits of ip to 33:33:00:00:00:00
                mac = @ip & (2**32-1) | 0x333300000000
            else
                raise "#{self.ip} is not a valid multicast address. IPv6 multicast " +
                      "addresses should be in the range ff00::/8."
            end             
        end
        
        eui = IPAdmin::EUI48.new(:PackedEUI => mac)
        eui = eui.address if (!objectify)

        return(eui)
    end

#==============================================================================#
# netmask()
#==============================================================================#

# Provide netmask in CIDR format (/yy).
#
# - Arguments:
#   * none
#
# - Returns:
#   * String
#
# Examples:
#   puts cidr4.netmask()
#
    def netmask()
        bits = IPAdmin.unpack_ip_netmask(:Integer => @netmask)
        return("/#{bits}")
    end

#==============================================================================#
# netmask_ext()
#==============================================================================#

# Provide IPv4 netmask in extended format (y.y.y.y).
#
# - Arguments:
#   * none
#
# - Returns:
#   * String
#
# Examples:
#   puts cidr4.netmask_ext()
#
    def netmask_ext()    
        if (@version == 4)
            netmask = IPAdmin.unpack_ip_addr(:Integer => @netmask)
        else
            raise "IPv6 does not support extended netmask notation. " +
                  "Use netmask() method instead."
        end

        return(netmask)
    end

#==============================================================================#
# network()
#==============================================================================#

# Provide base network address.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Objectify -- if true, return IPAdmin::CIDR object (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String or IPAdmin::CIDR object.
#
# Examples:
#   puts cidr4.network()
#
    def network(options=nil)
        objectify = false
        short = false
        
        if (options)
            if (!options.kind_of?(Hash))
                raise Argumenterror, "Expected Hash, but " +
                                     "#{options.class} provided."
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
            
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
        end

            
        if (!objectify)
            ip = IPAdmin.unpack_ip_addr(:Integer => @network, :Version => @version)
            ip = IPAdmin.shorten(ip) if (short && @version == 6)
        else
            ip = IPAdmin::CIDR.new(:PackedIP => @network, :Version => @version)
        end

        return(ip)
    end

    alias :base :network
    alias :first :network

#==============================================================================#
# next_ip()
#==============================================================================#

# Provide the next IP following the last available IP within this 
# CIDR object. 
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Bitstep -- step in X sized steps - Integer (optional)
#       - :Objectify -- if true, return IPAdmin::CIDR object (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String or IPAdmin::CIDR object.
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new('fec0::/64')
#   puts "cidr4 next subnet #{cidr4.next_subnet()}"
#   puts "cidr6 next subnet #{cidr6.next_subnet(:Short => true)}"
#
    def next_ip(options=nil)
        bitstep = 1
        objectify = false
        short = false
        
        if (options)
            if (!options.kind_of?(Hash))
                raise Argumenterror, "Expected Hash, but " +
                                     "#{options.class} provided."
            end
            
            if( options.has_key?(:Bitstep) )
                bitstep = options[:Bitstep]
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
        end
        
        next_ip = @network + @hostmask + bitstep
        
        if (next_ip > @all_f)
            raise "Returned IP is out of bounds for IPv#{@version}."
        end

                
        if (!objectify)
            next_ip = IPAdmin.unpack_ip_addr(:Integer => next_ip, :Version => @version)
            next_ip = IPAdmin.shorten(next_ip) if (short && @version == 6)
        else
            next_ip = IPAdmin::CIDR.new(:PackedIP => next_ip, :Version => @version)
        end
        
        return(next_ip)
    end

#==============================================================================#
# next_subnet()
#==============================================================================#

# Provide the next subnet following this CIDR object. The next subnet will
# be of the same size as the current CIDR object. 
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Bitstep -- step in X sized steps. - Integer (optional)
#       - :Objectify -- if true, return IPAdmin::CIDR object (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String or IPAdmin::CIDR object.
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   cidr6 = IPAdmin::CIDR.new('fec0::/64')
#   puts "cidr4 next subnet #{cidr4.next_subnet()}"
#   puts "cidr6 next subnet #{cidr6.next_subnet(:Short => true)}"
#
    def next_subnet(options=nil)
        bitstep = 1
        objectify = false
        short = false
        
        if (options)
            if (!options.kind_of?(Hash))
                raise Argumenterror, "Expected Hash, but " +
                                     "#{options.class} provided."
            end
            
            if( options.has_key?(:Bitstep) )
                bitstep = options[:Bitstep]
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
        end
        
        bitstep = bitstep * (2**(@max_bits - self.bits) )
        next_sub = @network + bitstep
        
        if (next_sub > @all_f)
            raise "Returned subnet is out of bounds for IPv#{@version}."
        end
      
        if (!objectify)
            next_sub = IPAdmin.unpack_ip_addr(:Integer => next_sub, :Version => @version)
            next_sub = IPAdmin.shorten(next_sub) if (short && @version == 6)        
            next_sub = next_sub << "/" << self.bits.to_s
        else
            next_sub = IPAdmin::CIDR.new(:PackedIP => next_sub, 
                                         :PackedNetmask => self.packed_netmask, 
                                         :Version => @version)
        end
        
        return(next_sub)
    end

#==============================================================================#
# nth()
#==============================================================================#

# Provide the nth IP within this object.
#
# - Arguments:
#   * Integer or a Hash with the following fields:
#       - :Index -- index number of the IP address to return - Integer
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * String or IPAdmin::CIDR object.
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   puts cidr4.nth(1)
#   puts cidr4.nth(:Index => 1, :Objectify => true)
#
    def nth(options)
        objectify = false
        short = false

        if (options.kind_of?(Hash))
            if ( !options.has_key?(:Index) )
                raise ArgumentError, "Missing argument: Index."
            end
            index = options[:Index]

            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                    objectify = true
            end
        elsif (options.kind_of?(Integer))
            index = options
        else
            raise ArgumentError, "Integer or Hash expected, but " +
                                 "#{options.class} provided."
        end
        
        my_ip = @network + index
        if ( (@hostmask | my_ip) == (@hostmask | @network) )
            
            if (!objectify)
                my_ip = IPAdmin.unpack_ip_addr(:Integer => my_ip, :Version => @version)
                my_ip = IPAdmin.shorten(my_ip) if (short && @version == 6)
            else
                my_ip = IPAdmin::CIDR.new(:PackedIP => my_ip, :Version => @version)
            end

        else
            raise "Index of #{index} returns IP that is out of " +
                  "bounds of CIDR network."
        end

        return(my_ip)
    end

#==============================================================================#
# packed_hostmask()
#==============================================================================#

# Provide an Integer representation of the Hostmask of this object.
#
# - Arguments:
#   * none
#
# - Returns:
#   * Integer
#
# Examples:
#   puts cidr4.packed_hostmask().to_s(16)
#
    def packed_hostmask()
        return(@hostmask)
    end

#==============================================================================#
# packed_ip()
#==============================================================================#

# Provide an Integer representation of the IP address of this object.
#
# - Arguments:
#   * none
#
# - Returns:
#   * Integer
#
# Examples:
#   puts cidr4.packed_ip().to_s(16)
#
    def packed_ip()
        return(@ip)
    end

#==============================================================================#
# packed_netmask()
#==============================================================================#

# Provide an Integer representation of the Netmask of this object.
#
# - Arguments:
#   * none
#
# - Returns:
#   * Integer
#
# Examples:
#   puts cidr4.packed_netmask().to_s(16)
#
    def packed_netmask()
        return(@netmask)
    end

#==============================================================================#
# packed_network()
#==============================================================================#

# Provide an Integer representation of the Network address of this object.
#
# - Arguments:
#   * none
# 
# - Returns:
#   * Integer
#
# Examples:
#   packed = cidr4.packed_network().to_s(16)
#
    def packed_network()
        return(@network)
    end

#==============================================================================#
# range()
#==============================================================================#

# Given two Indexes, return all IP addresses within the CIDR that are
# between them (inclusive).
#
# - Arguments:
#   * Array of (2) Integers, or a Hash with the following fields:
#       - :Bitstep -- enumerate in X sized steps - Integer (optional)
#       - :Indexes -- index numbers of the addresses to use as boundaries - Array of (2) Integers
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   list = cidr4.range([0,1])
#   list = cidr4.range(:Indexes => [0,1], :Objectify => true)
#
    def range(options)
        objectify = false
        short = false
        bitstep = 1

        if (options.kind_of?(Hash))
            if ( !options.has_key?(:Indexes) )
                raise ArgumentError, "Missing argument: Indexes."
            end
            indexes = options[:Indexes]
            raise "Array expected but #{indexes.class} provided for argument: Indexes" if (!indexes.kind_of?(Array))
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
        
            if( options.has_key?(:Bitstep) )
                bitstep = options[:Bitstep]
            end
        elsif (options.kind_of?(Array))
            indexes = options
        else
            raise Argumenterror, "Array or Hash expected, but #{options.class} provided."
        end
        
        # validate & sort indexes
        indexes.sort!
        if (indexes.length != 2)
            raise "(2) index numbers are required."
        end
        if ( (indexes[0] < 0) || (indexes[0] > self.size) )
            raise ArgumentError, "Index #{indexes[0]} is out of bounds for this CIDR."
        end
        
        if (indexes[1] >= self.size)
            raise ArgumentError, "Index #{indexes[1]} is out of bounds for this CIDR."
        end
        
        # make range
        start_ip = @network + indexes[0]
        end_ip = @network + indexes[1]
        my_ip = start_ip
        list = []
        until (my_ip > end_ip)            
            if (!objectify)
                ip = IPAdmin.unpack_ip_addr(:Integer => my_ip, :Version => @version)
                ip = IPAdmin.shorten(ip) if (short && @version == 6)
            else
                ip = IPAdmin::CIDR.new(:PackedIP => my_ip, :Version => @version)
            end
            
            list.push(ip)
            my_ip += bitstep
        end

        return(list)
    end

#==============================================================================#
# remainder()
#==============================================================================#

# Given a single subnet of the current CIDR, provide the remainder of
# the subnets. For example if the original CIDR is 192.168.0.0/24 and you
# provide 192.168.0.64/26 as the portion to exclude, then 192.168.0.0/26,
# and 192.168.0.128/25 will be returned as the remainders.
#
# - Arguments:
#   * CIDR address, IPAdmin::CIDR object, or a Hash with the following fields:
#       - :Exclude -- CIDR address or IPAdmin::CIDR object.
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
#
# Examples:
#   cidr4.remainder('192.168.1.32/27').each {|x| puts x}
#   cidr4.remainder(:Exclude => '192.168.1.32/27', :Objectify => true).each {|x| puts x.desc}
#
    def remainder(options)
        short = nil
        objectify = nil
        
        if (options.kind_of? Hash)
            if ( !options.has_key?(:Exclude) )
                raise ArgumentError, "Missing argument: Exclude."
            end
            to_exclude = options[:Exclude]
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
        
        elsif
            to_exclude = options
        else
            raise ArgumentError, "CIDR address or Hash expected, but #{options.class} provided."
        end
        
        if ( !to_exclude.kind_of?(IPAdmin::CIDR) )
            begin
                to_exclude = IPAdmin::CIDR.new(:CIDR => to_exclude)
            rescue Exception => error
                raise ArgumentError, "Argument :Exclude raised the following " +
                                     "errors: #{error}"
            end
        end
        
        
        # make sure 'to_exclude' is the same ip version
        if ( to_exclude.version != @version )
            raise "#{to_exclude.desc(:Short => true)} is of a different " +
                  "IP version than #{self.desc(:Short => true)}."
        end    

        # make sure we contain 'to_exclude'
        if ( self.contains?(to_exclude) != true )
            raise "#{to_exclude.desc(:Short => true)} does not fit " +
                  "within the bounds of #{self.desc(:Short => true)}."
        end

        # split this cidr in half & see which half 'to_exclude'
        # belongs in. take that half & repeat the process. every time
        # we repeat, store off the non-matching half
        new_mask = self.bits + 1
        lower_network = self.packed_network
        upper_network = self.packed_network + 2**(@max_bits - new_mask)
        
        new_subnets = []
        until(new_mask > to_exclude.bits)
            if (to_exclude.packed_network < upper_network)
                match = lower_network
                non_match = upper_network
            else
                match = upper_network
                non_match = lower_network
            end

            
            if (!objectify)
                non_match = IPAdmin.unpack_ip_addr(:Integer => non_match, :Version => @version)
                non_match = IPAdmin.shorten(non_match) if (short && @version == 6)
                new_subnets.unshift("#{non_match}/#{new_mask}")
            else
                new_subnets.unshift(IPAdmin::CIDR.new(:PackedIP => non_match, 
                                                      :PackedNetmask => IPAdmin.pack_ip_netmask(new_mask), 
                                                      :Version => @version))
            end
            
            new_mask = new_mask + 1
            lower_network = match
            upper_network = match + 2**(@max_bits - new_mask)
        end
        
        return(new_subnets)
    end

#==============================================================================#
# resize()
#==============================================================================#

# Resize the CIDR by changing the size of the Netmask. 
# Return the resulting CIDR as a new object.
#
# - Arguments:
#   * Integer, or a Hash with the following fields:
#       - :Netmask -- Number of bits of new Netmask - Integer
#
# - Returns:
#   * IPAdmin::CIDR object
#
# Examples:
#   cidr4 = IPAdmin::CIDR.new('192.168.1.1/24')
#   new_cidr = cidr4.resize(23)
#   new_cidr = cidr4.resize(:Netmask => 23)
#   puts new_cidr.desc
#
    def resize(options)
        if (options.kind_of?(Hash))
            if ( !options.has_key?(:Netmask) )
                raise Argumenterror, "Missing argument: Netmask."
            end
            bits = options[:Netmask]
        elsif (options.kind_of?(Integer))
            bits = options
        else
            raise Argumenterror, "Integer or Hash expected, but " +
                                     "#{options.class} provided."
        end
        
        IPAdmin.validate_ip_netmask(:Netmask => bits, :Version => @version)
        netmask = IPAdmin.pack_ip_netmask(:Netmask => bits, :Version => @version)
        network = @network & netmask
        
        cidr = IPAdmin::CIDR.new(:PackedIP => network, :PackedNetmask => netmask, :Version => @version)
        return(cidr)
    end

#==============================================================================#
# resize!()
#==============================================================================#

# Resize this object by changing the size of the Netmask. 
#
# - Arguments:
#   * Integer, or a Hash with the following fields:
#       - :Netmask -- Number of bits of new Netmask - Integer
#
# - Returns:
#   * True
#
# - Notes:
#   * If CIDR is resized such that the original IP is no longer contained within,
#     then that IP will be reset to the base network address.
#
    def resize!(options)
        if (options.kind_of?(Hash))
            if ( !options.has_key?(:Netmask) )
                raise Argumenterror, "Missing argument: Netmask."
            end
            bits = options[:Netmask]
        elsif (options.kind_of?(Integer))
            bits = options
        else
            raise Argumenterror, "Integer or Hash expected, but " +
                                     "#{options.class} provided."
        end
        
        IPAdmin.validate_ip_netmask(:Netmask => bits, :Version => @version)
        netmask = IPAdmin.pack_ip_netmask(:Netmask => bits, :Version => @version)
        
        @netmask = netmask
        @network = @network & netmask
        @hostmask = @netmask ^ @all_f
        
        # check @ip
        if ((@ip & @netmask) != (@network))
            @ip = @network
        end
        
        return(true)
    end

#==============================================================================#
# size()
#==============================================================================#

# Provide number of IP addresses within this object.
#
# - Arguments:
#   * none
#
# - Returns:
#   * Integer
#
# Examples:
#   puts cidr4.size()
#
    def size()
        return(@hostmask + 1)
    end

#==============================================================================#
# subnet()
#==============================================================================#

# Subnet this object. There are 2 ways to subnet:
#   * By providing the netmask of the new subnets in :Subnet.
#   * By providing the number of IP addresses needed in the new subnets in :IPCount
#
# If :Mincount is not provided, then the CIDR will be fully subnetted. Otherwise,
# :Mincount number of subnets of the requested size will be returned and
# the remainder of the subnets will be summarized as much as possible. If neither :Subnet
# or :IPCount is provided, then the current CIDR will be split in half.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :IPCount -- Minimum number of IP's that new subnets should contain - Integer (optional)
#       - :MinCount -- Minimum number of X sized subnets to return - Integer (optional)
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#       - :Subnet --  Netmask (in bits) of new subnets - Integer (optional)
#
# - Returns:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
# - Notes:
#   * :Subnet always takes precedence over :IPCount.
#
# Examples:
#   cidr_list = cidr4.subnet(:Subnet => 28, :MinCount => 3).each {|x| puts "  #{x}"}
#   cidr_list = cidr4.subnet(:IPCount => 19).each {|x| puts "  #{x}"}
#   cidr4.subnet(:Subnet => 28).each {|x| puts "  #{x}"}  "
#   cidr6.subnet(:Subnet => 67, :MinCount => 4, :Short => true).each {|x| puts "  #{x}"}
#
    def subnet(options=nil)
        my_network = self.packed_network
        my_mask = self.bits
        subnet_bits = my_mask + 1
        min_count = nil 
        objectify = false
        short = false       
        
        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end
            
            if ( options.has_key?(:IPCount) )
                subnet_bits = IPAdmin.minimum_size(:IPCount => options[:IPCount],
                                                   :Version => @version)
            end
            
            if ( options.has_key?(:Subnet) )
                subnet_bits = options[:Subnet]
            end
            
            if ( options.has_key?(:MinCount) )
                min_count = options[:MinCount]
            end
            
            if( options.has_key?(:Short) && options[:Short] == true )
                short = true
            end
        
            if( options.has_key?(:Objectify) && options[:Objectify] == true )
                objectify = true
            end
            
        end

        # get number of subnets possible with the requested subnet_bits
        num_avail = 2**(subnet_bits - my_mask)        

        # get the number of bits in the next supernet and
        # make sure min_count is a power of 2
        bits_needed = 1
        min_count = num_avail if (!min_count)
        until (2**bits_needed >= min_count)
            bits_needed += 1
        end
        min_count = 2**bits_needed
        next_supernet_bits = subnet_bits - bits_needed
        

        # make sure subnet isnt bigger than available bits
        if (subnet_bits > @max_bits)
            raise "Requested subnet (#{subnet_bits}) does not fit " +
                  "within the bounds of IPv#{@version}."
        end

        # make sure subnet is larger than mymask
        if (subnet_bits < my_mask)
            raise "Requested subnet (#{subnet_bits}) is too large for " +
                  "current CIDR space."
        end

        # make sure MinCount is smaller than available subnets
        if (min_count > num_avail)
            raise "Requested subnet count (#{min_count}) exceeds subnets " +
                  "available for allocation (#{num_avail})."
        end

        # list all 'subnet_bits' sized subnets of this cidr block
        # with a limit of min_count
        bitstep = 2**(@max_bits - subnet_bits)
        subnets = self.enumerate(:Bitstep => bitstep, :Limit => min_count)

        # save our subnets
        new_subnets = []
        subnets.each do |subnet|
            if (!objectify)
                subnet = IPAdmin.shorten(subnet) if (short && @version == 6)
                new_subnets.push("#{subnet}/#{subnet_bits}")
            else            
                new_subnets.push(IPAdmin::CIDR.new(:CIDR => "#{subnet}/#{subnet_bits}", :Version => @version))
            end
        end

        # now go through the rest of the cidr space and make the rest
        # of the subnets. we want these to be as tightly merged as possible
        next_supernet_bitstep = (bitstep * min_count)
        next_supernet_ip = my_network + next_supernet_bitstep
        until (next_supernet_bits == my_mask)
            if (!objectify)
                next_network = IPAdmin.unpack_ip_addr(:Integer => next_supernet_ip, :Version => @version)
                next_network = IPAdmin.shorten(next_network) if (short && @version == 6)
                new_subnets.push("#{next_network}/#{next_supernet_bits}")
            else
                new_subnets.push(IPAdmin::CIDR.new(:PackedIP => next_supernet_ip,
                                                   :PackedNetmask => IPAdmin.pack_ip_netmask(next_supernet_bits),
                                                   :Version => @version))
            end
            
            next_supernet_bits -= 1
            next_supernet_ip = next_supernet_ip + next_supernet_bitstep
            next_supernet_bitstep = next_supernet_bitstep << 1
        end

        return(new_subnets)
    end


# PRIVATE INSTANCE METHODS
private


#==============================================================================#
# make_subnets_from_base_and_ip_count()
#==============================================================================#

# Make CIDR addresses from a base addr and an number of ip's to encapsulate.
#
# - Arguments:
#   * base ip as packed integer
#   * number of ip's required
#
# - Returns:
#   * array of IPAdmin::CIDR objects
#
    def make_subnets_from_base_and_ip_count(base_addr,ip_count)
        list = []        
        until (ip_count == 0)
            mask = @all_f
            multiplier = 0
            bitstep = 0
            last_addr = base_addr
            done = false
            until (done == true)
                if (bitstep < ip_count && (base_addr & mask == last_addr & mask) )
                    multiplier += 1
                elsif (bitstep > ip_count || (base_addr & mask != last_addr & mask) )
                    multiplier -= 1
                    done = true
                else
                    done = true
                end                
                bitstep = 2**multiplier
                mask = @all_f << multiplier & @all_f
                last_addr = base_addr + bitstep - 1
            end          
            
            list.push(IPAdmin::CIDR.new(:PackedIP => base_addr,
                                        :PackedNetmask => mask,
                                        :Version => self.version))
            ip_count -= bitstep
            base_addr += bitstep
        end
        
        return(list)
    end

end # end class CIDR

end # module IPAdmin
__END__
