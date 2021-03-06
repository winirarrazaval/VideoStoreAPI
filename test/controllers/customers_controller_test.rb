require "test_helper"

describe CustomersController do
  describe "index" do
    it "returns an array of json" do
      get customers_url
      must_respond_with :success
      response.header['Content-Type'].must_include 'json'
      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns customers with a name that matches the search" do
      get customers_url, params: {search: "Bob Esponja"}
      body = JSON.parse(response.body)
      body.each do |customer|
        customer["name"].must_equal "Bob Esponja"
      end
    end

    it "returns customers with exactly the required fields" do
      keys = %w(address city id movies_checked_out_count name phone postal_code registered_at state)
      get customers_url, params: {search: "Bob Esponja"}
      body = JSON.parse(response.body)
      body.each do |customer|
        customer.keys.sort.must_equal keys
      end
    end


  end # index

  describe "show" do
    it "can get a customer" do
      keys = %w(address city id movies_checked_out_count name phone postal_code registered_at state )
      customer = Customer.first
      get customer_path(customer.id)
      must_respond_with :success

      response.header['Content-Type'].must_include 'json'
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.keys.sort.must_equal keys
      body['id'].must_equal customer.id
    end

    it "it should return not found and returns some error test when a customer does not exist" do

      customer_id = Customer.last.id + 1
      get customer_path(customer_id)
      must_respond_with :not_found
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "errors"
      body["errors"].must_include "id"

    end
  end

  describe "create" do
    let(:customer_data) {
      {
        name: 'Patrick Star',
        address: '123 Ocean St.',
        city: 'Seattle',
        state: 'Washington',
        postal_code: '12345',
        registered_at: Date.today

      }
    }

    it "should create a new valid customer" do
      old_customer_count = Customer.count
      post customers_url, params: { customer: customer_data }
      Customer.count.must_equal old_customer_count + 1
      newest_customer = Customer.last
      newest_customer.name.must_equal customer_data[:name]
    end

    it "should yield an error and error text when invalid data for customer" do
      customer_data[:name] = nil
      old_customer_count = Customer.count
      post customers_url, params: { customer: customer_data }
      Customer.count.must_equal old_customer_count
      must_respond_with :bad_request
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "errors"
      body["errors"].must_include "name"
    end
  end # create
end
