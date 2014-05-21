# == Schema Information
#
# Table name: entries
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Entry do
  before { @entry = FactoryGirl.create(:entry) }

  subject { @entry }

  it { should respond_to(:email) }
  it { should be_valid }

  describe "Eメールが存在しない場合" do
    before { @entry.email = "" }
    it { should_not be_valid }
  end

  describe "Eメールフォーマットが不正な場合" do
    it "エラーになる" do
      addresses = %w[user_at_foo,org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @entry.email = invalid_address
        should_not be_valid
      end
    end
  end

  describe "Eメールフォーマットが正しい場合" do
    it "正常" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @entry.email = valid_address
        should be_valid
      end
    end
  end

  describe "Eメールアドレスが大文字小文字混在の場合" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM"}

    it "全て小文字で保存される" do
      @entry.email = mixed_case_email
      @entry.save
      expect(@entry.reload.email).to eq mixed_case_email.downcase
    end
  end
end
