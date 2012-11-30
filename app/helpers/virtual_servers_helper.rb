module VirtualServersHelper
  def virtual_servers_per_page_select(collection = VirtualServer)
    select_tag :per_page,
               options_for_select([[10, 10], [30, 30], [50, 50], [100, 100], ['All', collection.total_entries]], collection.per_page),
               { :onChange => 'this.form.submit();' }
  end
end
