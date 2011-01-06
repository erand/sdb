
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

require 'sdb/sdb_response'
require 'sdb/item'

module SDB

  # An immutable class that represents the a list of Items returned via a 'Select' SimpleDB API call.
  class ItemList < SDBResponse
    # An array of Item objects.
    attr_reader :items
    
    # String token to be included in subsequent 'select' calls to get the next batch of Items.
    attr_reader :next_token
        
            
    # Allows for enumeration over the items.
    def each
        items.each do |item| 
            yield item
        end
    end
    
    
    def to_s        
      result = "Items:\n"
      @items.each{ |item| result += "\t#{item}" }
      
      result += super
      
      return result
    end


    protected
    def initialize( parameters, items ) #:nodoc:
      super( parameters )
      @items = items;
      @next_token = parameters[ 'NextToken' ] 
    end
    
    
    # Class method which builds an ItemList object from an XML document.
    # The XML document is the SimpleDB response from the Select API call.
    def ItemList.build_from_xml_document( xml_document ) #:nodoc:
      parameters = SDBResponse.get_parameters_from_xml_document( xml_document )    
      parameters = SDBResponse.add_parameter( parameters, xml_document, 'NextToken', '//NextToken' )

      item_elements = SDBResponse.extract_elements( xml_document, '//Item' );
      items = item_elements.collect{ |item_element| Item.build_from_xml_element( "#{item_element}" ) }

      return ItemList.new( parameters, items )        
    end    
  end
end
