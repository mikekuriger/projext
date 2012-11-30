module AssetsHelper
  include TagsHelper
  
  def add_interface_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :interfaces, :partial => 'interface', :object => Interface.new
    end
  end

  def add_service_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :services, :partial => 'service', :object => Service.new
    end
  end

  def assets_per_page_select(collection = Asset) 
    select_tag :per_page,
               options_for_select([[10, 10], [30, 30], [50, 50], [100, 100], ['All', collection.total_entries]], collection.per_page),
               { :onChange => 'this.form.submit();' }
  end
end
