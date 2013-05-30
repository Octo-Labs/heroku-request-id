require 'spec_helper'

describe HerokuRequestId::Middleware do

  include Rack::Test::Methods

  let(:inner_app) do
    lambda { |env| [200, {'Content-Type' => 'text/html'}, ['<body>All good!</body>']] }
  end

  let(:app) { HerokuRequestId::Middleware.new(inner_app) }

  subject{ get "/", {}, { "HTTP_HEROKU_REQUEST_ID" => "the_id_string" } }

  it "prints the request id to stdout by default" do
    output = capture_stdout { subject }
    output.should match("heroku-request-id")
    output.should match("the_id_string")
  end

  it "does not print the request id to stdout if log_line == false" do
    HerokuRequestId::Middleware.log_line = false
    output = capture_stdout { subject }
    output.should_not match("heroku-request-id")
    output.should_not match("the_id_string")
    # reset html_comment so that random test order works
    HerokuRequestId::Middleware.log_line = true
  end

  it "does not add a comment with the Heroku request id by default" do
    capture_stdout { subject }
    last_response.body.should_not match("Heroku request id")
    last_response.body.should_not match("the_id_string")
  end

  it "does add a comment with the Heroku request id if html_comment == true" do
    HerokuRequestId::Middleware.html_comment = true
    capture_stdout { subject }
    last_response.body.should match("Heroku request id")
    last_response.body.should match("the_id_string")
    # reset html_comment so that random test order works
    HerokuRequestId::Middleware.html_comment = false
  end

  it "makes no change to response status" do
    capture_stdout { subject }
    last_response.should be_ok
  end

end
