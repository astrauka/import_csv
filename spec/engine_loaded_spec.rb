require 'spec_helper'

describe "engine loaded" do
  it "loads the specs" do
    expect(CsvImport).to be_instance_of Module
  end
end
