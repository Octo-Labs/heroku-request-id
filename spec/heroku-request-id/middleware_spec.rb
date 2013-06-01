require 'spec_helper'

describe HerokuRequestId::Middleware do

  include Rack::Test::Methods

  let(:inner_app) do
    lambda { |env| [200, {'Content-Type' => 'text/html'}, ['<body>All good!</body>']] }
  end

  let(:app) { HerokuRequestId::Middleware.new(inner_app) }

  let(:request_without_rack_runtime)do
    capture_stdout{ get("/", {}, {"HTTP_HEROKU_REQUEST_ID" => "the_id_string"}) }
  end

  let(:request_with_rack_runtime)do
    capture_stdout{ get("/", {}, {"HTTP_HEROKU_REQUEST_ID" => "the_id_string","X-Runtime" => "42"}) }
  end

  it "prints the request id to stdout by default" do
    output = request_without_rack_runtime
    output.should match("Heroku request id")
    output.should match("the_id_string")
  end

  it "Does not include runtime information if the 'X-Runtime' header is not present" do
    output = request_without_rack_runtime
    output.should match("Runtime info not available")
  end

  it "Does include runtime information if the 'X-Runtime' header is present" do
    output = request_with_rack_runtime
    output.should match("Elapsed time")
  end

  it "does not print the request id to stdout if log_line == false" do
    HerokuRequestId::Middleware.log_line = false
    output = request_without_rack_runtime
    output.should_not match("heroku-request-id")
    output.should_not match("the_id_string")
    # reset html_comment so that random test order works
    HerokuRequestId::Middleware.log_line = true
  end

  it "does not add a comment with the Heroku request id by default" do
    request_without_rack_runtime
    last_response.body.should_not match("Heroku request id")
    last_response.body.should_not match("the_id_string")
  end

  it "does add a comment with the Heroku request id if html_comment == true" do
    HerokuRequestId::Middleware.html_comment = true
    request_without_rack_runtime
    last_response.body.should match("Heroku request id")
    last_response.body.should match("the_id_string")
    # reset html_comment so that random test order works
    HerokuRequestId::Middleware.html_comment = false
  end

  it "makes no change to response status" do
    request_without_rack_runtime
    last_response.should be_ok
  end


 # my silly but effective way to test if the header gets replicated/passed forward.
 # i searched and couldn't figure out the typical way of testing
 # if a header is passed down the stack, perhaps someone who knows can replace this.
  describe "header replication into x-request-id" do
    let(:inner_app) do
      lambda { |env|
        [200, {'Content-Type' => 'text/html'}, [env["HTTP_X_REQUEST_ID"]]]
      }
    end
    let(:app){ HerokuRequestId::Middleware.new(inner_app) }
    subject do
      capture_stdout { get("/", {}, { "HTTP_HEROKU_REQUEST_ID" => "the_id_string" }) }
    end
    context "by default" do
      it "does not replicate the heroku header into rails header" do
        subject
        last_response.body.should eq ""
      end
    end
    context "when x_request_id_replication == true" do
      before{HerokuRequestId::Middleware.x_request_id_replication = true}
      after{HerokuRequestId::Middleware.x_request_id_replication = false}
      it "replicates the heroku header into rails header" do
        subject
        last_response.body.should eq "the_id_string"
      end
    end
  end

end
