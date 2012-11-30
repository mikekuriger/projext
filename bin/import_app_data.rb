#!/usr/bin/env ../script/runner

require 'CSV'

CSVFILE = "/Users/edennis/Desktop/Temp/applist.csv"

CSV.open(CSVFILE, 'r') do |row|
  name = row[1].strip
  clusters = (row[4] ? row[4].split(',') : Array.new)
  description = row[7]

  puts "\n\n----------"
  puts "Application name: #{name}"
  puts "Application clusters: #{clusters.join(',')}"
  puts "Application description: #{description}"
  
  puts "Creating dummy parent customer"
  customer = Customer.find_or_create_by_name(:name => 'Temporary')

  puts "Creating app record for #{name}"
  app = App.find_or_create_by_name(:name => name, :description => description, :project => Project.find_or_create_by_name(:name => name, :description => description, :customer => customer))
  clusters.each do |cluster|
    puts "Adding cluster #{cluster.strip} to app #{name}"
    begin
      app.clusters.push Cluster.find_or_create_by_name(cluster.downcase.strip)
    rescue
      puts "Couldn't add cluster relationship: $!"
    end
  end
end

