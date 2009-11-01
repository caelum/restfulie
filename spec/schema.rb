ActiveRecord::Schema.define :version => 0 do
  create_table "restfulie_models", :force => true do |t|
  end
end
ActiveRecord::Schema.define :version => 1 do
  add_column :restfulie_models, :status, :string
end
