require 'helper'

class TestRule < Test::Unit::TestCase
  context "Gnip Rules" do 
    context "without tags" do
      setup do 
        @rule = Gnip::Rule.new( '"bangor slov"')
      end

      should "allow creation of quoted rule" do
        assert{ @rule.value == "\"bangor slov\"" }
        assert{ @rule.to_json == "{\"value\":\"\\\"bangor slov\\\"\"}" }
        assert{ JSON.parse( @rule.to_json )["value"] == "\"bangor slov\"" }
      end

      should 'not have tag key as json' do
        assert{ @rule.to_json == "{\"value\":\"\\\"bangor slov\\\"\"}" }
        assert{ JSON.parse( @rule.to_json )["tag"].nil? }
      end

      should 'not have a tag value' do
        assert{ @rule.tag.nil? }
      end
    end

    context "with more than 10 phrases" do
      setup do
        @rule = Gnip::Rule.new('mirror mirror clip -watch -see -project -mirror -relativity -armie -julia -lily -trailer -movie' )
      end

      should "raise an invalid length error" do
        assert{ !@rule.valid? }
      end
    end

    context "with tags" do
      setup do
        @rule = Gnip::Rule.new( "gorgon" , "scary" )
      end

      should "convert to json" do
        assert{ JSON.parse( @rule.to_json )['tag'] == "scary" }
        assert{ JSON.parse( @rule.to_json )['value'] == "gorgon" }
      end

      should "have a tag value" do 
        assert{ @rule.tag == "scary" }
      end

    end
  end
end

