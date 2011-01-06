
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

require 'sdb/sdb'
require 'test/unit'
require 'test/sdb_base_testcase'

class Get_Put_Delete_Tests < SDB_Base_TestCase
  def setup
    @sdb = create_sdb();
    create_test_domain( @sdb )
  end
  
  def teardown
    delete_test_domain( @sdb )  
  end
  

  def test_get_put_delete()
    validate_response( @sdb.get_attributes( "TestDomain", "Test_Item_2" ) )
    validate_response( @sdb.get_attributes( "TestDomain", "Test_Item_3") )
    validate_response( @sdb.delete_attributes( "TestDomain", "Test_Item_3", [ SDB::Attribute.new( "fun", "times" ) ] ) )
    validate_response( @sdb.get_attributes( "TestDomain", "Test_Item_3") )
    validate_response( @sdb.put_attributes( "TestDomain", "Another_Test_Item", [ SDB::Attribute.new( "wow", "yes" ) ] ) )
    validate_response( @sdb.get_attributes( "TestDomain", "Another_Test_Item" ) )
  end
end
