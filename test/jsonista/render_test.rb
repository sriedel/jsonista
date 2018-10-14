require 'test_helper'

class Jsonista::RenderTest < Minitest::Spec
  describe ".render" do
    let(:fixture_path) { File.join( __dir__, "..", "fixtures" ) }
    let(:file_param) { File.join( fixture_path, "file_param_template.jsonista" ) }
    let(:partial_param) { File.join( fixture_path, "partial_param_template" ) }
    let(:template_param) { File.join( fixture_path, "template_param_template" ) }
    let(:string_param) { %{"string"} }

    describe "template resolution" do
      before( :each ) do
        $stderr.reopen( "/dev/null" )
      end
      
      after( :each ) do
        $stderr = STDERR 
      end

      describe "when giving a file as parameter" do
        describe "and also giving a :partial option" do
          it 'renders the contents of the template given by the file' do
            Jsonista::Render.render( file_param, :partial => partial_param ).must_equal( %{"file"} )
          end
        end

        describe "and also giving a :template option" do
          it 'renders the contents of the template given by the file' do
            Jsonista::Render.render( file_param, :template => template_param ).must_equal( %{"file"} )
          end
        end

        describe "and also giving a :string option" do
          it 'renders the contents of the template given by the file' do
            Jsonista::Render.render( file_param, :string => string_param ).must_equal( %{"file"} )
          end
        end

        describe "and giving no options" do
          it 'renders the contents of the template given by the file' do
            Jsonista::Render.render( file_param ).must_equal( %{"file"} )
          end
        end
      end

      describe "when not giving a file as parameter" do
        describe "but giving a :partial option" do
          it 'renders the contents of the template given by the option' do
            Jsonista::Render.render( :partial => partial_param ).must_equal( %{"partial"} )
          end
        end

        describe "but giving a :template option" do
          it 'renders the contents of the template given by the option' do
            Jsonista::Render.render( :template => template_param ).must_equal( %{"template"} )
          end
        end

        describe "but giving a :string option" do
          it 'renders the contents of the template given by the option' do
            Jsonista::Render.render( :string => string_param ).must_equal( %{"string"} )
          end
        end

        describe "and giving no options" do
          it 'raises an error' do
            lambda { Jsonista::Render.render }.must_raise( Jsonista::NoTemplateError )
          end
        end
      end
    end
  end
end
