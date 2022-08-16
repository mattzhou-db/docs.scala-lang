require 'erb'

module Jekyll
    module ModalDetails
        class ModalDetailsBlock < Liquid::Block
            SYNTAX = /^\s*(#{Liquid::QuotedFragment})/o
            Syntax = SYNTAX

            alias_method :render_block, :render

            def unquote(string)
                string.gsub(/^['"]|['"]$/, '')
            end

            def initialize(block_name, markup, tokens)
                super

                if markup =~ SYNTAX
                    @name = unquote($1)
                else
                    raise SyntaxError.new("Block #{block_name} requires an id")
                end
            end

            def render(context)
                site = context.registers[:site]
                converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
                modalDetailsContent = converter.convert(render_block(context))
                currentDirectory = File.dirname(__FILE__)
                templateFile = File.read(currentDirectory + '/template.erb')
                template = ERB.new(templateFile)
                template.result(binding)
            end
        end
    end
end

Liquid::Template.register_tag('modal', Jekyll::ModalDetails::ModalDetailsBlock)
