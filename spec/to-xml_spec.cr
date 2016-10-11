require "./spec_helper"
require "xml"

describe "to_xml" do
  it "string" do
    {"hi"=>"mom"}.to_xml.should eq("<hi>mom</hi>")
  end

  it "int" do
    {"node"=>67}.to_xml.should eq("<node>67</node>")
  end

  it "float" do
    {"node"=>67.76}.to_xml.should eq("<node>67.76</node>")
  end

  it "float" do
    {"node"=>false}.to_xml.should eq("<node>false</node>")
  end

  it "simple nesting" do
    {"hi" => {"mom" => "dad" }}.to_xml.should eq("<hi><mom>dad</mom></hi>")
  end

  it "attributes" do
    {"hi" => {"@mom" => "dad" }}.to_xml.should eq("<hi mom=\"dad\"></hi>")
  end

  it "attributes and simple text content" do
    {"hi" => {"@mom" => "dad", "$" => "text"}}.to_xml.should eq("<hi mom=\"dad\">text</hi>")
  end

  it "attributes and nesting" do
    {"hi" => {"@mom" => "dad", "child" => "text"}}.to_xml.should eq("<hi mom=\"dad\"><child>text</child></hi>")
  end

  it "array" do
    {"node" => { "app" => [1,2] }}.to_xml.should eq("<node><app>1</app><app>2</app></node>")
  end

  it "nil" do
    { "fred" => nil }.to_xml.should eq("<fred></fred>")
  end
end
