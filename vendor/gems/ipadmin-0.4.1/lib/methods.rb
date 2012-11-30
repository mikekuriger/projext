module IPAdmin

#==============================================================================#
# compare()
#==============================================================================#

# Compare (2) CIDR addresses, and determine if one
# is the supernet of the other.
#
# - Arguments:
#   * (2) Strings, or (2) IPAdmin::CIDR objects
#
# - Returns:
#   * if one is a subnet of another, then return original array in order of [supernet,subnet]
#   * if both are equal, return 1
#   * if neither is a supernet of the other, return nil
#
# Examples:
#   comp1 = IPAdmin.compare(cidr4_1,cidr4_2)
#   comp2 = IPAdmin.compare(cidr6_1,cidr6_2)
#   puts "#{(comp1[0]).desc} is the supernet of #{(comp1[1]).desc}"
#   puts "#{(comp2[0]).desc} is the supernet of #{(comp2[1]).desc}"
#

def compare(cidr1,cidr2)
    ret_val = nil
    orig1 = cidr1
    orig2 = cidr2
    
    # if args are not CIDR objects, then attempt to create
    # cidr objects from them
    if ( !cidr1.kind_of?(IPAdmin::CIDR) )
        begin
            cidr1 = IPAdmin::CIDR.new(:CIDR => cidr1)
        rescue Exception => error
            raise ArgumentError, "First provided argument raised the following " +
                                 "errors: #{error}"
        end
    end

    if ( !cidr2.kind_of?(IPAdmin::CIDR))
        begin
            cidr2 = IPAdmin::CIDR.new(:CIDR => cidr2)
        rescue Exception => error
            raise ArgumentError, "Second provided argument raised the following " +
                                 "errors: #{error}"
        end
    end

    # make sure both are same version
    if (cidr1.version != cidr2.version )
        raise ArgumentError, "Provided CIDR addresses are of different IP versions."
    end


    # get network/netmask of each
    objects = [cidr1,cidr2]
    networks = []
    netmasks = []
    for obj in objects
        networks.push(obj.packed_network)
        netmasks.push(obj.packed_netmask)
    end

    # return 1's if objects are equal otherwise
    # whichever netmask is smaller will be the supernet.
    # if we '&' both networks by the supernet, and they are
    # equal, then the supernet is the parent of the other network
    if ( (networks[0] == networks[1]) && (netmasks[0] == netmasks[1]) )
        ret_val = 1
    elsif (netmasks[0] < netmasks[1])
        if ( (netmasks[0] & networks[0]) == (netmasks[0] & networks[1]) )
            ret_val = [orig1,orig2]
        end
    elsif (netmasks[1] < netmasks[0])
        if ( (netmasks[1] & networks[0]) == (netmasks[1] & networks[1]) )
            ret_val = [orig2,orig1]
        end
    end

    return(ret_val)
end
module_function :compare

#==============================================================================#
# merge()
#==============================================================================#

# Given a list of CIDR addresses or IPAdmin::CIDR objects of the same version,
# merge (summarize) them in the most efficient way possible. Summarization 
# will only occur when the newly created supernets will not result in the 
# 'creation' of additional space. For example the following blocks 
# (192.168.0.0/24, 192.168.1.0/24, and 192.168.2.0/24) would be summarized into 
# 192.168.0.0/23 and 192.168.2.0/24 rather than into 192.168.0.0/22 
#
# - Arguments:
#   * Array of Strings, Array of IPAdmin::CIDR objects, or a Hash with 
#     the following fields:
#       - :List -- Array of CIDR addresses or IPAdmin::CIDR objects
#       - :Objectify -- if true, return IPAdmin::CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * Array of CIDR address Strings or IPAdmin::CIDR objects
#
# - Notes:
#   * I have designed this with enough flexibility that you can pass in CIDR 
#     addresses that arent even related (ex. 192.168.1.0/26, 192.168.1.64/27, 192.168.1.96/27
#     10.1.0.0/26, 10.1.0.64/26) and they will be merged properly (ie 192.168.1.0/25,
#     and 10.1.0.0/25 would be returned).
#
# Examples:
#   supernets = IPAdmin.merge(['192.168.1.0/27','192.168.1.32/27'])
#   supernets = IPAdmin.merge(:List => ['192.168.1.0/27','192.168.1.32/27'], :Short => true)
#
def merge(options)
    version = nil
    all_f = nil
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
    
    # make sure all are valid types of the same IP version
    supernet_list = []
    list.each do |obj|
        if (!obj.kind_of?(IPAdmin::CIDR))
            begin
                obj = IPAdmin::CIDR.new(:CIDR => obj)
            rescue Exception => error
                raise ArgumentError, "An array element of :List raised the following " +
                                     "errors: #{error}"
            end
        end

        version = obj.version if (!version)
        all_f = obj.all_f if (!all_f)
        if (!obj.version == version)
            raise "Provided objects must be of the same IP version."
        end 
        supernet_list.push(obj)
    end

    # merge subnets by removing them from 'supernet_list',
    # and categorizing them into hash of arrays ({packed_netmask => [packed_network,packed_network,etc...] ) 
    # within each categorization we merge contiguous subnets
    # and then remove them from that category & put them back into
    # 'supernet_list'. we do this until supernet_list stops getting any shorter
    categories = {}
    supernet_list_length = 0
    until (supernet_list_length == supernet_list.length)
        supernet_list_length = supernet_list.length

        # categorize
        supernet_list.each do |cidr|
            netmask = cidr.packed_netmask
            network = cidr.packed_network
            if (categories.has_key?(netmask) )
                categories[netmask].push(network)
            else
                categories[netmask] = [network]
            end
        end
        supernet_list.clear

        ordered_cats = categories.keys.sort        
        ordered_cats.each do |netmask|
            nets = categories[netmask].sort
            bitstep = (all_f + 1) - netmask
            
            until (nets.length == 0)
                # take the first network & create its supernet. this
                # supernet will have x number of subnets, so we'll look
                # & see if we have those subnets. if so, keep supernet & delete subnets.
                to_merge = []
                multiplier = 1
                network1 = nets[0]
                num_required = 2**multiplier
                supermask = (netmask << multiplier) & all_f
                supernet = supermask & network1
                if (network1 == supernet)
                    # we have the first half of the new supernet                   
                    expected = network1
                    nets.each do |network|
                        if (network == expected)
                            to_merge.push(network)
                            expected = expected + bitstep
                            if ( (to_merge.length == num_required) && (nets.length > num_required) )
                                # we have all of our subnets for this round, but still have
                                # more to look at
                                multiplier += 1
                                num_required = 2**multiplier
                                supermask = (netmask << multiplier) & all_f
                                supernet = supermask & network1
                            end
                        else
                            break 
                        end
                    end
                else
                   # we have the second half of the new supernet only
                   to_merge.push(network1)
                end

                
                if (to_merge.length != num_required)
                    # we dont have all of our subnets, so backstep 1 bit                    
                    multiplier -= 1
                    supermask = (netmask << multiplier) & all_f
                    supernet = supermask & network1
                end
                
                # save new supernet
                supernet_list.push(IPAdmin::CIDR.new(:PackedIP => supernet,
                                                     :PackedNetmask => supermask,
                                                     :Version => version))
                
                # delete the subnets of the new supernet
                (2**multiplier).times {nets.delete(to_merge.shift)}               
            end
        end
        categories.clear
        supernet_list = IPAdmin.sort(supernet_list)
    end

    # decide what to return
    if (!objectify)
            supernets = []
            supernet_list.each {|entry| supernets.push(entry.desc(:Short => short))}
            return(supernets)
    else
            return(supernet_list)
    end

end
module_function :merge

#==============================================================================#
# minimum_size()
#==============================================================================#

# Given the number of IP addresses required in a subnet, return the minimum
# netmask (in bits) required for that subnet.
#
# - Arguments:
#   * Integer or a Hash with the following fields:
#       - :IPCount -- the number of IP addresses required - Integer
#       - :Version -- IP version - Integer(optional)
#
# - Returns:
#   * Integer
#
# - Notes:
#   * Version is assumed to be 4 unless specified otherwise.
#
# Examples:
#   netmask = IPAdmin.minumum_size(14)
#   netmask = IPAdmin.minumum_size(:IPCount => 65536, :Version => 6)
#
def minimum_size(options)
    version = 4

    if ( options.kind_of?(Hash) )
        if ( !options.has_key?(:IPCount) )
            raise ArgumentError, "Missing argument: List."
        end
        ipcount = options[:IPCount]
    
        if (options.has_key?(:Version))
            version = options[:Version]
        end
    elsif ( options.kind_of?(Integer) )
        ipcount = options
    else
        raise ArgumentError, "Integer or Hash expected but #{options.class} provided."
    end
    
    if (version == 4)
        max_bits = 32        
    else
        max_bits = 128
    end
    
    
    if (ipcount > 2**max_bits) 
        raise "Required IP count exceeds number of IP addresses available " +
              "for IPv#{version}."
    end

    
    bits_needed = 0
    until (2**bits_needed >= ipcount)
        bits_needed += 1
    end
    subnet_bits = max_bits - bits_needed
    
    return(subnet_bits)
end
module_function :minimum_size

#==============================================================================#
# pack_ip_addr()
#==============================================================================#

# Convert IP addresses into an Integer.
#
# - Arguments:
#   * IP address as a String, or a Hash with the following fields:
#       - :IP -- IP address - String
#       - :Version -- IP version - Integer
#
# - Returns:
#   * Integer
#
# - Notes:
#   * Will attempt to auto-detect IP version if not provided
#
# Examples:
#   pack_ip_addr('192.168.1.1')
#   pack_ip_addr(IP => 'ffff::1', :Version => 6)
#   pack_ip_addr(::192.168.1.1')
#
def pack_ip_addr(options)
    to_validate = {}
    
    if (options.kind_of?(Hash))
        if (!options.has_key?(:IP))
            raise ArgumentError, "Missing argument: IP."
        end
        ip = options[:IP]

        if (options.has_key?(:Version))
            version = options[:Version]
            to_validate[:Version] = version
            if (version != 4 && version != 6)
                raise ArgumentError, ":Version should be 4 or 6, but was '#{version}'."
            end
        end
    elsif
        ip = options
    else
        raise ArgumentError, "String or Hash expected, but #{options.class} provided."
    end 
    to_validate[:IP] = ip
    
    if ( ip.kind_of?(String) )
        
        # validate
        IPAdmin.validate_ip_addr(to_validate)
        
        # determine version if not provided
        if (!version)
            if ( ip =~ /\./ && ip !~ /:/ )
                version = 4
            else
                version = 6
            end
        end
        
        packed_ip = 0
        if ( version == 4)
            octets = ip.split('.')            
            (0..3).each do |x|
                octet = octets.pop.to_i
                octet = octet << 8*x 
                packed_ip = packed_ip | octet
            end
            
        else
            # if ipv4-mapped ipv6 addr
            if (ip =~ /\./)
                dotted_dec = true                 
            end            
            
            # split up by ':'
            fields = []
            if (ip =~ /::/)
                shrthnd = ip.split( /::/ )
                if (shrthnd.length == 0)
                    return(0) 
                else                    
                    first_half = shrthnd[0].split( /:/ ) if (shrthnd[0])
                    sec_half = shrthnd[1].split( /:/ ) if (shrthnd[1])
                    first_half = [] if (!first_half)
                    sec_half = [] if (!sec_half)
                end
                missing_fields = 8 - first_half.length - sec_half.length
                missing_fields -= 1 if dotted_dec
                fields = fields.concat(first_half)
                missing_fields.times {fields.push('0')}
                fields = fields.concat(sec_half)               
                
            else
               fields = ip.split(':')  
            end
           
            if (dotted_dec)
                ipv4_addr = fields.pop
                packed_v4 = IPAdmin.pack_ip_addr(:IP => ipv4_addr, :Version => 4)
                octets = []
                2.times do
                    octet = packed_v4 & 0xFFFF
                    octets.unshift(octet.to_s(16))
                    packed_v4 = packed_v4 >> 16
                end
                fields.concat(octets)
            end

            # pack
            (0..7).each do |x|
                field = fields.pop.to_i(16)
                field = field << 16*x 
                packed_ip = packed_ip | field
            end
            
        end

    else
        raise ArgumentError, "IP address should be a String, but is a #{ip.class}."    
    end

    return(packed_ip)
end
module_function :pack_ip_addr

#==============================================================================#
# pack_ip_netmask()
#==============================================================================#

# Convert IP netmask into an Integer. Netmask may be in either CIDR (/yy) or
# extended (y.y.y.y) format. CIDR formatted netmasks may either
# be a String or an Integer.
#
# - Arguments
#   * String or Integer, or a Hash with the following fields:
#       - :Netmask -- Netmask - String or Integer
#       - :Version -- IP version - Integer (optional)
#
# - Returns:
#   * Integer
#
# - Notes:
#   * Version defaults to 4. It may be necessary to specify the version if
#     an IPv6 netmask of /32 or smaller were passed.
#
# Examples:
#   packed = IPAdmin.pack_ip_netmask('255.255.255.0')
#   packed = IPAdmin.pack_ip_netmask('24')
#   packed = IPAdmin.pack_ip_netmask(24)
#   packed = IPAdmin.pack_ip_netmask('/24')
#   packed = IPAdmin.pack_ip_netmask(Netmask => '64', :Version => 6)
#
def pack_ip_netmask(options)
    all_f = 2**32-1
    
    if (options.kind_of?(Hash))
        if (!options.has_key?(:Netmask))
            raise ArgumentError, "Missing argument: Netmask."
        end
        netmask = options[:Netmask]
        to_validate = {:Netmask => netmask}
    
        if (options.has_key?(:Version))
            version = options[:Version]
            if (version != 4 && version != 6)
                raise ArgumentError, ":Version should be 4 or 6, but was '#{version}'."
            elsif (version == 6)
                all_f = 2**128-1
            else
                all_f = 2**32-1
            end
            to_validate[:Version] = version
        end
    
    elsif (options.kind_of?(String) || options.kind_of?(Integer))
        netmask = options
        to_validate = {:Netmask => netmask}
    else
        raise ArgumentError, "String, Integer, or Hash expected, but #{options.class} provided."
    end
    
    if (netmask.kind_of?(String))
        IPAdmin.validate_ip_netmask(to_validate)
        
        if(netmask =~ /\./)
            packed_netmask = IPAdmin.pack_ip_addr(:IP => netmask)

        else
            # remove '/' if present
            if (netmask =~ /^\// )
                netmask[0] = " "
                netmask.lstrip!
            end
            netmask = netmask.to_i
            packed_netmask = all_f ^ (all_f >> netmask)
        end
        
    elsif (netmask.kind_of?(Integer))
        to_validate[:Packed] = true
        IPAdmin.validate_ip_netmask(to_validate)
        packed_netmask = all_f ^ (all_f >> netmask)
    
    else
        raise ArgumentError, "Netmask should be a String or Integer, but is a #{netmask.class}."
    
    end
    
    return(packed_netmask)
end
module_function :pack_ip_netmask

#==============================================================================#
# range()
#==============================================================================#

# Given two CIDR addresses or IPAdmin::CIDR objects of the same version,
# return all IP addresses between them.
#
# - Arguments:
#   * Array of (2) Strings, Array of (2) IPAdmin::CIDR objects, or a Hash
#     with the following fields:
#       - :Bitstep -- enumerate in X sized steps - Integer (optional)
#       - :Boundaries -- Array of (2) Strings, or Array of (2) IPAdmin::CIDR objects
#       - :Inclusive -- if true, include boundaries in returned data
#       - :Limit -- limit returned list to X number of items - Integer (optional)
#       - :Objectify -- if true, return CIDR objects (optional)
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#
# - Returns:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
# - Notes:
#   * IPAdmin.range will use the original IP address passed during the initialization
#     of the IPAdmin::CIDR objects, or the base address of any CIDR addresses passed.
#   * The default behavior is to be non-inclusive (dont include boundaries as part of returned data) 
#
# Examples:
#   list = IPAdmin.range(:Boundaries => [cidr1,cidr2], :Limit => 10)
#   list = IPAdmin.range(['192.168.1.0','192.168.1.10']
#
def range(options)
    list = []
    bitstep = 1
    objectify = false
    short = false
    inclusive = false
    limit = nil

    # check options
    if (options.kind_of?(Hash))
        if ( !options.has_key?(:Boundaries) ) 
            raise ArgumentError, "Missing argument: Boundaries."
        end

        if (options[:Boundaries].length == 2)
            (cidr1,cidr2) = options[:Boundaries]
        else
            raise ArgumentError, "Two IPAdmin::CIDR ojects are required. " +
                                 "as Boundaries."
        end

        if( options.has_key?(:Bitstep) )
            bitstep = options[:Bitstep]
        end

        if( options.has_key?(:Objectify) && options[:Objectify] == true )
            objectify = true
        end
        
        if( options.has_key?(:Short) && options[:Short] == true )
            short = true
        end
        
        if( options.has_key?(:Inclusive) && options[:Inclusive] == true )
            inclusive = true
        end

        if( options.has_key?(:Limit) )
            limit = options[:Limit]
        end
    
    elsif(options.kind_of?(Array))
        (cidr1,cidr2) = options
    else
        raise ArgumentError, "Array or Hash expected but #{options.class} provided."
    end

    # if cidr1/cidr2 are not CIDR objects, then attempt to create
    # cidr objects from them
    if ( !cidr1.kind_of?(IPAdmin::CIDR) )
        begin
            cidr1 = IPAdmin::CIDR.new(:CIDR => cidr1)
        rescue Exception => error
            raise ArgumentError, "First argument of :Boundaries raised the following " +
                                 "errors: #{error}"
        end
    end

    if ( !cidr2.kind_of?(IPAdmin::CIDR))
        begin
            cidr2 = IPAdmin::CIDR.new(:CIDR => cidr2)
        rescue Exception => error
            raise ArgumentError, "Second argument of :Boundaries raised the following " +
                                 "errors: #{error}"
        end
    end

    # check version, store & sort
    if (cidr1.version == cidr2.version)
        version = cidr1.version
        boundaries = [cidr1.packed_ip, cidr2.packed_ip]
        boundaries.sort
    else
        raise ArgumentError, "Provided IPAdmin::CIDR objects are of different IP versions."
    end

    # dump our range
    if (!inclusive)
        my_ip = boundaries[0] + 1
        end_ip = boundaries[1]
    else
        my_ip = boundaries[0]
        end_ip = boundaries[1] + 1
    end
    
    until (my_ip >= end_ip) 
        if (!objectify)
            my_ip_s = IPAdmin.unpack_ip_addr(:Integer => my_ip, :Version => version)
            my_ips = IPAdmin.shorten(my_ips) if (short && version == 6)
            list.push(my_ip_s)
        else
            list.push( IPAdmin::CIDR.new(:PackedIP => my_ip, :Version => version) )
        end

        my_ip = my_ip + bitstep
        if (limit)
            limit = limit -1
            break if (limit == 0)
        end
    end

    return(list)
end
module_function :range

#==============================================================================#
# shorten()
#==============================================================================#

# Take a standard IPv6 address, and format it in short-hand notation.
# The address should not contain a netmask.
#
# - Arguments:
#   * String
#
# - Returns:
#   * String
#
# Examples:
#   short = IPAdmin.shorten('fec0:0000:0000:0000:0000:0000:0000:0001')
#
def shorten(addr)

    # is this a string?
    if (!addr.kind_of? String)
        raise ArgumentError, "Expected String, but #{addr.class} provided."
    end

    validate_ip_addr(:IP => addr, :Version => 6)

    # make sure this isnt already shorthand
    if (addr =~ /::/)
        return(addr)
    end

    # split into fields
    fields = addr.split(":")
    
    # check last field for ipv4-mapped addr
    if (fields.last() =~ /\./ )
        ipv4_mapped = fields.pop()
    end
    
    # look for most consecutive '0' fields
    start_field,end_field = nil,nil
    start_end = []
    consecutive,longest = 0,0
        
    (0..(fields.length-1)).each do |x|
        fields[x] = fields[x].to_i(16)

        if (fields[x] == 0)
            if (!start_field)
                start_field = x
                end_field = x
            else
                end_field = x
            end
            consecutive += 1
        else
            if (start_field)
                if (consecutive > longest)
                    longest = consecutive
                    start_end = [start_field,end_field]
                    start_field,end_field = nil,nil                    
                end
                consecutive = 0
            end
        end

        fields[x] = fields[x].to_s(16)
    end
    
    # if our longest set of 0's is at the end, then start & end fields
    # are already set. if not, then make start & end fields the ones we've
    # stored away in start_end
    if (consecutive > longest) 
        longest = consecutive
    else
        start_field = start_end[0]
        end_field = start_end[1]
    end

    if (longest > 1)        
        fields[start_field] = ''
        start_field += 1
        fields.slice!(start_field..end_field)
    end 
    fields.push(ipv4_mapped) if (ipv4_mapped)   
    short = fields.join(':')    
    short << ':' if (short =~ /:$/)
    
    return(short)
end
module_function :shorten

#==============================================================================#
# sort()
#==============================================================================#

# Given a list of CIDR addresses or IPAdmin::CIDR objects, 
# sort them from lowest to highest by Network/Netmask.
#
# - Arguments:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
# - Returns:
#   * Array of Strings, or Array of IPAdmin::CIDR objects
#
# - Notes:
#   * IPAdmin.sort will use the original IP address passed during the initialization
#     of any IPAdmin::CIDR objects, or the base address of any CIDR addresses passed.
#
# Examples:
#   sorted = IPAdmin.sort([cidr1,cidr2])
#   sorted = IPAdmin.sort(['192.168.1.32/27','192.168.1.0/27','192.168.2.0/24'])
#
def sort(list)

    # make sure list is an array
    if ( !list.kind_of?(Array) )
        raise ArgumentError, "Array of IPAdmin::CIDR or NetStruct " +
                             "objects expected, but #{list.class} provided."
    end

    # make sure all are valid types of the same IP version
    version = nil
    cidr_hash = {}
    list.each do |cidr|
        if (!cidr.kind_of?(IPAdmin::CIDR))
            begin
                new_cidr = IPAdmin::CIDR.new(cidr)
            rescue Exception => error
                raise ArgumentError, "An element of the provided Array " +
                                     "raised the following errors: #{error}"
            end
        else
            new_cidr = cidr
        end
        cidr_hash[new_cidr] = cidr
        
        version = new_cidr.version if (!version)
        unless (new_cidr.version == version)
            raise "Provided CIDR addresses must all be of the same IP version."
        end 
    end

    # sort by network. if networks are equal, sort by netmask.
    sorted_list = []
    cidr_hash.each_key do |entry|
        index = 0
        sorted_list.each do
            if(entry.packed_network < (sorted_list[index]).packed_network)
                break
            elsif (entry.packed_network == (sorted_list[index]).packed_network)
                if (entry.packed_netmask < (sorted_list[index]).packed_netmask)
                    break
                end
            end
            index += 1
        end
        sorted_list.insert(index, entry)
    end
    
    # return original values passed
    ret_list = []
    sorted_list.each {|x| ret_list.push(cidr_hash[x])}

    return(ret_list)
end
module_function :sort

#==============================================================================#
# unpack_ip_addr()
#==============================================================================#

# Unack a packed IP address back into a printable string.
#
# - Arguments:
#   * Integer, or a Hash with the following fields:
#       - :Integer -- Integer representaion of an IP address
#       - :Version -- IP version - Integer (optional)
#       - :IPv4Mapped -- if true, unpack IPv6 as an IPv4 mapped address (optional)
#
# - Returns:
#   * String
#
# - Notes:
#   * IP version will attempt to be auto-detected if not provided
#
# Examples:
#   unpacked = IPAdmin.unpack_ip_addr(3232235906)
#   unpacked = IPAdmin.unpack_ip_addr(:Integer => packed)
#
def unpack_ip_addr(options)
    ipv4_mapped = false
    to_validate = {}
    
    if (options.kind_of?(Hash))
        if (!options.has_key?(:Integer))
            raise ArgumentError, "Missing argument: Integer."
        end
        packed_ip = options[:Integer]
        
        if (options.has_key?(:Version))
            version = options[:Version]
            to_validate[:Version] = version
            if (version != 4 && version != 6)
                raise ArgumentError, ":Version should be 4 or 6, but was '#{version}'."
            end
        end
    
        if (options.has_key?(:IPv4Mapped) && options[:IPv4Mapped] == true)
            ipv4_mapped = true
        end
    elsif (options.kind_of?(Integer))
        packed_ip = options
    else
        raise ArgumentError, "Integer or Hash expected, but #{options.class} provided."
    end
    
    if (!packed_ip.kind_of?(Integer))
        raise ArgumentError, "Packed IP should be an Integer, but was a #{options.class}."
    end
    
    # validate
    to_validate[:IP] = packed_ip
    IPAdmin.validate_ip_addr(to_validate)
    
    # set version if not set
    if (!version)
        if (packed_ip < 2**32)
            version = 4
        else
            version = 6
        end
    end
    
    if (version == 4)
        octets = []
        4.times do
            octet = packed_ip & 0xFF
            octets.unshift(octet.to_s)
            packed_ip = packed_ip >> 8
        end
        ip = octets.join('.')
    else
        fields = []
        if (!ipv4_mapped)
            loop_count = 8
        else
            loop_count = 6
            packed_v4 = packed_ip & 0xffffffff
            ipv4_addr = IPAdmin.unpack_ip_addr(:Integer => packed_v4, :Version => 4)
            fields.unshift(ipv4_addr)
            packed_ip = packed_ip >> 32
        end
        
        loop_count.times do 
            octet = packed_ip & 0xFFFF
            octet = octet.to_s(16)
            packed_ip = packed_ip >> 16

            # if octet < 4 characters, then pad with 0's
            (4 - octet.length).times do
                octet = '0' << octet
            end
            fields.unshift(octet)
        end        
        ip = fields.join(':')
    end
    

    return(ip)
end
module_function :unpack_ip_addr 

#==============================================================================#
# unpack_ip_netmask()
#==============================================================================#

# Unpack a packed IP netmask into an Integer representing the number of
# bits in the CIDR mask.
#
# - Arguments:
#   * Integer, or a Hash with the following fields:
#       - :Integer -- Integer representation of an IP Netmask
#
# - Returns:
#   * Integer
#
# Examples:
#   unpacked = IPAdmin.unpack_ip_netmask(0xfffffffe)
#   unpacked = IPAdmin.unpack_ip_netmask(:Integer => packed)
#
def unpack_ip_netmask(options)
    
    if (options.kind_of?(Hash))
        if (!options.has_key?(:Integer))
            raise ArgumentError, "Missing argument: Integer."
        end
        packed_netmask = options[:Integer]
        
        if (!packed_netmask.kind_of?(Integer))
            raise ArgumentError, "Packed netmask should be an Integer, but is a #{packed_netmask.class}."
        end
        
    elsif (options.kind_of?(Integer))
        packed_netmask = options
        
    else
        raise ArgumentError, "Integer or Hash expected, but #{options.class} provided."
    end    
    
    
    if (packed_netmask < 2**32)
        mask = 32
        IPAdmin.validate_ip_netmask(:Netmask => packed_netmask, :Packed => true, :Version => 4)
    else
        IPAdmin.validate_ip_netmask(:Netmask => packed_netmask, :Packed => true, :Version => 6)
        mask = 128
    end
    
    
    mask.times do    
        if ( (packed_netmask & 1) == 1)
            break
        end
        packed_netmask = packed_netmask >> 1
        mask = mask - 1
    end

    return(mask)
end
module_function :unpack_ip_netmask 

#==============================================================================#
# unshorten()
#==============================================================================#

# Take an IPv6 address in short-hand format, and expand it into standard
# notation. The address should not contain a netmask.
#
# - Arguments:
#   * String
#
# - Returns:
#   * String
#
# Examples:
#   long = IPAdmin.unshorten('fec0::1')
#
def unshorten(addr)

    # is this a string?
    if (!addr.kind_of? String)
        raise ArgumentError, "Expected String, but #{addr.class} provided."
    end

    validate_ip_addr(:IP => addr, :Version => 6)
    ipv4_mapped = true if (addr =~ /\./)
    
    packed = pack_ip_addr(:IP => addr, :Version => 6)    
    if (!ipv4_mapped)
        long = unpack_ip_addr(:Integer => packed, :Version => 6)
    else
        long = unpack_ip_addr(:Integer => packed, :Version => 6, :IPv4Mapped => true)
    end
    
    return(long)
end
module_function :unshorten

#==============================================================================#
# validate_eui()
#==============================================================================#

# Validate an EUI-48 or EUI-64 address. 
#
# - Arguments
#   * String, or a Hash with the following fields:
#       - :EUI -- Address to validate - String
#
# - Returns:
#   * True
#
# Examples:
#   * IPAdmin.validate_eui('01-00-5e-12-34-56')
#   * IPAdmin.validate_eui(:EUI => '01-00-5e-12-34-56')
#
def validate_eui(options)
    if (options.kind_of? Hash)
        if (!options.has_key?(:EUI))
            raise ArgumentError, "Missing argument: EUI."
        end
        eui = options[:EUI]
    elsif (options.kind_of? String)
        eui = options
    else
        raise ArgumentError, "String or Hash expected, but #{options.class} provided."
    end
        
    if (eui.kind_of?(String))
        # check for invalid characters
        if (eui =~ /[^0-9a-fA-f\.\-\:]/)
            raise "#{eui} is invalid (contains invalid characters)."
        end
            
        # split on formatting characters & check lengths
        if (eui =~ /\-/)
            fields = eui.split('-')
            if (fields.length != 6 && fields.length != 8)
                raise "#{eui} is invalid (unrecognized formatting)."
            end 
        elsif (eui =~ /\:/)
            fields = eui.split(':')
            if (fields.length != 6 && fields.length != 8)
                raise "#{eui} is invalid (unrecognized formatting)."
            end
        elsif (eui =~ /\./)
            fields = eui.split('.')
            if (fields.length != 3 && fields.length != 4)
                raise "#{eui} is invalid (unrecognized formatting)."
            end
        else
            raise "#{eui} is invalid (unrecognized formatting)."
        end

    else
        raise ArgumentError, "EUI address should be a String, but was a#{eui.class}."
    end
    return(true)
end
module_function :validate_eui

#==============================================================================#
# validate_ip_addr()
#==============================================================================#

# Validate an IP address. The address should not contain a netmask.
#
# - Arguments
#   * String or Integer, or a Hash with the following fields:
#       - :IP -- IP address to validate - String or Integer
#       - :Version -- IP version - Integer (optional)
#
# - Returns:
#   * True
#
# - Notes:
#   * IP version will attempt to be auto-detected if not provided
#
# Examples:
#   validate_ip_addr('192.168.1.1')
#   validate_ip_addr(IP => 'ffff::1', :Version => 6)
#   validate_ip_addr(IP => '::192.168.1.1')
#   validate_ip_addr(IP => 0xFFFFFF)
#   validate_ip_addr(IP => 2**128-1)
#   validate_ip_addr(IP => 2**32-1, :Version => 4)
#
def validate_ip_addr(options)
    
    if (options.kind_of?(Hash))
        if (!options.has_key?(:IP))
            raise ArgumentError, "Missing argument: IP."
        end
        ip = options[:IP]
    
        if (options.has_key?(:Version))
            version = options[:Version]
            if (version != 4 && version != 6)
                raise ArgumentError, ":Version should be 4 or 6, but was '#{version}'."
            end
        end
    elsif (options.kind_of?(String) || options.kind_of?(Integer))
        ip = options
    else
        raise ArgumentError, "String or Hash expected, but #{options.class} provided."
    end
    
    if ( ip.kind_of?(String) )
        
        # check validity of charaters
        if (ip =~ /[^0-9a-fA-F\.:]/)
            raise "#{ip} is invalid (contains invalid characters)."
        end
        
        # determine version if not specified
        if (!version && (ip =~ /\./ && ip !~ /:/ ) )
            version = 4
        elsif (!version && ip =~ /:/)
            version = 6
        end        
        
        if (version == 4)
            octets = ip.split('.')            
            raise "#{ip} is invalid (IPv4 requires (4) octets)." if (octets.length != 4)
            
            # are octets in range 0..255?
            octets.each do |octet|
                raise "#{ip} is invalid (IPv4 dotted-decimal format " +
                      "should not contain non-numeric characters)." if (octet =~ /[^0-9]/ )                
                octet = octet.to_i()                
                if ( (octet < 0) || (octet >= 256) )
                    raise "#{ip} is invalid (IPv4 octets should be between 0 and 255)."
                end
            end        
        
        elsif (version == 6)
            # make sure we only have at most (2) colons in a row, and then only
            # (1) instance of that
            if ( (ip =~ /:{3,}/) || (ip.split("::").length > 2) )
                raise "#{ip} is invalid (IPv6 field separators (:) are bad)."
            end            
            
            # set flags
            shorthand = false
            if (ip =~ /\./)
                dotted_dec = true 
            else
                dotted_dec = false
            end            
            
            # split up by ':'
            fields = []
            if (ip =~ /::/)
                shorthand = true
                ip.split('::').each do |x|
                    fields.concat( x.split(':') )
                end
            else
               fields.concat( ip.split(':') ) 
            end
            
            # make sure we have the correct number of fields
            if (shorthand)
                if ( (dotted_dec && fields.length > 6) || (!dotted_dec && fields.length > 7) )
                    raise "#{ip} is invalid (IPv6 shorthand notation has " +
                          "incorrect number of fields)." 
                end                
            else
                if ( (dotted_dec && fields.length != 7 ) || (!dotted_dec && fields.length != 8) )
                    raise "#{ip} is invalid (IPv6 address has " +
                          "incorrect number of fields)." 
                end
            end
            
            # if dotted_dec then validate the last field
            if (dotted_dec)
                dotted = fields.pop()
                octets = dotted.split('.')
                raise "#{ip} is invalid (Legacy IPv4 portion of IPv6 " +
                      "address should contain (4) octets)." if (octets.length != 4)
                octets.each do |x|
                    raise "#{ip} is invalid (egacy IPv4 portion of IPv6 " +
                          "address should not contain non-numeric characters)." if (x =~ /[^0-9]/ )
                    x = x.to_i
                    if ( (x < 0) || (x >= 256) )
                        raise "#{ip} is invalid (Octets of a legacy IPv4 portion of IPv6 " +
                              "address should be between 0 and 255)."
                    end
                end
            end
            
            # validate hex fields
            fields.each do |x|
                if (x =~ /[^0-9a-fA-F]/)
                    raise "#{ip} is invalid (IPv6 address contains invalid hex characters)."
                else
                    x = x.to_i(16)
                    if ( (x < 0) || (x >= 2**16) )
                        raise "#{ip} is invalid (Fields of an IPv6 address " +
                              "should be between 0x0 and 0xFFFF)."
                    end
                end
            end
            
        else
            raise "#{ip} is invalid (Did you mean to pass an Integer instead of a String?)."        
        end

    elsif ( ip.kind_of?(Integer) )
        if (version && version == 4)
            raise "#{ip} is invalid (Integer is out of bounds)." if ( (ip < 0) || (ip > 2**32) )
        else
            raise "#{ip} is invalid (Integer is out of bounds)." if ( (ip < 0) || (ip > 2**128) )
        end
        
    else
        raise ArgumentError, "Expected String or Integer, but #{ip.class} provided."    
    end

    
    return(true)
end
module_function :validate_ip_addr

#==============================================================================#
# validate_ip_netmask()
#==============================================================================#

# Validate IP Netmask.
#
# - Arguments:
#   * String or Integer, or a Hash with the following fields:
#       - :Netmask -- Netmask to validate - String or Integer
#       - :Packed -- if true, the provided Netmask is a packed Integer
#       - :Version -- IP version - Integer (optional)
#
# - Returns:
#   * True or exception.
#
# - Notes:
#   * Version defaults to 4 if not specified.
#
# Examples:
#   IPAdmin.validate_ip_netmask('/32')
#   IPAdmin.validate_ip_netmask(32)
#   IPAdmin.validate_ip_netmask(:Netmask => 0xffffffff, :Packed => true)
#
def validate_ip_netmask(options)
    packed = false
    version = 4
    max_bits = 32
    
    if (options.kind_of?(Hash))
        if (!options.has_key?(:Netmask))
            raise ArgumentError, "Missing argument: Netmask."
        end
        netmask = options[:Netmask]
    
        if (options.has_key?(:Packed) && options[:Packed] == true)
            packed = true
        end
    
        if (options.has_key?(:Version))
            version = options[:Version]
            if (version != 4 && version != 6)
                raise ArgumentError, ":Version should be 4 or 6, but was '#{version}'."
            elsif (version == 6)
                max_bits = 128
            else
                max_bits = 32
            end
        end
    
    elsif (options.kind_of?(String) || options.kind_of?(Integer))
        netmask = options
    else
        raise ArgumentError, "String, Integer, or Hash expected, but #{options.class} provided."
    end
    
    if (netmask.kind_of?(String))
        if(netmask =~ /\./)
            all_f = 2**32-1
            packed_netmask = 0
        
            # validate & pack extended mask
            begin
                validate_ip_addr(:IP => netmask)
                packed_netmask = pack_ip_addr(:IP => netmask)
            rescue Exception
                raise "#{netmask} is an improperly formed IPv4 address."
            end

            # cycle through the bits of hostmask and compare
            # with packed_mask. when we hit the firt '1' within
            # packed_mask (our netmask boundary), xor hostmask and
            # packed_mask. the result should be all 1's. this whole
            # process is in place to make sure that we dont have
            # and crazy masks such as 255.254.255.0
            hostmask = 1
            32.times do 
                check = packed_netmask & hostmask
                if ( check != 0)
                    hostmask = hostmask >> 1
                    unless ( (packed_netmask ^ hostmask) == all_f)
                        raise "#{netmask} contains '1' bits within the host portion of the netmask." 
                    end
                    break
                else
                    hostmask = hostmask << 1
                    hostmask = hostmask | 1
                end
            end

        else
            # remove '/' if present
            if (netmask =~ /^\// )
                netmask[0] = " "
                netmask.lstrip!
            end

            # check if we have any non numeric characters
            if (netmask =~ /\D/)
                raise "#{netmask} contains invalid characters."
            end

            netmask = netmask.to_i
            if (netmask > max_bits || netmask == 0 )
                raise "Netmask, #{netmask}, is out of bounds for IPv#{version}." 
            end

        end
        
    elsif (netmask.kind_of?(Integer) )
        if (!packed)
            if (netmask > max_bits || netmask == 0 )
                raise "Netmask, #{netmask}, is out of bounds for IPv#{version}." 
            end
        else
            if (netmask >= 2**max_bits || netmask == 0 )
                raise "Packed netmask, #{netmask}, is out of bounds for IPv#{version}."
            end
        end
        
    else
        raise ArgumentError, "Expected String or Integer, but #{netmask.class} provided."
    end

    return(true)
end
module_function :validate_ip_netmask

#==============================================================================#
# NetStruct
#==============================================================================#

# Struct object used internally by IPAdmin. It is not likely directly useful
# to anyone.
#
# Description of fields:
#   * cidr - IPAdmin::CIDR object
#   * parent - parent NetStruct in tree
#   * children - Array of children NetStruct objects
#
NetStruct = Struct.new(:cidr, :parent, :children)

end # module IPAdmin

__END__

