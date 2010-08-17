ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ':memory:')

ActiveRecord::Schema.define(:version => 1) do
  [:restfulie_models, :client_restfulie_models].each do |table|
    create_table table, :force => true do |t|
      t.column :status, :string
    end
  end
  
  [:orders, :client_orders, :people, :teams, :shipments].each do |table|
    create_table table, :force => true do 
    end
  end
  
  create_table :players, :force => true do |t|
    t.column :name, :string
  end
  
end