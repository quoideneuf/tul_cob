# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "simplecov"
require "alma"
require "webmock/rspec"
require "vcr"
require "database_cleaner"
require "capybara/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

SPEC_ROOT = File.dirname __FILE__

SimpleCov.start "rails" do
  # Code from other repositories
  add_filter "/lib/alma_rb/"
  add_filter "/lib/alma-blacklight/"
  add_filter "/app/models/marc_indexer.rb"
  add_filter "/app/views/"
  add_filter "/app/channels/"
end
# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|

  config.before(:each) do

    # JUst so we don't send our request when testing controllers
    stub_request(:get, /.*almaws\/v1\/bibs\/.*/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: JSON.dump({}))

    stub_request(:post, /.*almaws\/v1\/bibs\/.*\/request-options?.*/).
      to_return(status: 200)

    stub_request(:post, /.*almaws\/v1\/bibs\/.*\/requests?.*/)
      .to_return(status: 200)

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/alma_data/bib_items_ambler_only.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: JSON.dump({}))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/same_campus\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/alma_data/presser_and_paley.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/ambler_presser\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/alma_data/ambler_presser.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/kardon_paley\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/alma_data/kardon_paley.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/only_paley_reserves\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/only_paley_reserves.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/paley_reserves_and_remote_storage\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/paley_reserves_and_remote_storage.json"))


    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/paley_reserves_and_remote_storage\/holdings\/.*\/items/).
      with(query: hash_including(offset: "100")).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/no_reserve_or_reference\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/no_reserve_or_reference.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/both_reserve\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/both_reserve.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/desc_with_no_libraries\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/desc_with_no_libraries.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/desc_with_no_libraries\/holdings\/.*\/items/).
      with(query: hash_including(offset: "100")).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/desc_with_multiple_libraries\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/desc_with_multiple_libraries.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/desc_with_multiple_libraries\/holdings\/.*\/items/).
      with(query: hash_including(offset: "100")).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/empty_descriptions\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_descriptions.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/empty_descriptions\/holdings\/.*\/items/).
      with(query: hash_including(offset: "100")).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/empty_and_description\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_and_description.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/empty_hash\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/empty_and_description\/holdings\/.*\/items/).
      with(query: hash_including(offset: "100")).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/multiple_descriptions\/holdings\/.*\/items/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/multiple_descriptions.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/multiple_descriptions\/holdings\/.*\/items/).
      with(query: hash_including(offset: "100")).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: File.open(SPEC_ROOT + "/fixtures/requests/empty_hash.json"))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs/).
      with(query: hash_including(expand: "p_avail,e_avail,d_avail", mms_id: "1,2")).
      to_return(status: 200,
                body: File.open(SPEC_ROOT + "/fixtures/availability_response.xml").read,
                headers: { "content-type" => ["application/xml;charset=UTF-8"] })

  end
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
    mocks.allow_message_expectations_on_nil = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.

  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  config.filter_run_excluding relevance: true unless ENV["RELEVANCE"]

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  #if config.files_to_run.one?
  # Use the documentation formatter for detailed output,
  # unless a formatter has already been configured
  # (e.g. via a command-line flag).
  #config.default_formatter = 'doc'
  #end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.add_setting :bento_expected_fields,
    default: [ :title, :authors, :publisher, :link ]

  # So we can test logged in users.
  require "warden"
  config.include Warden::Test::Helpers

end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = {
    match_requests_on: [:method]
  }
end

if ENV["RELEVANCE"] && ENV["RELEVANCE"] != "test_only"
  RSpec.configure do |config|
    config.before(:suite) do
      require "rake"
      Rails.application.load_tasks
      Rake::Task["fortytu:solr:load_fixtures"].invoke("#{SPEC_ROOT}/relevance/fixtures/*.xml")
    end
  end
end

require "rspec/expectations"
RSpec::Matchers.define :include_items do |primary_items|
  chain :before, :secondary_items
  chain :within_the_first, :within_index

  match do |items|
    all_present?(primary_items, @within_index) &&
      all_present?(@secondary_items) &&
      comes_before?(@secondary_items, primary_items)
  end

  def all_present?(check_items, within_index = nil)
    # Skip if chained check is not required
    return true if check_items.nil?

    @within_items = within_index ? @actual.take(within_index.to_i) : @actual
    check_items.all? { |id| @within_items.include?(id) }
  end

  def comes_before?(back_items, front_items)
    # Skip if chained check is not required
    return true if @secondary_items.nil?

    back_items.all? { |back_item|
      front_items.all? { |front_item|
        @actual.index(back_item) > @actual.index(front_item) rescue false
      }
    }
  end


  failure_message do |actual|
    if secondary_items
      not_found_items = secondary_items.select { |id| !@actual.include? id }
      if not_found_items.present?
        "expected that secondary items #{secondary_items.pretty_inspect} would all be present #{within_index}, but missing #{not_found_items.pretty_inspect}"
      else
        "expected that #{primary_items} would be appear before #{secondary_items} in #{@actual}"
      end
    elsif within_index
      not_found_items = primary_items.select { |id| !@within_items.include? id }

      "expected that primary items #{primary_items.pretty_inspect} would appear in the first #{within_index} items, but missing #{not_found_items.pretty_inspect}"
    else
      not_found_items = primary_items.select { |id| !@actual.include? id }
      "expected that all primary_items (#{primary_items.pretty_inspect}) would apper in results: #{@actual.pretty_inspect}, but missing #{not_found_items.pretty_inspect}"
    end
  end
end
