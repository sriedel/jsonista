require 'test_helper'

describe "Rendering a template that in turn renders partials" do
  let(:fixture_path) { File.join( __dir__, "..", "fixtures" ) }
  let(:main_template_path) { File.join( fixture_path, "template_with_partials.jsonista" ) }
  let(:expected_result_structure) do
    { :key_1 => "value_in_main_template",
      :key_2 => "value_in_partial",
      :key_3 => [ 1, 2, nil, "foo", :bar ] }
  end
  let(:expected_result) { expected_result_structure.to_json }

  it "should return the expected result" do
    Jsonista.render( main_template_path ).must_equal( expected_result )
  end
end
