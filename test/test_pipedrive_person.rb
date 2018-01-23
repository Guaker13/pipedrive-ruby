require 'helper'

class TestPipedrivePerson < Test::Unit::TestCase
  should "execute a valid person request in API v1" do
    body = {
      "email"=>["john@dope.org"],
      "name"=>"John Dope",
      "org_id"=>"404",
      "phone"=>["0123456789"]
    }

    stub_request(:post, "https://api.pipedrive.com/v1/persons?api_token=some-token").
      with(:body => body, :headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "create_person_body.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:34:23 GMT",
          "content-type" => "application/json",
          "content-length" => "1164",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    person = ::Pipedrive::Person.create(
      body.merge(api_token: 'some-token')
    )

    assert_equal "John Dope", person.name
    assert_equal 404, person.org_id
    assert_equal "john@dope.org", person.email.first.fetch("value")
    assert_equal "0123456789", person.phone.first.fetch("value")
  end

  should "execute a valid person request in API v2 (Marketplace)" do
    body = {
      "email"=>["john@dope.org"],
      "name"=>"John Dope",
      "org_id"=>"404",
      "phone"=>["0123456789"]
    }

    stub_request(:post, "https://api-proxy.pipedrive.com/persons").
      with(:body => body, :headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api',
          'Authorization' => 'Bearer token'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "create_person_body.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:34:23 GMT",
          "content-type" => "application/json",
          "content-length" => "1164",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    person = ::Pipedrive::Person.create(
      body.merge(api_token: 'token', version: 'oauth')
    )

    assert_equal "John Dope", person.name
    assert_equal 404, person.org_id
    assert_equal "john@dope.org", person.email.first.fetch("value")
    assert_equal "0123456789", person.phone.first.fetch("value")
  end

  should "be able to find a person by name" do
    stub_request(:get, "https://api.pipedrive.com/v1/persons/find?term=Donald&api_token=token").
      with(
        :headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "find_person_by_name.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:46:06 GMT",
          "content-type" => "application/json",
          "content-length" => "3337",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    persons = ::Pipedrive::Person.find_by_name(
      'Donald',
      api_token: 'token',
      version: 'v1'
    )

    assert_equal 'Donald', persons.first.name
  end

  should "be able to find a person by name with Oauth API version" do
    stub_request(:get, "https://api-proxy.pipedrive.com/persons/find?term=Donald").
      with(
        :headers => {
          'Accept'=>'application/json',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'istat24.Pipedrive.Api',
          'Authorization' => 'Bearer token'
        }).
      to_return(
        :status => 200,
        :body => File.read(File.join(File.dirname(__FILE__), "data", "find_person_by_name.json")),
        :headers => {
          "server" => "nginx/1.2.4",
          "date" => "Fri, 01 Mar 2013 13:46:06 GMT",
          "content-type" => "application/json",
          "content-length" => "3337",
          "connection" => "keep-alive",
          "access-control-allow-origin" => "*"
        }
      )

    persons = ::Pipedrive::Person.find_by_name(
      'Donald',
      api_token: 'token',
      version: 'oauth'
    )

    assert_equal 'Donald', persons.first.name
  end

  should "return bad_response on errors" do
    #TODO
    # flunk "to be tested"
  end
end
