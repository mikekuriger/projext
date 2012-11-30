module IPAdmin

# Generic EUI address. By default, it will act as an EUI48 address. 
# As a general rule, it is probably better to use the EUI48 and EUI64 classes.
class EUI

# instance variables
# @oui - Organizationally Unique Identifier 
# @ei - Extention Identifier

#==============================================================================#
# initialize()
#==============================================================================#

# - Arguments:
#   * EUI as a String, or a Hash with the following fields:
#       - :EUI -- Extended Unique Identifier - String
#       - :PackedEUI -- Integer representing an Extended Unique Identifier (optional)
#
# - Note:
#   * PackedEUI takes precedence over EUI.
#
# Examples:
#   addr = IPAdmin::EUI48.new('aa-bb-cc-dd-ee-ff')
#   addr = IPAdmin::EUI48.new('aa:bb:cc:dd:ee:ff')
#   addr = IPAdmin::EUI48.new('aabb.ccdd.eeff')
#   addr = IPAdmin::EUI64.new('aa-bb-cc-dd-ee-ff-00-01')
#
    def initialize(options)
        if (options.kind_of? String)
            eui = options
        elsif (options.kind_of? Hash)
            if (options.has_key?(:PackedEUI))
                packed_eui = options[:PackedEUI]
            elsif(options.has_key?(:EUI))
                eui = options[:EUI]
            else
                raise ArgumentError, "Missing argument: [EUI|PackedEUI]."
            end
        else
            raise ArgumentError, "Expected Hash or String, but #{options.class} provided."
        end

        if (packed_eui)
            if (packed_eui.kind_of?(Integer))
                if (self.kind_of?(IPAdmin::EUI64))
                    @oui = packed_eui >> 40
                    @ei = packed_eui & 0xffffffffff
                else
                    @oui = packed_eui >> 24
                    @ei = packed_eui & 0xffffff
                end
            else
                raise ArgumentError, "Expected Integer, but #{eui.class} " +
                                     "provided for argument :PackedEUI."
            end

        elsif(eui)
            if (eui.kind_of?(String))
                # validate
                IPAdmin.validate_eui(:EUI => eui)

                # remove formatting characters
                eui.gsub!(/[\.\:\-]/, '')

                # split into oui & ei, pack, and store
                @oui = eui.slice!(0..5).to_i(16)
                @ei = eui.to_i(16)

            else
                raise ArgumentError, "Expected String, but #{eui.class} " +
                                     "provided for argument :EUI."
            end
        end
    end

#==============================================================================#
# address()
#==============================================================================#

# Returns EUI address.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Delimiter -- delimitation character. valid values are (-,:,and .) (optional)
#
# - Returns:
#   * String
#
# - Notes:
#   * The default address format is xxxx.xxxx.xxxx
#
# Examples:
#   puts addr.address(:Delimiter => '.')   --> 'aabb.ccdd.eeff'
#
    def address(options=nil)
        delimiter = '-'

        octets = []
        octets.concat(unpack_oui)
        octets.concat(unpack_ei)

        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end

            if (options.has_key?(:Delimiter))
                delimiter = options[:Delimiter]
                delimiter = '-' if (delimiter != '-' && delimiter != ':' && delimiter != '.' )
            end
        end

        if (delimiter == '-' || delimiter == ':')
                    address = octets.join(delimiter)
        elsif (delimiter == '.')
                toggle = 0
                octets.each do |x|
                    if (!address)
                        address = x
                        toggle = 1
                    elsif (toggle == 0)
                        address = address  << '.' << x
                        toggle = 1
                    else
                        address = address << x
                        toggle = 0
                    end
                end 

        end

        return(address)
    end

#==============================================================================#
# ei()
#==============================================================================#

# Returns Extended Identifier portion of an EUI address (the vendor assigned ID).
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Delimiter -- delimitation character. valid values are (-, and :) (optional)
#
# - Returns:
#   * String
#
# - Notes:
#   * The default address format is xx-xx-xx
#
# Examples:
#   puts addr.ei(:Delimiter => '-')
#
    def ei(options=nil)
        octets = unpack_ei()
        delimiter = '-'

        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end

            if (options.has_key?(:Delimiter))
                if (options[:Delimiter] == ':')
                    delimiter = options[:Delimiter]
                end
            end
        end
        ei = octets.join(delimiter)

        return(ei)
    end

#==============================================================================#
# link_local()
#==============================================================================#

# Provide an IPv6 Link Local address based on the current EUI address.
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Short -- if true, return IPv6 addresses in short-hand notation (optional)
#       - :Objectify -- if true, return CIDR objects (optional)
#
# - Returns:
#   * CIDR address String or an IPAdmin::CIDR object
#
# Examples:
#   puts addr.link_local()
#
    def link_local(options=nil)
        objectify = false
        short = false

        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end

            if (options.has_key?(:Objectify) && options[:Objectify] == true)
                objectify = true
            end

            if (options.has_key?(:Short) && options[:Short] == true)
                short = true
            end
        end

        if (self.kind_of?(IPAdmin::EUI64))
            link_local = @ei | (@oui << 40)
        else
            link_local = @ei | 0xfffe000000 | (@oui << 40)
        end
        link_local = link_local | (0xfe80 << 112)

        if (!objectify)
            link_local = IPAdmin.unpack_ip_addr(:Integer => link_local, :Version => 6)
            link_local = IPAdmin.shorten(link_local) if (short)
        else
            link_local = IPAdmin::CIDR.new(:PackedIP => link_local,  
                                           :Version => 6)
        end

        return(link_local)
    end

#==============================================================================#
# oui()
#==============================================================================#

# Returns Organizationally Unique Identifier portion of an EUI address (the vendor ID).
#
# - Arguments:
#   * Optional Hash with the following fields:
#       - :Delimiter -- delimitation character. valid values are (-, and :) (optional)
#
# - Returns:
#   * String
#
# - Notes:
#   * The default address format is xx-xx-xx
#
# Examples:
#   puts addr.oui(:Delimiter => '-')
#
    def oui(options=nil)
        octets = unpack_oui()
        delimiter = '-'

        if (options)
            if (!options.kind_of? Hash)
                raise ArgumentError, "Expected Hash, but #{options.class} provided."
            end

            if (options.has_key?(:Delimiter))
                if (options[:Delimiter] == ':')
                    delimiter = options[:Delimiter]
                end
            end
        end
        oui = octets.join(delimiter)

        return(oui)
    end


# PRIVATE METHODS
private

#==============================================================================#
# unpack_ei()
#==============================================================================#

    def unpack_ei()
        hex = @ei
        octets = []

        if (self.kind_of?(IPAdmin::EUI64))
            length = 64
        else
            length = 48
        end

        loop_count = (length - 24)/8
        loop_count.times do
           octet = (hex & 0xff).to_s(16)
           octet = '0' << octet if (octet.length != 2)
           octets.unshift(octet)
           hex = hex >> 8 
        end
        return(octets)
    end

#==============================================================================#
# unpack_oui()
#==============================================================================#

    def unpack_oui()
        hex = @oui
        octets = []
        3.times do
           octet = (hex & 0xff).to_s(16)
           octet = '0' << octet if (octet.length != 2)
           octets.unshift(octet)
           hex = hex >> 8 
        end
        return(octets)
    end

end # class EUI

# EUI-48 Address - Inherits all methods from IPAdmin::EUI. 
# Addresses of this type have a 24-bit OUI and a 24-bit EI.
class EUI48 < EUI
end

# EUI-64 Address - Inherits all methods from IPAdmin::EUI. 
# Addresses of this type have a 24-bit OUI and a 40-bit EI.
class EUI64 < EUI
end

end # module IPAdmin
__END__
