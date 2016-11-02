require "rails_helper"

RSpec.describe "I18n.locale", type: :feature do
  context "set I18n.locale" do
    it "should set I18n.locale with en" do
      visit root_path(locale: "en")
      expect(I18n.locale).to eq :en
    end

    it "should set I18n.locale with zh-CN" do
      visit root_path(locale: "zh-CN")
      expect(I18n.locale).to eq "zh-CN".to_sym
    end

    it "should not set I18n.locale with test" do
      expect {
        visit root_path(locale: "test")
      }.not_to change{ I18n.locale }
    end

    it "should not set I18n.locale with zh-TW" do
      expect {
        visit root_path(locale: "zh-TW")
      }.not_to change{ I18n.locale }
    end
  end
end
