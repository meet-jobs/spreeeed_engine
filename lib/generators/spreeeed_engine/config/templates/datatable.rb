module SpreeeedEngine
  module Datatables
<% @namespaces.each_with_index do |namespace, i| %><%= '  ' * (i+2) %>module <%= @klass.name %><%= "\n" %><% end %>
<%= @indent %>extend ActiveSupport::Concern

<%= @indent %>class_methods do
<% @methods.each do |method| %>
  <%= @indent %>def <%= method.to_s %>
    <%= @indent %><%= @klass.send(method).to_s %>
  <%= @indent %>end
<% end %>
<%= @indent %>end

<% @namespaces.enum_for(:each_with_index).collect { |namespace, i| "#{'  ' * (i+2)}end\n" }.reverse.each { |end_line| %><%= end_line %><% } %>
  end
end