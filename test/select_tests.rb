
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

class Select_Tests < SDB_Base_TestCase
  def setup
    @sdb = create_sdb();
    create_test_domain( @sdb )
  end
  
  def teardown
    delete_test_domain( @sdb )  
  end
  

  def test_select()
    validate_response( @sdb.select( "select * from `TestDomain`" ) )
    validate_response( @sdb.select( "select itemName() from `TestDomain`" ) )
    validate_response( @sdb.select( "select * from `TestDomain` limit 1" ) )
  end
end
