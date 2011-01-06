
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

require 'sdb/request/request_parameter'
require 'sdb/request/sdb_request'

# Object to build of the HTTP Query Request to make a BatchPutAttribute API call.
# Given the 'Domain Name' and an array of 'Items' this class will construct the 
# query request.
module SDB 
  module Request #:nodoc: all
    class BatchPutAttributesRequest < SDBRequest
      								           
      def initialize( domain_name, items, access_key_id, secret_key )
        super( 'BatchPutAttributes', access_key_id, secret_key )

        add_parameter( 'DomainName',  domain_name )        

        if items
          items.each_with_index do |item, item_index|      
            add_parameter( 'Item.' + item_index.to_s + '.ItemName', item.name )
        
            item.attributes.each_with_index do |attribute, attribute_index|
              add_parameter( 'Item.' + item_index.to_s + '.Attribute.' + attribute_index.to_s + '.Name',    attribute.name )
              add_parameter( 'Item.' + item_index.to_s + '.Attribute.' + attribute_index.to_s + '.Value',   attribute.value )
              add_parameter( 'Item.' + item_index.to_s + '.Attribute.' + attribute_index.to_s + '.Replace', attribute.replace )
            end
          end
        end
                
        add_signature()
      end  
    end
  end
end
