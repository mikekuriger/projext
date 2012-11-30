module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
  
  def link_to_remove_fields(name, f)  
     f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")  
  end
  
  def link_to_clobber_fields(name, f)
    link_to_function(name, "clobber_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.semantic_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))  
  end
  
  def generate_assets_csv(assets = [])
    csv = []
    csv << ["Hostname", "Domain", "FQDN", "Name", "Description", "Type", "State", "Group", "Farm", "ID", "UUID", "CPU Count", "Physical Memory", "Operating System Type", "Operating System", "Operating System Architecture", "Notes"]
    row_data = []
    assets.each do |asset|
      row_data = [asset.hostname]
      %w( domain fqdn name description type state group.name farm.name id uuid cpu_count physical_memory operatingsystem.ostype operatingsystem.name operatingsystem.architecture notes ).each {|field| row_data << eval("asset.#{field}")}
      csv << row_data.dup
    end
    csv
  end
end
