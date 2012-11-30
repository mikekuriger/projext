# Create the roles
%w( admin guest syseng neteng webeng manager finance executive puppet ).each { |r| Role.create(:name => r) }

# Create a user to be an admin
adminuser = User.create(:email => 'admin@wb.com')
adminuser.confirm_email!
adminuser.update_password('123456', '123456')
adminuser.first_name = 'Eric'
adminuser.last_name = 'Dennis'
# Make that user an admin
adminuser.assignments.create(:role => Role.find_by_name('admin'))
adminuser.save
adminuser.activate

# Create a user to be in the syseng group
sysenguser = User.create(:email => 'syseng@wb.com')
sysenguser.confirm_email!
sysenguser.update_password('123456', '123456')
sysenguser.first_name = 'Sys'
sysenguser.last_name = 'Eng'
# Assign that user the syseng role
sysenguser.assignments.create(:role => Role.find_by_name('syseng'))
sysenguser.save
sysenguser.activate

# Create a user to be in the webeng group
webenguser = User.create(:email => 'webeng@wb.com')
webenguser.confirm_email!
webenguser.update_password('123456', '123456')
webenguser.first_name = 'Web'
webenguser.last_name = 'Eng'
# Assign that user the syseng role
webenguser.assignments.create(:role => Role.find_by_name('webeng'))
webenguser.save
webenguser.activate

# Create an API user
apiuser = User.create(:email => 'api@wb.com')
apiuser.confirm_email!
apiuser.update_password('u38n$jvud!88r#r9dsa', 'u38n$jvud!88r#r9dsa')
apiuser.assignments.create(:role => Role.find_by_name('api'))

# Create puppet users
puppetuser1 = User.create(:email => 'puppet@tungsten.warnerbros.com')
puppetuser1.confirm_email!
puppetuser1.update_password('xxxyyyzzz', 'xxxyyyzzz')
puppetuser1.enable_api!
puppetuser1.assignments.create(:role => Role.find_by_name('puppet'))
puppetuser1.save

puppetuser2 = User.create(:email => 'puppet@r07s06.e.warnerbros.com')
puppetuser2.confirm_email!
puppetuser2.update_password('xxxyyyzzz', 'xxxyyyzzz')
puppetuser2.enable_api!
puppetuser2.assignments.create(:role => Role.find_by_name('puppet'))
puppetuser2.save

# Create a finance user
financeuser = User.create(:email => 'finance@wb.com')
financeuser.confirm_email!
financeuser.update_password('123456', '123456')
financeuser.assignments.create(:role => Role.find_by_name('finance'))

# Create an executive user
executiveuser = User.create(:email => 'executive@wb.com')
executiveuser.confirm_email!
executiveuser.update_password('123456', '123456')
executiveuser.assignments.create(:role => Role.find_by_name('executive'))

# Create another user (no special roles for this one)
guestuser = User.create(:email => 'me@ericdennis.com')
guestuser.confirm_email!
guestuser.update_password('123456', '123456')

Group.create(:name => 'unused', :description => 'Unused')
Group.create(:name => 'utility', :description => 'Utility')

Farm.create(:name => 'manassas', :description => 'Manassas Farm')
Farm.create(:name => 'burbank', :description => 'Burbank Farm')
Farm.create(:name => 'losangeles', :description => 'Los Angeles Farm')

Asset.create(:name => 'laptop1', :serial => 'fdsfda', :group => Group.find_by_name('unused'))
Asset.create(:name => 'laptop2', :serial => 'uirewurew', :group => Group.find_by_name('utility'))
Server.create(:name => 'server1', :serial => '543216', :group => Group.find_by_name('utility'))
Server.create(:name => 'server2', :serial => '123456')

Cluster.create(:name => 'testcluster', :description => 'Test Cluster')
Function.create(:name => 'testfunction', :description => 'Test Function')
Service.create(:cluster => Cluster.find_by_name('testcluster'), :function => Function.find_by_name('testfunction'))
Site.create(:name => 'test.com')

Network.create(:farm => Farm.find_by_name('manassas'), :network => '64.236.92.0', :subnetbits => 24, :vlan => '30', :description => 'World 6 public')
Network.create(:farm => Farm.find_by_name('burbank'), :network => '10.140.207.0', :subnetbits => 24, :vlan => '20', :description => 'Burbank Server Network')

Building.create(:name => 'Pinnacle II', :address1 => '3300 W. Olive Ave.', :city => 'Burbank', :state => 'CA', :zip => '91505')
Room.create(:name => '4th floor server room', :building => Building.find_by_name('Pinnacle II'))
(1..30).each { |n| EquipmentRack.create(:room => Room.find_by_name('4th floor server room'), :name => "Rack #{n}") }

Manufacturer.create(:name => 'IBM', :url => 'http://www.ibm.com/')
Manufacturer.create(:name => 'None')
Manufacturer.create(:name => 'Apple', :url => 'http://www.apple.com/')
Manufacturer.create(:name => 'Brocade', :url => 'http://www.brocade.com/')
Manufacturer.create(:name => 'Cisco', :url => 'http://www.cisco.com/')
Manufacturer.create(:name => 'Foundry', :url => 'http://www.foundrynetworks.com/')
Manufacturer.create(:name => 'Netapp', :url => 'http://www.netapp.com/')
Manufacturer.create(:name => 'HP', :url => 'http://www.hp.com/')
Manufacturer.create(:name => 'CentOS Group', :url => 'http://www.centos.org/')
Manufacturer.create(:name => 'Microsoft', :url => 'http://www.microsoft.com/')
Manufacturer.create(:name => 'Intel', :url => 'http://www.intel.com/')

Vendor.create(:name => 'HP', :url => 'http://www.hp.com/')
Vendor.create(:name => 'Insight Investments', :url => 'http://www.insightinvestments.com/')
Vendor.create(:name => 'Apple', :url => 'http://www.apple.com/')

Operatingsystem.create(:name => 'CentOS 5.3 (32-bit)', :manufacturer => Manufacturer.find_by_name('CentOS Group'), :ostype => 'CentOS', :version => '5.3', :architecture => 'x86')
Operatingsystem.create(:name => 'CentOS 5.3 (64-bit)', :manufacturer => Manufacturer.find_by_name('CentOS Group'), :ostype => 'CentOS', :version => '5.3', :architecture => 'x86_64')
Operatingsystem.create(:name => 'CentOS 5.4 (32-bit)', :manufacturer => Manufacturer.find_by_name('CentOS Group'), :ostype => 'CentOS', :version => '5.4', :architecture => 'x86')
Operatingsystem.create(:name => 'CentOS 5.4 (64-bit)', :manufacturer => Manufacturer.find_by_name('CentOS Group'), :ostype => 'CentOS', :version => '5.4', :architecture => 'x86_64')
Operatingsystem.create(:name => 'Windows Server 2003 (32-bit)', :manufacturer => Manufacturer.find_by_name('Microsoft'), :ostype => 'Windows', :version => 'Server 2003', :architecture => 'x86')
Operatingsystem.create(:name => 'Windows Server 2003 (64-bit)', :manufacturer => Manufacturer.find_by_name('Microsoft'), :ostype => 'Windows', :version => 'Server 2003', :architecture => 'x86_64')

HardwareModel.create(:manufacturer => Manufacturer.find_by_name('IBM'), :name => 'xSeries 335', :rackunits => 1)
HardwareModel.create(:manufacturer => Manufacturer.find_by_name('IBM'), :name => 'xSeries 336', :rackunits => 1)
HardwareModel.create(:manufacturer => Manufacturer.find_by_name('IBM'), :name => 'xSeries 346', :rackunits => 2)
HardwareModel.create(:manufacturer => Manufacturer.find_by_name('Apple'), :name => 'XServe', :rackunits => 1)
HardwareModel.create(:manufacturer => Manufacturer.find_by_name('Brocade'), :name => 'Silkworm 200E', :rackunits => 1)
HardwareModel.create(:manufacturer => Manufacturer.find_by_name('IBM'), :name => 'System x3550', :rackunits => 1)

Customer.create(:name => 'DC Comics', :address1 => '1700 Broadway', :city => 'New York', :state => 'NY', :zip => '10019', :url => 'http://www.dccomics.com/')
Customer.create(:name => 'Telepictures', :city => 'Burbank', :state => 'CA', :url => 'http://www.telepicturestv.com/')
Customer.create(:name => 'ADS', :city => 'Burbank', :state => 'CA', :url => 'http://ads.warnerbros.com/')
Customer.create(:name => 'CWTV', :url => 'http://www.cwtv.com/')

Contact.create(:first_name => 'Dave', :last_name => 'McCullough', :email => 'dave.mccullough@dccomics.com', :phone => '212-636-5495')
Contact.create(:first_name => 'Will', :last_name => 'Rogers', :email => 'will.rogers@telepixtv.com', :phone => '818-977-8222')

Cpu.create(:manufacturer => Manufacturer.find_by_name('Intel'), :cpu_type => 'Xeon', :cores => 4, :speed => '3 GHz')