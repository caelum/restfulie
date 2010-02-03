#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ':memory:')

ActiveRecord::Schema.define(:version => 1) do
  [:restfulie_models, :client_restfulie_models].each do |table|
    create_table table, :force => true do |t|
      t.column :status, :string
    end
  end
  
  [:orders, :client_orders, :people, :teams].each do |table|
    create_table table, :force => true do 
    end
  end
  
  create_table "players", :force => true do |t|
    t.column :name, :string
  end
end