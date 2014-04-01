require "spec_helper"

describe "serf agent" do

  it "should have a serf user" do
    expect(user "serf").to exist
  end

  it "should have a serf group" do
    expect(group "serf").to exist
  end

  describe file("/etc/serf/agent.config") do
    it { should be_file }
    it { should be_owned_by "serf" }
    it { should be_grouped_into "serf" }
    its(:content) { should match /\/var\/serf\/snapshot/ }
  end

end
