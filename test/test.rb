
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

$: << File.expand_path( File.dirname(__FILE__) + '../../lib/' )

require 'sdb/sdb'
require 'test/test_sdb'

sdb = SDB::SDB.new( ENV['AWS_KEY'], ENV['AWS_SECRET_KEY'] );

puts "Starting SDB-Ruby Test...."
puts ""

begin
  TestSDB.domain_api_testing( sdb )
  TestSDB.create_test_domain( sdb )
  TestSDB.test_select( sdb )
  TestSDB.test_get_put_delete( sdb )
  TestSDB.test_batch_put( sdb )
  TestSDB.cleanup( sdb ) 
rescue StandardError => exception
  puts "SimpleDB called failed: " + exception
end

puts "============================================================================================="
puts "SDB-Ruby Test Completed"
