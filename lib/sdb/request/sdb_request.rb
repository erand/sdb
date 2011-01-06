
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

require 'date'
require 'openssl'
require 'digest/sha1'
require 'base64'
require 'sdb/request/request_parameter'

# Base Object to build of the HTTP Query Request to make a any SimpleDB API call.
# This object builds in the common parameters needed for any SimpleDB API call.
# This object builds all requests using Signature Version 2 protocol using the 
# HMAC SHA-256 algorithm.
module SDB
  module Request #:nodoc: all
    class SDBRequest
      								           
      def initialize( action, access_key_id, secret_key )
        @access_key_id = access_key_id
        @secret_key = secret_key
        @parameters = []
        populate_base_parameters( action )
      end

      
      def get_parameters_as_hash() 
        parameter_hash = Hash.new()              
        @parameters.each{ |parameter| parameter_hash[ parameter.name ] = parameter.value }        
        parameter_hash
      end
                     
      protected            
      def populate_base_parameters( action ) 
        add_parameter( 'AWSAccessKeyId',    @access_key_id )
        add_parameter( 'SignatureVersion',  '2' )
        add_parameter( 'Timestamp',         DateTime.now.to_s )
        add_parameter( 'Version',           '2009-04-15' )  
        add_parameter( 'SignatureMethod',   'HmacSHA256' )     
        add_parameter( 'Action',            action )
      end
      
      
      def add_parameter( name, value )
        @parameters << RequestParameter.new( name, value )
      end
      
      
      def add_signature() 
        @parameters.sort!
        add_parameter( 'Signature', generate_signature() )
      end
      
      
      def generate_signature()
        encode_as_base64( OpenSSL::HMAC.digest( OpenSSL::Digest::Digest.new( 'sha256' ), @secret_key, get_string_to_sign() ) )
      end    


      def get_string_to_sign() 
        "POST\nsdb.amazonaws.com\n/\n" + @parameters.collect{ |parameter| parameter.to_url_encoded_s }.join( '&' )
      end
      
      
      def encode_as_base64( data_to_encode )
        return nil unless data_to_encode
        b64 = Base64.encode64( data_to_encode )
        b64.gsub( "\n", '' )
      end
    end
  end
end
