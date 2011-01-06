
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

  # An immutable class that represents an Exception thrown from an SimpleDB API call.
  class SDBException < StandardError
      # Object representing the SDB Response form the SDB API call. 
      attr_reader :sdb_response
          
      protected
      def initialize( parameters ) #:nodoc:
        @sdb_response = SDBResponse.new( parameters )
      end

      # Class method which builds an ItemList object from an XML document.
      # The XML document is the SimpleDB response from the Select API call.
      def SDBException.build_from_xml_document( xml_document ) #:nodoc:
        parameters = SDBResponse.get_parameters_from_xml_document( xml_document )    
        return SDBException.new( parameters )        
      end    
   end
end
