
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

require 'cgi'

# Helper Object to construct request parameters need to make an HTTP Query Request to SimpleDB.
module SDB
  module Request #:nodoc: all
    class RequestParameter
      attr_reader :name,:value

      def initialize( name, value )
        @name = name.to_s
        @value = value.to_s
      end

      def to_s
        @name + '=' + @value
      end
      
      def to_url_encoded_s
        @name + '=' + url_encode( "#{@value}" )      
      end
      
      def <=>( other ) 
        @name <=> other.name
      end
        
      private  
      def url_encode( data ) 
         CGI::escape( data ).gsub( '+', '%20' )
      end  
    end
  end
end
