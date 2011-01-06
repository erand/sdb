
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

  # An immutable class that represent the list of Domains returned from a 'DomainList' SimpleDB API call.
  class DomainList < SDBResponse
    # String array of the domain names.
    attr_reader :domain_names
    
    # String token to be included in subsequent 'list_domains' calls to get the next batch of Domain Names.
    attr_reader :next_token
            
           
    # Allows for enumeration over the domain names.
    def each
        domain_names.each do |domain_name| 
            yield domain_name
        end
    end


    def to_s        
      result  = "Domain List\n"
      result += "\tNext Token: " + @next_token + "\n" if @next_token
      result += "\tDomain Names:" + @domain_names.join( ',' ) + "\n" 

      result += super
      
      return result
    end
    
    
    protected
    def initialize( parameters ) #:nodoc:
      super( parameters )
      @domain_names = parameters[ 'DomainNames' ]
      @next_token = parameters[ 'NextToken' ]
    end

    
    # Class method which builds a DomainList object from an XML document.
    # The XML document is the SimpleDB response from the DomainList API call.
    def DomainList.build_from_xml_document( xml_document ) #:nodoc:
      parameters = SDBResponse.get_parameters_from_xml_document( xml_document )    
      parameters = SDBResponse.add_list_parameter( parameters, xml_document, 'DomainNames', '//DomainName' )
      parameters = SDBResponse.add_parameter( parameters, xml_document, 'NextToken', '//NextToken' )

      return DomainList.new( parameters )        
    end    
  end
end
