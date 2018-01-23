require 'helper'

class TestPipedriveOrganization < Test::Unit::TestCase
  should "execute a valid person request" do
    stub_request(:post, "https://api.pipedrive.com/v1/organizations?api_token=some-token").
      with(:body => {
          "name" => "Dope.org"
        },
        :headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "create_organization_body.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:46:06 GMT",
          "content-type" => "application/json",
          "content-length" => "3337",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    organization = ::Pipedrive::Organization.create(
      name: "Dope.org",
      api_token: 'some-token',
      version: 'v1'
    )

    assert_equal "Dope.org", organization.name
  end

  should "be able to find all organization with Oauth API version" do
    stub_request(:get, "https://api-proxy.pipedrive.com/organizations").
      with(:headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api',
          'Authorization' => 'Bearer token'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "all_organizations.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:46:06 GMT",
          "content-type" => "application/json",
          "content-length" => "3337",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    organizations = ::Pipedrive::Organization.all(
      nil,
      api_token: 'token',
      version: 'oauth'
    )

    assert_equal 'COMPANY', organizations.first.name
  end

  should "be able to find an organization with Oauth API version" do
    stub_request(:get, "https://api-proxy.pipedrive.com/organizations/1").
      with(
        :headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api',
          'Authorization' => 'Bearer token'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "find_organization.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:46:06 GMT",
          "content-type" => "application/json",
          "content-length" => "3337",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    organization = ::Pipedrive::Organization.find(
      1,
      api_token: 'token',
      version: 'oauth'
    )

    assert_equal 'COMPANY', organization.name
  end

  should "return bad_response on errors" do
    # TODO
    # flunk "to be tested"
  end
end
