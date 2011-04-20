module Mirah
  module JVM
    module Types
      class TypeDefinition < Type
        attr_accessor :node

        def initialize(name, node)
          raise ArgumentError, "Bad name #{name}" if name[0,1] == '.'
          raise ArgumentError, "Bad name #{name}" if name.include? ?/
          @name = name
          @node = node
          raise ArgumentError, "Bad type #{name}" if self.name =~ /Java::/
        end

        def name
          if @type
            @type.name.tr('/', '.')
          else
            @name
          end
        end

        def superclass
          (node && node.superclass) || Object
        end

        def interfaces
          if node
            node.interfaces
          else
            []
          end
        end

        def define(builder)
          class_name = @name.tr('.', '/')
          abstract = node && node.abstract
          @type ||= builder.define_class(
              class_name,
              :visibility => :public,
              :abstract => abstract,
              :superclass => superclass,
              :interfaces => interfaces)
        end

        def meta
          @meta ||= TypeDefMeta.new(self)
        end
      end

      class TypeDefMeta < MetaType
      end
    end
  end
end