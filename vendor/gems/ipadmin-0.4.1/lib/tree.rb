module IPAdmin
class Tree

# instance variables
# @all_f
# @max_bits
# @root
# @version

#==============================================================================#
# initialize()
#==============================================================================#

# - Arguments:
#   * none
#
# Examples:
#   tree = IPAdmin::Tree.new()
#
    def initialize(options=nil)
        # root of our ordered IP tree
        @root = NetStruct.new(nil, nil, [])
    end

#==============================================================================#
# add!()
#==============================================================================#

# Add a CIDR address or IPAdmin::CIDR object to the tree.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * nil
#
# Examples:
#   tree.add!('192.168.1.0/24')
#   cidr = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24', :Tag => {:title => 'test net'}
#   tree.add!(cidr)
#
    def add!(new)
        duplicate = false

        # validate object
        if ( !new.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => new)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        else
            cidr = new.dup
        end

        version = cidr.version
        new_entry = NetStruct.new(cidr, nil, [])

        # find cidr's parent
        new_entry.parent = find_parent(cidr, @root)

        # check parent for subnets of cidr
        new_entry.parent.children.each do |old_entry|
            if (old_entry.cidr.version == version)
                comp = IPAdmin.compare(cidr,old_entry.cidr)
                if (comp && comp[0] == cidr)
                    old_entry.parent = new_entry
                    new_entry.children.push(old_entry)
                elsif (comp && comp == 1)
                    duplicate = true
                    break
                end
            end
        end

        if (!duplicate)
            new_entry.children.each do |old_entry|
                new_entry.parent.children.delete(old_entry)
            end

            # add new object as an ordered entry to parent.children
            add_to_parent(new_entry,new_entry.parent)
        end

        return(nil)
    end

#==============================================================================#
# ancestors()
#==============================================================================#

# Returns all the ancestors of the provided CIDR addresses.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * Array of IPAdmin::CIDR objects
#
# Examples:
#   puts tree.ancestors('192.168.1.0/27')
#
    def ancestors(cidr)
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end
        
        list = []
        parent = find_parent(cidr,@root)
        
        until (parent == @root)
            list.push(parent.cidr)
            parent = parent.parent
        end

        return(list)
    end

#==============================================================================#
# children()
#==============================================================================#

# Returns all the immediate children of the provided CIDR addresses.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * Array of IPAdmin::CIDR objects
#
# Examples:
#   puts tree.children('192.168.1.0/24')
#
    def children(cidr)
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        list = []
        find_me(cidr).children.each do |child|
            list.push(child.cidr)
        end

        return(list)
    end

#==============================================================================#
# descendants
#==============================================================================#

# Return all descendants of the provided CIDR address.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * Array of IPAdmin::CIDR objects
#
# Examples:
#   descendants = tree.descendants('192.168.1.0/24')
#
    def descendants(cidr)
        list = []
        
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        me = find_me(cidr)        
        dump_children(me).each {|x| list.push(x[:NetStruct].cidr)} if (me)

        return(list)
    end

#==============================================================================#
# delete!()
#==============================================================================#

# Remove the provided CIDR address from the tree.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * true on success or false on fail
#
# Examples:
#   did_remove = tree.remove!('192.168.1.0/24')
#
    def delete!(cidr)
        removed = false
        
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        # find matching
        me = find_me(cidr)
        
        # remove
        if (me)
            parent = me.parent
            children = me.children 
            parent.children.delete(me)
            children.each {|x| add_to_parent(x,parent)}
            removed = true
        end

        return(removed)
    end

#==============================================================================#
# dump
#==============================================================================#

# Dump the contents of this tree.
#
# - Arguments:
#   * none
#
# - Returns:
#   * ordered array of hashes with the following fields: 
#       - :CIDR => IPAdmin::CIDR object
#       - :Depth => (depth level in tree)
# Examples:
#   dumped = tree.dump()
#
    def dump()
        list = []
        dumped = dump_children(@root)

        dumped.each do |entry|
            depth = entry[:Depth]
            net_struct = entry[:NetStruct]
            list.push({:Depth => depth, :CIDR => net_struct.cidr})
        end

        return(list)
    end

#==============================================================================#
# exists?()
#==============================================================================#

# Has a CIDR address already been added to the tree?
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * true or false
#
# Examples:
#   added = tree.exists?('192.168.1.0/24')
#
    def exists?(cidr)
        found = false

        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        found = true if (find_me(cidr))
        return(found)
    end

#==============================================================================#
# fill_in!()
#==============================================================================#

# Fill in the missing subnets of a particular CIDR.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * true or false
#
# Examples:
#   success = tree.fill_in!('192.168.1.0/24')
#
    def fill_in!(cidr)
        filled = false

        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        me = find_me(cidr)        
        if (me && me.children.length != 0)
            list = []
            me.children.each {|x| list.push(x.cidr)}
            me.cidr.fill_in(:List => list, :Objectify => true).each do |cidr|
                self.add!(cidr)
            end
            filled = true
        end
        return(filled)
    end

#==============================================================================#
# find()
#==============================================================================#

# Find and return a CIDR from within the tree.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * IPAdmin::CIDR object, or nil
#
# Examples:
#   cidr = tree.find('192.168.1.0/24')
#
    def find(cidr)
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        return(find_me(cidr).cidr)
    end

#==============================================================================#
# find_space()
#==============================================================================#

# Find subnets that are of at least size X. Only subnets that are not themselves 
# subnetted will be returned.
#
# - Arguments:
#   * Minimum subnet size in bits, or a Hash with the following fields:
#       - :Subnet - minimum subnet size in bits for returned subnets
#       - :IPCount - minimum IP count per subnet required for returned subnets
#       - :Version - restrict results to IPvX
#
# - Returns:
#   * Array of IPAdmin::CIDR objects
#
# - Notes:
#   * :Subnet takes precedence over :IPCount
#
# Examples:
#   subnets = tree.find_space(:IPCount => 16)
#
    def find_space(options)
        version = nil
        if (options.kind_of? Integer)
            bits4 = options
            bits6 = options
        elsif (options.kind_of? Hash) 
            if (options.has_key?(:Version))
                version = options[:Version]
                raise "IP version should be 4 or 6, but was #{version}." if (version != 4 && version !=6)
            end

            if (options.has_key?(:Subnet))
                bits4 = options[:Subnet]
                bits6 = options[:Subnet]
            elsif(options.has_key?(:IPCount))
                bits4 = IPAdmin.minimum_size(:IPCount => options[:IPCount], :Version => 4)
                bits6 = IPAdmin.minimum_size(:IPCount => options[:IPCount], :Version => 6)
            else
                raise "Missing arguments: :Subnet/:IPCount"
            end
        else
            raise "Integer or Hash expected, but #{options.class} provided."
        end

        list4 = []
        list6 = []
        dump_children(@root).each do |entry|
            netstruct = entry[:NetStruct]
            if (netstruct.cidr.version == 4)
                if ( (netstruct.children.length == 0) && (netstruct.cidr.bits <= bits4) )
                    list4.push(netstruct.cidr)
                end
            else
                if ( (netstruct.children.length == 0) && (netstruct.cidr.bits <= bits6) )
                    list6.push(netstruct.cidr)
                end
            end
        end
        
        list = []
        if (!version)
            list.concat(list4)
            list.concat(list6)
        else
            list.concat(list4) if (version == 4)
            list.concat(list6) if (version == 6)
        end

        return(list)
    end

#==============================================================================#
# longest_match()
#==============================================================================#

# Find the longest matching branch of our tree to which a 
# CIDR address belongs. Useful for performing 'routing table' style lookups.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * IPAdmin::CIDR object, or nil
#
# Examples:
#   longest_match = tree.longest_match('192.168.1.1')
#
    def longest_match(cidr)
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin                
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end
        
        found = find_me(cidr)
        found = find_parent(cidr, @root) if !found

        return(found.cidr)
    end

#==============================================================================#
# merge_subnets!()
#==============================================================================#

# Merge (summarize) all subnets of the provided CIDR address.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * true on success or false on fail
#
# Examples:
#   tree.merge_subnets!('192.168.1.0/24')
#
    def merge_subnets!(cidr)
        merged = false
        
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        me = find_me(cidr)
        
        if (me)
            to_merge = []
            me.children.each {|x| to_merge.push(x.cidr)}
            to_merge.each {|x| delete!(x)}

            IPAdmin.merge(to_merge).each {|x| add!(x)}            
            merged = true
        end

        return(merged)
    end

#==============================================================================#
# prune!()
#==============================================================================#

# Remove all subnets of the provided CIDR address.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * true on success or false on fail
#
# Examples:
#   did_prune = tree.prune!('192.168.1.0/24')
#
    def prune!(cidr)
        pruned = false
        
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        me = find_me(cidr)
        
        if (me)
            me.children.clear
            pruned = true
        end

        return(pruned)
    end

#==============================================================================#
# remove!()
#==============================================================================#

# Remove the provided CIDR address, and all of its subnets from the tree.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * true on success or false on fail
#
# Examples:
#   did_remove = tree.remove!('192.168.1.0/24')
#
    def remove!(cidr)
        removed = false
        found = nil
        
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        me = find_me(cidr)
        
        if (me)
            parent = me.parent
            parent.children.delete(me)
            removed = true
        end
        
        return(removed)
    end

#==============================================================================#
# resize!()
#==============================================================================#

# Resize the provided CIDR address.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#   * Integer representing the bits of the new netmask
#
# - Returns:
#   * true on success or false on fail
#
# Examples:
#   resized = tree.resize!('192.168.1.0/24', 23)
#
    def resize!(cidr,bits)
        resized = false
        
        # validate cidr
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end

        me = find_me(cidr)
        
        if (me)
            new = me.cidr.resize(bits)
            delete!(me.cidr)
            add!(new)
            resized = true
        end
        
        return(resized)
    end

#==============================================================================#
# root()
#==============================================================================#

# Returns the root of the provided CIDR address.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * IPAdmin::CIDR object
#
# Examples:
#   puts tree.root('192.168.1.32/27')
#
    def root(cidr)
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end
        
        parent = find_parent(cidr,@root)
        
        if (parent && parent != @root)
            until (parent.parent == @root)
                parent = parent.parent
            end
        end

        return(parent.cidr)
    end

#==============================================================================#
# show()
#==============================================================================#

# Print the tree in a nicely formatted string.
#
# - Arguments:
#   * none
#
# - Returns:
#   * String
#
# Examples:
#   puts tree.show()
#
    def show()
        printed = ""
        list = dump_children(@root)

        list.each do |entry|
            cidr = entry[:NetStruct].cidr
            depth = entry[:Depth]

            if (depth == 0)
                indent = ""
            else
                indent = " " * (depth*3)
            end

            printed << "#{indent}#{cidr.desc(:Short => true)}\n"
        end

        return(printed)
    end

#==============================================================================#
# siblings()
#==============================================================================#

# Return list of the sibling CIDRs of the provided CIDR address.
#
# - Arguments:
#   * String or IPAdmin::CIDR object
#
# - Returns:
#   * Array of IPAdmin::CIDR objects
#
# Examples:
#   puts tree.siblings('192.168.1.0/27')
#
    def siblings(cidr)
        # validate object
        if ( !cidr.kind_of?(IPAdmin::CIDR) )
            begin
                cidr = IPAdmin::CIDR.new(:CIDR => cidr)
            rescue Exception => error
                raise ArgumentError, "Provided argument raised the following " +
                                     "errors: #{error}"
            end
        end
        
        list = []
        find_parent(cidr,@root).children.each do |entry|
            if (!IPAdmin.compare(cidr,entry.cidr))
                list.push(entry.cidr)
            end
        end

        return(list)
    end

#==============================================================================#
# supernets()
#==============================================================================#

# Return list of the top-level supernets of this tree.
#
# - Arguments:
#   * none
#
# - Returns:
#   * Array of IPAdmin::CIDR objects
#
# Examples:
#   supernets = tree.supernets()
#
    def supernets()
       supernets = []
       @root.children.each {|x| supernets.push(x.cidr)}
       return (supernets)
    end


# PRIVATE INSTANCE METHODS
private

#==============================================================================#
# add_to_parent() private
#==============================================================================#

# Add NetStruct object to an array of NetStruct's
#
    def add_to_parent(new_entry, parent)       
        index = 0
        parent.children.each do
            if(new_entry.cidr.packed_network < parent.children[index].cidr.packed_network)
                break
            end
            index += 1
        end

        parent.children.insert(index, new_entry)

        return()
    end

#==============================================================================#
# dump_children() private
#==============================================================================#

#  Dump contents of an Array of NetStruct objects
#
    def dump_children(parent,depth=nil)
        list = []
        depth = 0 if (!depth)

        parent.children.each do |entry|
            list.push({:NetStruct => entry, :Depth => depth})

            if (entry.children.length > 0)
                list.concat( dump_children(entry, (depth+1) ) )
            end
        end

        return(list)
    end

#==============================================================================#
# find_me() private
#==============================================================================#

# Find the NetStruct to which a cidr belongs.
#
    def find_me(cidr)
        me = nil
        
        # find matching
        parent = find_parent(cidr,@root)
        parent.children.each do |entry|
            if (entry.cidr.version == cidr.version)
                if (IPAdmin.compare(entry.cidr,cidr) == 1)
                    me = entry
                    break
                end
            end
        end

        return(me)
    end

#==============================================================================#
# find_parent() private
#==============================================================================#

# Find the parent NetStruct to which a child NetStruct belongs.
#
    def find_parent(cidr,parent)
        version = cidr.version

        parent.children.each do |entry|
            if (entry.cidr.version == version && entry.cidr.contains?(cidr))
                parent = entry

                if (parent.children.length > 0)
                    search_results = find_parent(cidr,parent)
                    parent = search_results if (search_results)
                end
                break
            end
        end

        return(parent)
    end

end # class Tree

end # module IPAdmin
__END__
