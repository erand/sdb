
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

module SDB

  # An immutable class that represents the data returned from a 'DomainMetadata' SimpleDB API call.
  class DomainMetadata < SDBResponse
    # Number of items in the domain.
    attr_reader :item_count
    
    # Number of bytes used to store the item names in the domain.
    attr_reader :item_names_size_bytes
    
    # Number of unique attribute names in the domain.
    attr_reader :attribute_name_count
    
    # Number of bytes used to store the attribute names in the domain.
    attr_reader :attribute_names_size_bytes
    
    # Number of attributes values in the domain.
    attr_reader :attribute_value_count
    
    # Number of bytes used to store the attributes values in the domain.
    attr_reader :attribute_values_size_bytes
    
    # Date and Time string for when the data was computed.
    attr_reader :timestamp
            
    def to_s   
      result  = "Domain Metadata:\n"
      result += "\tItem Count: "                  + @item_count + "\n"                    if @item_count
      result += "\tItem Names Size Bytes: "       + @item_names_size_bytes + "\n"         if @item_names_size_bytes
      result += "\tAttribute Name Count: "        + @attribute_name_count + "\n"          if @attribute_name_count
      result += "\tAttribute Names Size Bytes: "  + @attribute_names_size_bytes + "\n"    if @attribute_names_size_bytes
      result += "\tAttribute Value Count: "       + @attribute_value_count + "\n"         if @attribute_value_count
      result += "\tAttribute Values Size Bytes: " + @attribute_values_size_bytes + "\n"   if @attribute_values_size_bytes
      result += "\tTimestamp: "                   + @timestamp + "\n"                     if @timestamp
      
      result += super
      
      return result
    end


    protected
    def initialize( parameters ) #:nodoc:
      super( parameters )
      @item_count                     = parameters[ 'ItemCount' ]
      @item_names_size_bytes          = parameters[ 'ItemNamesSizeBtyes' ]
      @attribute_name_count           = parameters[ 'AttributeNameCount' ] 
      @attribute_names_size_bytes     = parameters[ 'AttributeNamesSizeBytes' ]
      @attribute_value_count          = parameters[ 'AttributeValueCount' ]
      @attribute_values_size_bytes    = parameters[ 'AttributeValuesSizeBytes' ]
      @timestamp                      = parameters[ 'Timestamp' ]  
    end
    
    
    # Class method which builds a DomainMetadata object from an XML document.
    # The XML document is the SimpleDB response from the DomainMetadata API call.
    def DomainMetadata.build_from_xml_document( xml_document ) #:nodoc:
      parameters = SDBResponse.get_parameters_from_xml_document( xml_document )
      
      %w/ItemNamesSizeBytes AttributeNameCount AttributeNamesSizeBytes AttributeValueCount AttributeValuesSizeBytes Timestamp/.each do |param|
          parameters = SDBResponse.add_parameter( parameters, xml_document, param, "//#{param}")
      end
          
      return DomainMetadata.new( parameters )        
    end    
  end
end
