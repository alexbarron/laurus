require "rails_helper"

RSpec.describe DeveloperApp do
  subject { DeveloperApp.new(name: "My App") }

  it "is valid with a name" do
    expect(subject).to be_valid
  end

  it "is invalid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is invalid with a name more than 50 characters" do
    subject.name = "a" * 51
    expect(subject).to_not be_valid
  end

  it "is invalid with a name less than 3 characters" do
    subject.name = "ab"
    expect(subject).to_not be_valid
  end

  it "it has a client ID automatically generated" do
    subject.save
    expect(subject.client_id).to_not be_nil
  end

  it "it can be archived and unarchived" do
    subject.archive
    expect(subject.archived_at).to_not be_nil

    subject.unarchive
    expect(subject.archived_at).to be_nil
  end
end
