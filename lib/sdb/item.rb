
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

require 'rexml/document'
require 'rexml/xpath'
require 'sdb/attribute'
require 'sdb/sdb_response'

module SDB

  # An immutable class that represents an Item returned via a 'select' or 'get_attributes' call.
  class Item < SDBResponse
    # String name of the item.
    attr_reader :name
    
    # Array of Attribute objects that are part of the Item.
    attr_reader :attributes
    
    # Hash containing the items' attribute names to attribute values pairings.
    attr_reader :attribute_map
        
            
    # * 'name' : The Item Name for this Item.
    # * 'attributes' : Array of Attribute objects that represent the attributes on the Item.
    # * 'parameters' : The metadata returned by SimpleDB when Items are return from the GetAttributes or Select APIs.
    def initialize( name, attributes, parameters=nil )
      super( parameters ) if parameters

      @name = name.to_s
      @attributes = attributes            
      @attribute_map = Hash.new
      @attributes.each{ |attr| @attribute_map[attr.name] = attr.value }
    end
        
    
    def to_s  
      "Item: (" + @name + ")[" + @attributes.join( ',' ) + "]\n" + super
    end


    # Class method which builds an Item object from an XML element.
    # The XML element is part of the SimpleDB response from the Select API call.
    def Item.build_from_xml_element( xml_element ) #:nodoc:
      document = REXML::Document.new( xml_element )
      name = REXML::XPath.first( document, '/Item/Name' )

      attribute_elements = SDBResponse.extract_elements( document, '/Item/Attribute' );        
      attributes = attribute_elements.collect { |attribute_element| Attribute.build_from_xml_element( "#{attribute_element}" )}

      return Item.new( name.text, attributes )        
    end  
    
    
    # Class method which builds an Item object from an XML document.
    # The XML document is the SimpleDB response from the GetAttributes API call.
    def Item.build_from_xml_document( item_name, xml_document ) #:nodoc:
      parameters = SDBResponse.get_parameters_from_xml_document( xml_document )    

      attribute_elements = SDBResponse.extract_elements( xml_document, '//Attribute' );        
      attributes = attribute_elements.collect { |attribute_element| Attribute.build_from_xml_element( "#{attribute_element}" )}

      return Item.new( item_name, attributes, parameters )                
    end  
  end
end
