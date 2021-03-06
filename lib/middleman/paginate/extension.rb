require 'middleman-core'

module Middleman
  module Paginate
    class Extension < ::Middleman::ConfigExtension
      self.resource_list_manipulator_priority = 0
      expose_to_config paginate: :paginate

      CollectionProxyDescriptor = Struct.new(:descriptors) do
        def execute_descriptor(app, resources)
          descriptors.reduce(resources) do |resources, descriptor|
            descriptor.execute_descriptor(app, resources)
          end
        end
      end

      class Pager
        attr_reader :current_page, :total_pages, :per_page

        def initialize(base_path, suffix, current_page, total_pages, per_page)
          @base_path = base_path
          @suffix = suffix
          @current_page = current_page
          @total_pages = total_pages
          @per_page = per_page
        end

        def next_page
          current_page < total_pages && current_page + 1
        end

        def previous_page
          current_page > 1 && current_page - 1
        end

        def full_page_path(page = current_page)
          "#{@base_path}#{page == 1 ? '/index' : @suffix.gsub(/:num/, page.to_s)}.html"
        end

        def page_path(page = current_page)
          full_path = full_page_path(page)
          if full_path.end_with?("/index.html")
            full_path.gsub(/index\.html$/, '')
          else
            full_path
          end
        end
      end

      def paginate(collection, base_path, template, per_page: 20, suffix: "/page/:num/index", locals: {}, data: {}, locale: nil)
        pages = collection.each_slice(per_page).to_a
        descriptors = []

        pages.each_with_index do |page_collection, i|
          pager = Pager.new(base_path, suffix, i + 1, pages.size, per_page)

          opts = {
            locals: locals.merge(items: page_collection, pager: pager),
            data: data,
            locale: locale
          }

          descriptors << Middleman::Sitemap::Extensions::ProxyDescriptor.new(
            Middleman::Util.normalize_path(pager.full_page_path),
            Middleman::Util.normalize_path(template),
            opts.dup
          )
        end

        CollectionProxyDescriptor.new(descriptors)
      end
    end
  end
end
