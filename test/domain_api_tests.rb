
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

class Domain_API_Tests < SDB_Base_TestCase
  def setup
    @sdb = create_sdb();
  end

  def test_create_domain()
    validate_response( @sdb.create_domain( "Test-Create-Domain" ) )
  end

  
  def test_list_domains()
    validate_response( @sdb.list_domains() )
  end    


  def test_domain_metadata()
    validate_response( @sdb.create_domain( "Test-Create-Domain" ) )
    validate_response( @sdb.domain_metadata( "Test-Create-Domain" ) )
  end    


  def test_delete_domain()
    validate_response( @sdb.delete_domain( "Test-Create-Domain" ) )
  end    
end
