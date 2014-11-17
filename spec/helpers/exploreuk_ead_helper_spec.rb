#require "spec_helper"
#
#describe "ExploreUK EAD helper" do
#  let(:blacklight_config) { Blacklight::Configuration.new }
#  let(:config_value) { double () }
#
#  before do
#    allow(helper).to receive(:blacklight_config).and_return(blacklight_config)
#  end
#
#  describe "#document_ead_header_fields" do
#    it "passes through the configuration" do
#      allow(blacklight_config).to receive(:ead_header_fields).and_return(config_value)
#      expect(helper.document_ead_header_fields).to eq config_value
#    end
#  end
#end
