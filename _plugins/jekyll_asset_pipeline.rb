require "jekyll_asset_pipeline"

module JekyllAssetPipeline
  class SassConverter < JekyllAssetPipeline::Converter
    require 'sass'

    def self.filetype
      '.scss'
    end

    def convert
      Sass::Script::Number.precision = 7
      return Sass::Engine.new(@content, syntax: :scss).render
    end
  end
end