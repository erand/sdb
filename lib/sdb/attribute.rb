
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


module SDB #:nodoc:

  # An immutable class to represent Attributes for Items within SimpleDB.
  # All attributes have a 'name' and a 'value' but only those attributes
  # that will be used for putting data to SimpleDB will have a meaningful
  # 'replace' setting.
  class Attribute
    # A string that represents the name of the attribute, must be 1024 characters or less.
    attr_reader :name
    
    # A string that represents the value of the attributes, must be 1024 characters or less.
    attr_reader :value
    
    # A boolean used when putting data into SimpleDB.  'true' indicates that any pre-existing attribute should be replaced.
    # Otherwise, the value will be added be added to the list of values for the attribute.
    attr_reader :replace
            
    # * 'name' : The name of the attribute.
    # * 'value' : The value for the attribute.
    # * 'replace' : Used in the PutAttributes or BatchPutAtttributes APIs to indicate if a pre-existing attribute should be replaced.
    def initialize( name, value, replace=false )
      @name = name.to_s
      @value = value.to_s
      @replace = replace
    end

    
    def to_s
        "#{@name}=#{@value}"        
    end


    # Class method which builds an Attribute from an XML Element.
    # The XML element is part of the SimpleDB response to an API call when retrieving data.
    def Attribute.build_from_xml_element( xml_element ) #:nodoc:
      document = REXML::Document.new( xml_element )
      name = REXML::XPath.first( document, '//Name' )
      value = REXML::XPath.first( document, '//Value' );

      return Attribute.new( name.text, value.text )        
    end    
  end
end
