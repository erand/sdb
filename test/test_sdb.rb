
=begin
Copyright 2009 Amazon.com, Inc. or its affiliates.  All Rights Reserved.  
Licensed under the Amazon Software License (the "License").  You may not
use this file except in compliance with the License. A copy of the 
License is located at http://aws.amazon.com/asl or in the "license" file 
accompanying this file.  This file is distributed on an "AS 
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express 
or implied. See the License for the specific language governing permissions
and limitations under the License. 
=end

require 'sdb/attribute'
require 'sdb/item'
require 'sdb/sdb_response'

class TestSDB
  def TestSDB.domain_api_testing( sdb )
    puts "Create Domain"
    puts "============================================================================================="
    puts sdb.create_domain( "Test-Create-Domain" )
    puts "\n\n"

    puts "List Domains"
    puts "============================================================================================="
    sdb.list_domains().each{ |domain_name| puts "\t * #{domain_name}" }
    
    puts "\n\n"

    puts "Domain MetaData"
    puts "============================================================================================="
    puts sdb.domain_metadata( "Test-Create-Domain" )
    puts "\n\n"

    puts "Delete Domain"
    puts "============================================================================================="
    puts sdb.delete_domain( "Test-Create-Domain" )
    puts "\n\n"

    puts "List Domains"
    puts "============================================================================================="
    puts sdb.list_domains()
    puts "============================================================================================="
    puts "\n\n\n"
  end


  def TestSDB.create_test_domain( sdb )
    puts "Create a domain called 'TestDomain' and put some items into it:"
    sdb.create_domain( "TestDomain" );
    sdb.put_attributes( "TestDomain", "Test_Item_1", [ SDB::Attribute.new( "attributeName1", "attributeValue1" ), SDB::Attribute.new( "attributeName2", "attributeValue2" )] )
    sdb.put_attributes( "TestDomain", "Test_Item_2", [ SDB::Attribute.new( "attributeNameX", "attributeValueX" ), SDB::Attribute.new( "attributeNameY", "attributeValueY" )] )
    sdb.put_attributes( "TestDomain", "Test_Item_3", [ SDB::Attribute.new( "fun", "times" ), SDB::Attribute.new( "laugh", "alot" )] )
    sdb.put_attributes( "TestDomain", "Test_Item_4", [ SDB::Attribute.new( "fruit", "apple" ), SDB::Attribute.new( "tall", "short" )] )

    puts "Domain MetaData for 'TestDomain'"
    puts "============================================================================================="
    puts sdb.domain_metadata( "TestDomain" )
    puts "\n\n"
  end


  def TestSDB.test_select( sdb )
    puts "Select"
    puts "============================================================================================="
    puts sdb.select( "select * from `TestDomain`" )
    puts "\n\n"

    puts "Select Item:"
    puts "============================================================================================="
    sdb.select( "select itemName() from `TestDomain`" ).each{ |item| puts "\t * #{item}" }
    puts "\n\n"

    puts "Select"
    puts "============================================================================================="
    puts sdb.select( "select * from `TestDomain` limit 1" )
    puts "\n\n"
    
    puts "Select eat cheese"
    puts "============================================================================================="
    begin 
        puts sdb.select( "eat chesse" )
    rescue StandardError => exception
      puts "SimpleDB called failed: " + exception
    end
    puts "\n\n"        
  end


  def TestSDB.test_get_put_delete( sdb )
    puts "Get Attributes"
    puts "============================================================================================="
    puts sdb.get_attributes( "TestDomain", "Test_Item_2" ) 
    item1 = sdb.get_attributes( "TestDomain", "Test_Item_4" )
    puts "Attribute [fruit] = " + item1.attribute_map['fruit']
    puts "\n\n"


    puts "Delete Attributes"
    puts "============================================================================================="
    puts sdb.get_attributes( "TestDomain", "Test_Item_3") 
    puts "\n\n"
    puts sdb.delete_attributes( "TestDomain", "Test_Item_3", [ SDB::Attribute.new( "fun", "times" ) ] )
    puts "\n\n"
    puts sdb.get_attributes( "TestDomain", "Test_Item_3") 
    puts "\n\n"

    puts "Put Attributes"
    puts "============================================================================================="
    puts sdb.put_attributes( "TestDomain", "Another_Test_Item", [ SDB::Attribute.new( "wow", "yes" ) ] )
    puts "\n\n"
    puts sdb.get_attributes( "TestDomain", "Another_Test_Item" )
  end


  def TestSDB.test_batch_put( sdb )
    puts "Batch Put Attributes on 'TestDomain'"
    puts "============================================================================================="
    attributes = []
    attributes[0] = SDB::Attribute.new( "BatchAttr1", "BatchValue1", true );
    attributes[1] = SDB::Attribute.new( "BatchAttr2", "BatchValue2", true );

    items = []
    items[0] = SDB::Item.new( "BatchPutItem1", attributes );
    items[1] = SDB::Item.new( "BatchPutItem2", attributes );

    puts sdb.batch_put_attributes( "TestDomain", items );
    puts "Get Attributes for the BatchPut on 'TestDomain'"
    puts sdb.get_attributes( "TestDomain", "BatchPutItem1" );
    puts sdb.get_attributes( "TestDomain", "BatchPutItem2" );
  end
  
  def TestSDB.cleanup( sdb ) 
    puts "Delete the 'TestDomain' domain."
    sdb.delete_domain( "TestDomain" );   
  end
end
