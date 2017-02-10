class SpreeeedEngineCreate<%= @file_name.pluralize.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :spreeeed_engine_<%= @file_name.pluralize %> do |t|
      t.string    :name
      t.string    :email
      t.string    :password
      t.string    :phone
      t.text      :content
      t.integer   :credit
      t.float     :rate
      t.decimal   :amount
      t.datetime  :beginning_at
      t.date      :ending_date
      t.time      :ending_time
      # t.daterange :availability
      # t.numrange  :legally_ages
      t.boolean   :published
      # t.money     :money
      t.timestamps
    end

    create_table :spreeeed_engine_fake_photos do |t|
      t.integer   :owner_id
      t.string    :asset
      t.string    :caption
      t.string    :label
      t.integer   :width
      t.integer   :height
      t.integer   :size
      t.string    :content_type
      t.string    :original_url
      t.timestamps
    end
  end
end