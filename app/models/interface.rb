class Interface < ActiveRecord::Base
  attr_accessible :name, :description, :type, :state, :asset_id, :ip_id, :speed, :mac, :connector_type

  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'

  belongs_to :asset
  belongs_to :ip

  has_one :cable
  
  SPEED_OPTIONS = [
    ['10/100', '10/100'],
    ['10/100/1000', '10/100/1000'],
    ['1000', '1000'],
    ['2Gb FC', '2Gb FC'],
    ['4Gb FC', '4Gb FC'],
    ['N/A', 'N/A'],
    ['Unknown', 'Unknown']
  ]
  
  CONNECTOR_TYPE_OPTIONS = [
    ['RJ-45', 'RJ-45'],
    ['LC', 'LC'],
    ['SC', 'SC'],
    ['N/A', 'N/A'],
    ['Unknown', 'Unknown']
  ]
  
  acts_as_network :conns, :through => :cables

  before_validation :filter_mac
  validates_presence_of :name, :message => "Interface name can't be blank"  
  validates_format_of :mac,
                      # :with => /^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$/,
                      :with => /^([0-9a-f]){12}$/,
                      :message => "MAC address must be valid"
  # validates_inclusion_of :connector_type, :in => CONNECTOR_TYPE_OPTIONS.collect{|type| type[0]}
  
  has_paper_trail :meta => { :asset_id => Proc.new { |a| a.asset_id }}
  
  def filter_mac
    self.mac = mac.downcase.gsub(/[^0-9a-f]/, "") if attribute_present?("mac")
  end
  
  def mac(format = :none)
    tmac = attributes['mac']
    if format == :standard
      [10, 8, 6, 4, 2].each {|pos| tmac.insert pos, ':'}
      return tmac
    end
    super
  end
  
  def connected_interface
    return if cables.empty?
    cab = cables.first
    if cab.interface == self
      return cab.interface_target
    else
      return cab.interface
    end
  end
end


# == Schema Information
#
# Table name: interfaces
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :string(255)
#  state        :string(255)
#  asset_id     :integer(4)
#  ip_id        :integer(4)
#  speed        :string(255)
#  mac          :string(255)
#  connector_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  cable_id     :integer(4)
#

