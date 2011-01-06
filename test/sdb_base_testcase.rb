
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

require 'test/unit'

class SDB_Base_TestCase < Test::Unit::TestCase

  def test_placeholder() 
  end


  protected  
  def create_sdb()
    SDB::SDB.new( ENV['AWS_KEY'], ENV['AWS_SECRET_KEY'] )
  end
  
  
  def create_test_domain( sdb )
    sdb.create_domain( "TestDomain" )
    sdb.put_attributes( "TestDomain", "Test_Item_1", [ SDB::Attribute.new( "attributeName1", "attributeValue1" ), SDB::Attribute.new( "attributeName2", "attributeValue2" )] )
    sdb.put_attributes( "TestDomain", "Test_Item_2", [ SDB::Attribute.new( "attributeNameX", "attributeValueX" ), SDB::Attribute.new( "attributeNameY", "attributeValueY" )] )
    sdb.put_attributes( "TestDomain", "Test_Item_3", [ SDB::Attribute.new( "fun", "times" ), SDB::Attribute.new( "laugh", "alot" )] )
    sdb.put_attributes( "TestDomain", "Test_Item_4", [ SDB::Attribute.new( "fruit", "apple" ), SDB::Attribute.new( "tall", "short" )] )
  end
  
  
  def delete_test_domain( sdb ) 
    sdb.delete_domain( "TestDomain" )    
  end
  
  
  def validate_response( response ) 
    assert_not_nil( response.request_id, "All SimpleDB calls should return a Request Id." )
    assert( response.box_usage.to_f > 0, "All valid SimpleDB calls should return a non-zero Box Usage." )
    assert_nil( response.error_code,     "All valid SimpleDB calls should NOT return an Error Code." )
    assert_nil( response.error_message,  "All valid SimpleDB calls should NOT return an Error Code." )
  end


end
