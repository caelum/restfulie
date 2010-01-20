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

ActiveRecord::Schema.define :version => 0 do
  create_table "restfulie_models", :force => true do |t|
    t.column :status, :string
  end
  create_table "client_restfulie_models", :force => true do |t|
    t.column :status, :string
  end
end
ActiveRecord::Schema.define :version => 1 do
  create_table "orders", :force => true do |t|
  end
  create_table "client_orders", :force => true do |t|
  end
end
ActiveRecord::Schema.define :version => 2 do
  create_table "people", :force => true do |t|
  end
end
ActiveRecord::Schema.define :version => 3 do
  create_table "players", :force => true do |t|
    t.column :name, :string
  end
  create_table "teams", :force => true do |t|
  end
end
