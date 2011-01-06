
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

# Object to build of the HTTP Query Request to make a GetAttributes API call.
# Given the 'Domain Name' and 'Item Name' this class will construct the query 
# request.
module SDB
  module Request #:nodoc: all
    class GetAttributesRequest < SDBRequest
      								           
      def initialize( domain_name, item_name, attributes, access_key_id, secret_key )
        super( 'GetAttributes', access_key_id, secret_key )

        add_parameter( 'DomainName',  domain_name )        
        add_parameter( 'ItemName',    item_name )        

        if attributes
          attributes.each_with_index do |attribute, index|
            add_parameter( 'AttributeName.' + index.to_s, attribute.name )
          end
        end
                    
        add_signature()
      end
    end
  end
end
