
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

class Batch_Put_Tests < SDB_Base_TestCase
  def setup
    @sdb = create_sdb();
    create_test_domain( @sdb )
  end
  
  def teardown
    delete_test_domain( @sdb )  
  end
  

  def test_batch_put()
    attributes = [ SDB::Attribute.new( "BatchAttr1", "BatchValue1", true ), SDB::Attribute.new( "BatchAttr2", "BatchValue2", true ) ]
    items = [ SDB::Item.new( "BatchPutItem1", attributes ), SDB::Item.new( "BatchPutItem2", attributes ) ]

    validate_response( @sdb.batch_put_attributes( "TestDomain", items ) )
    validate_response( @sdb.get_attributes( "TestDomain", "BatchPutItem1" ) )
    validate_response( @sdb.get_attributes( "TestDomain", "BatchPutItem2" ) )
  end
end
