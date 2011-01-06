
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

$: << File.expand_path( File.dirname(__FILE__) + '../../../lib/' )

require 'net/http'
require 'rexml/document'

require 'sdb/domain_metadata'
require 'sdb/domain_list'
require 'sdb/item_list'
require 'sdb/sdb_response'
require 'sdb/sdb_exception'

require 'sdb/request/batch_put_attributes_request'
require 'sdb/request/create_domain_request'
require 'sdb/request/delete_attributes_request'
require 'sdb/request/delete_domain_request'
require 'sdb/request/domain_metadata_request'
require 'sdb/request/get_attributes_request'
require 'sdb/request/list_domains_request'
require 'sdb/request/put_attributes_request'
require 'sdb/request/select_request'

module SDB

  # Allows for SimpleDB API calls to be made using the given Access Key, Secret Key and endpoint.
  #
  # For more details concerning the various operations see the official Amazon Documentation
  # here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/GettingStartedGuide/].
  class SDB
    # * 'access_key_id' : String representing your Access Key Id for SimpleDB.
    # * 'secret_key' : String representing the Secret Key for the Access Key Id supplied.
    # * 'retry_delays' : Array of "seconds" indicating both the number of retries and the delay between retries.  A retry will initiate on ANY error response from SimpleDB.
    # * 'base_url' : String representing the endpoint by which to connect to SimpleDB.
    def initialize( access_key_id, secret_key, retry_delays=[0.5, 2], base_url='http://sdb.amazonaws.com/' )
      @base_url = base_url
      @access_key_id = access_key_id
      @secret_key = secret_key
      @retry_delays = retry_delays
    end


    # Given a string for the domain name, returns an SDBResponse.  
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_CreateDomain.html]
    # for more information about the CreateDomain SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def create_domain( domain_name ) 
      sdb_response_xml = execute_with_retries( Request::CreateDomainRequest.new( domain_name.to_s, @access_key_id, @secret_key ) )      
      sdb_response = SDBResponse.build_from_xml_document( sdb_response )

      if sdb_response.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), sdb_response.error_message
      else 
        return sdb_response
      end      
    end


    # Given an optional result set size and next token returns a DomainList.    
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_ListDomains.html]
    # for more information about the ListDomains SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def list_domains( maxResults=100, next_token=nil ) 
      sdb_response_xml = execute_with_retries( Request::ListDomainsRequest.new( maxResults, next_token, @access_key_id, @secret_key ) )      
      domain_list = DomainList.build_from_xml_document( sdb_response_xml )

      if domain_list.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), domain_list.error_message
      else 
        return domain_list
      end      
    end


    # Given a string for the domain name, returns a DomainMetadata.
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_DomainMetadata.html]
    # for more information about the DomainMetadata SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
   def domain_metadata( domain_name ) 
      sdb_response_xml = execute_with_retries( Request::DomainMetadataRequest.new( domain_name.to_s, @access_key_id, @secret_key ) )      
      domain_metadata = DomainMetadata.build_from_xml_document( sdb_response_xml )

      if domain_metadata.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), domain_metadata.error_message
      else 
        return domain_metadata
      end      
    end

    
    # Given a string for the domain name, returns an SDBResponse.
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_DeleteDomain.html]
    # for more information about the DeleteDomain SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def delete_domain( domain_name ) 
      sdb_response_xml = execute_with_retries( Request::DeleteDomainRequest.new( domain_name.to_s, @access_key_id, @secret_key ) )      
      sdb_response = SDBResponse.build_from_xml_document( sdb_response_xml )

      if sdb_response.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), sdb_response.error_message
      else 
        return sdb_response
      end      
    end        
    

    # Given a string for the query expression and an optional next token, returns an ItemList.    
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_Select.html]
    # for more information about the Select SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def select( expression, next_token=nil ) 
      sdb_response_xml = execute_with_retries( Request::SelectRequest.new( expression, next_token, @access_key_id, @secret_key ) )            
      item_list = ItemList.build_from_xml_document( sdb_response_xml )
      
      if item_list.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), item_list.error_message
      else 
        return item_list
      end
    end
    
    
    # Given a string for the domain name, item name and an optional array of Attribute objects, returns an Item.
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_GetAttributes.html]
    # for more information about the GetAttributes SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def get_attributes( domain_name, item_name, attributes=nil ) 
      sdb_response_xml = execute_with_retries( Request::GetAttributesRequest.new( domain_name.to_s, item_name.to_s, attributes, @access_key_id, @secret_key ) )      
      item = Item.build_from_xml_document( item_name, sdb_response_xml )       

      if item.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), item.error_message
      else 
        return item
      end      
    end 
    
    
    # iven a string for the domain name, item name and an optional array of Attribute objects, returns an SDBResponse.
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_DeleteAttributes.html]
    # for more information about the DeleteAttributes SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def delete_attributes( domain_name, item_name, attributes=nil ) 
      sdb_response_xml = execute_with_retries( Request::DeleteAttributesRequest.new( domain_name.to_s, item_name.to_s, attributes, @access_key_id, @secret_key ) )      
      sdb_response = SDBResponse.build_from_xml_document( sdb_response_xml )

      if sdb_response.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), sdb_response.error_message
      else 
        return sdb_response
      end      
    end 
    
    
    # Given a string for the domain name, item name and an optional array of Attribute objects, returns an SDBResponse.
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_PutAttributes.html]
    # for more information about the PutAttributes SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def put_attributes( domain_name, item_name, attributes=nil ) 
      sdb_response_xml = execute_with_retries( Request::PutAttributesRequest.new( domain_name.to_s, item_name.to_s, attributes, @access_key_id, @secret_key ) )      
      sdb_response = SDBResponse.build_from_xml_document( sdb_response_xml )

      if sdb_response.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), sdb_response.error_message
      else 
        return sdb_response
      end      
    end 


    # Given a string for the domain name and an array of Item objects, returns an SDBResponse.
    # Click here[http://docs.amazonwebservices.com/AmazonSimpleDB/2009-04-15/DeveloperGuide/index.html?SDB_API_BatchPutAttributes.html]
    # for more information about the Batch Put Attributes SimpleDB operation.
    #
    # raises an SDBException if the call returns an error code.
    def batch_put_attributes( domain_name, items ) 
      sdb_response_xml = execute_with_retries( Request::BatchPutAttributesRequest.new( domain_name.to_s, items, @access_key_id, @secret_key ) )      
      sdb_response = SDBResponse.build_from_xml_document( sdb_response_xml )     

      if sdb_response.error_code 
        raise SDBException.build_from_xml_document( sdb_response_xml ), sdb_response.error_message
      else 
        return sdb_response
      end      
    end     
    
    
    private
    def make_sdb_http_post_request( request ) #:nodoc:
      Net::HTTP.post_form( URI.parse( @base_url ), request.get_parameters_as_hash )
    end

    def execute_with_retries( request ) #:nodoc:
      xml_response_document = nil
      @retry_delays.each do | retry_delay |
        xml_response_document = REXML::Document.new( make_sdb_http_post_request( request ).body )
        response = SDBResponse.build_from_xml_document( xml_response_document )
        
        return xml_response_document if response.error_code.nil?
        Kernel.sleep( retry_delay ) 
      end      
      
      return xml_response_document
    end
  end
end
