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
#
require File.join(File.dirname(__FILE__),'..','spec_helper')

context Restfulie::Client do

  before :all do
    Restfulie::Client::Initializer.run do |config|
      config.hosts = ['http://people.abril.com.br::3000/', 'http://songs.abril.com.br/']
    end
    Person = Restfulie::Client::EntryPoint.at 'person/'
    #Song   = Restifulie::Client::EntryPoint.at 'song/'
  end

  it 'should retrieve a collection' do
    people = Person.get_all
    people.size.should == 0
  end

  #it "" do
    #people = Person.get_top_ten
  #end

  #it "" do
    #person = Person.get_all.first
    #person.name
    #person.name = 'fdp'
    #person.put!
  #end

  #it "" do
    #person = Person.get_all.first 
    #were_not_gona_take_it = Song.get_all.first
    #assert 0, person.songs.size
    #person.songs.buy(were_not_gona_take_it)
    #assert we_are_got_take_it.id, person.songs.first.id
  #end

  #it "" do
    #page_people = Person.get_paginate
    #page_people.next
  #end

  #it "" do
    #person = Person.post!(:name => '', :age => '')
  #end

end

