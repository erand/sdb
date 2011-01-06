
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

module SDB

  # An immutable class that represents the base Response data from a SimpleDB API call.
  class SDBResponse
    # String representing a unique Request Id assigned by SimpleDB for the API call. 
    attr_reader :request_id
    
    # String representing the amount of time SimpleDB spent of the API call. 
    attr_reader :box_usage
    
    # String representing the code for an error if the API call failed.
    attr_reader :error_code
    
    # String reprsenting the message for an error if the API call failed.
    attr_reader :error_message
        
    def to_s        
      result = ""
      result += "\tRequest Id: " + @request_id + "\n"         if @request_id
      result += "\tBox Usage: " + @box_usage + "\n"           if @box_usage
      result += "\tError Code: " + @error_code + "\n"         if @error_code
      result += "\tError Message: " + @error_message + "\n"   if @error_message
      
      return result
    end


    def initialize( parameters ) #:nodoc:
      @request_id = parameters[ 'RequestId' ]
      @box_usage = parameters[ 'BoxUsage' ]
      @error_code = parameters[ 'Code' ]
      @error_message = parameters[ 'Message' ]
    end
    
    # Class method which builds a SDBResponse object from an XML document.
    # The XML document is the SimpleDB response from the any API call.
    def SDBResponse.build_from_xml_document( xml_document ) #:nodoc:
      SDBResponse.new( SDBResponse.get_parameters_from_xml_document( xml_document ) )    
    end    
    
    
    def SDBResponse.get_parameters_from_xml_document( xml_document ) #:nodoc:
      parameters = {}

      %w/BoxUsage Code Message/.each do |param|
          parameters = SDBResponse.add_parameter( parameters, xml_document, param, "//#{param}")
      end            
      
      request_id_tmp = SDBResponse.extract_element_text( xml_document, "//RequestId" )      
      xpath = request_id_tmp.nil? ? '//RequestID' : '//RequestId'
      add_parameter( parameters, xml_document, "RequestId", xpath )
      
      return parameters
    end
    
    
    def SDBResponse.add_parameter( parameters, xml_document, name, xpath ) #:nodoc:
      parameters[ name ] = SDBResponse.extract_element_text( xml_document, xpath )        
      
      return parameters
    end
    
    
    def SDBResponse.add_list_parameter( parameters, xml_document, name, xpath ) #:nodoc:
      parameters[ name ] = SDBResponse.extract_element_list( xml_document, xpath )        
      
      return parameters
    end
    
    
    def SDBResponse.extract_element_text( document, xpath ) #:nodoc:
      REXML::XPath.first( document, xpath ).text rescue nil
    end


    def SDBResponse.extract_element_list( document, xpath ) #:nodoc:
      elements = REXML::XPath.match( document, xpath )
      if elements.nil?
          nil
      else
          elements.collect{ |element| "#{element.text}" }
      end
    end   

    
    def SDBResponse.extract_elements( document, xpath ) #:nodoc:
      REXML::XPath.match( document, xpath )
    end   
  end
end
