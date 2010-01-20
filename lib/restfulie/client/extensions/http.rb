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

# an extesion to http responses
module Restfulie::Client::HTTPResponse
  
  attr_accessor :previous
        
  # determines if this response code was successful (according to http specs: 200~299)
  def is_successful?
    code.to_i >= 200 && code.to_i <= 299
  end
    
  # determines if this response code was successful (according to http specs: 100~199)
  def is_informational?
    code.to_i >= 100 && code.to_i <= 199
  end
    
  # determines if this response code was successful (according to http specs: 300~399)
  def is_redirection?
    code.to_i >= 300 && code.to_i <= 399
  end
    
  # determines if this response code was successful (according to http specs: 400~499)
  def is_client_error?
    code.to_i >= 400 && code.to_i <= 499
  end
    
  # determines if this response code was successful (according to http specs: 500~599)
  def is_server_error?
    code.to_i >= 500 && code.to_i <= 599
  end
  
  def etag
    self['Etag']
  end

  def last_modified
    self['Last-Modified']
  end
    
end
