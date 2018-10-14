require 'test_helper'

class Jsonista::RenderTest < Minitest::Spec
  describe ".render" do
    let(:fixture_path) { File.join( __dir__, "..", "fixtures" ) }
    let(:file_param) { File.join( fixture_path, "file_param_template.jsonista" ) }
    let(:partial_param) { File.join( fixture_path, "partial_param_template" ) }
    let(:template_param) { File.join( fixture_path, "template_param_template" ) }
    let(:string_param) { %{"string"} }

    describe "when rendering a file" do
      describe "and the given file does not exist" do
        it "raises an exception" do
          lambda do
            Jsonista::Render.render( "i_dont_exist" )
          end.must_raise( Errno::ENOENT )
        end
      end

      describe "and the given file exists" do
        it "returns the rendered template body from the file" do
          Jsonista::Render.render( file_param ).must_equal( %{"file"} )
        end
      end
    end

    describe "when rendering a template" do
      describe "and the intended file exists" do
        describe "and the given filename includes the template file extension" do
          let(:template_param) { File.join( fixture_path, "template_param_template#{Jsonista::Render::TEMPLATE_FILE_EXTENSION}" ) }

          it "returns the rendered template body from the file" do
            Jsonista::Render.render( :template => template_param ).must_equal( %{"template"} )
          end
        end

        describe "and the given filename does not include the file extension" do
          let(:template_param) { File.join( fixture_path, "template_param_template" ) }

          it "returns the rendered template body from the file" do
            Jsonista::Render.render( :template => template_param ).must_equal( %{"template"} )
          end
        end
      end

      describe "and the intended file does not exist" do
        it "returns the rendered template body from the file" do
          lambda do
            Jsonista::Render.render( :template => "i_dont_exist" )
          end.must_raise( Errno::ENOENT )
        end
      end
    end

    describe "when rendering a partial" do
      describe "and the intended file exists" do
        describe "and the given filename includes the template file extension" do
          let(:partial_param) { File.join( fixture_path, "partial_param_template#{Jsonista::Render::TEMPLATE_FILE_EXTENSION}" ) }

          it "returns the rendered template body from the file" do
            Jsonista::Render.render( :partial => partial_param ).must_equal( %{"partial"} )
          end
        end

        describe "and the given filename does not include the file extension" do
          let(:partial_param) { File.join( fixture_path, "partial_param_template" ) }

          it "returns the rendered template body from the file" do
            Jsonista::Render.render( :partial => partial_param ).must_equal( %{"partial"} )
          end
        end
      end

      describe "and the intended file does not exist" do
        it "returns the rendered template body from the file" do
          lambda do
            Jsonista::Render.render( :partial => "i_dont_exist" )
          end.must_raise( Errno::ENOENT )
        end
      end
    end

    describe "when rendering a string" do
      it "returns the rendered template body from the string" do
        Jsonista::Render.render( :string => string_param ).must_equal( %{"string"} ) 
      end
    end

    describe "template resolution" do
      before( :each ) do
        $stderr.reopen( "/dev/null" )
      end
      
      after( :each ) do
        $stderr = STDERR 
      end

      describe "when giving a file as parameter" do
        describe "and also giving a :partial option" do
          it 'raises an error' do
            lambda do
              Jsonista::Render.render( file_param, :partial => partial_param )
            end.must_raise( Jsonista::NoTemplateError )
          end
        end

        describe "and also giving a :template option" do
          it 'raises an error' do
            lambda do
              Jsonista::Render.render( file_param, :template => template_param )
            end.must_raise( Jsonista::NoTemplateError )
          end
        end

        describe "and also giving a :string option" do
          it 'raises an error' do
            lambda do
              Jsonista::Render.render( file_param, :string => string_param )
            end.must_raise( Jsonista::NoTemplateError )
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
