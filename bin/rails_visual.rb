#!/usr/bin/env ruby  
require "config/environment"  
Dir.glob("app/models/*rb") { |f|  
    require f  
}  
  
puts %{digraph x \{   
  has_many1 [shape=point]  
  has_many2 [shape=point]  
  has_many1 -> has_many2 [label="Has many", color=red]  
  belongs_to1 [shape=point]  
  belongs_to2 [shape=point]  
  belongs_to1 -> belongs_to2 [label="Belongs to", color=blue]  
  has_and_belongs_to_many1 [shape=point]  
  has_and_belongs_to_many2 [shape=point]  
  has_and_belongs_to_many1 -> has_and_belongs_to_many2 [label="HaBtM", color=green]  
  has_one1  [shape=point]  
  has_one2  [shape=point]  
  has_one1 -> has_one2 [label="Has one", color=gray]  
  node [shape=box, style=filled, fillcolor=lightgray, width=2.5]   
}  
Dir.glob("app/models/*rb") { |f|  
    f.match(/\/([a-z_]+).rb/)  
    classname = $1.camelize  
    classname = $1 + 'QR' if classname =~ /(\w+)Qr$/ # total hack for question response models  
    klass = Kernel.const_get classname  
    obj = klass.new rescue next  
    if obj.kind_of? ActiveRecord::Base  
        puts classname  
        klass.reflect_on_all_associations.each { |a|  
          att = case a.macro  
                  when :has_many : 'color=red, '# label="#{a.macro.to_s.humanize}"  
                  when :belongs_to : 'color=blue, '  
                  when :has_and_belongs_to_many : 'color=green, '  
                  when :has_one : 'color=gray, '  
                  else 'color=black, '  
                  end  
          puts %{ #{classname} -> #{a.name.to_s.camelize.singularize} [ #{att} fontsize="8"]}  
        }  
    end  
}  
puts "}"  
