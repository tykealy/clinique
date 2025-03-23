# Custom shoulda-like matchers for testing without the gem
module CustomShouldaMatchers
  def self.define_matchers
    RSpec::Matchers.define :belong_to do |association|
      match do |model|
        model.class.reflect_on_association(association)&.macro == :belongs_to
      end
    end

    RSpec::Matchers.define :have_many do |association|
      chain :dependent do |dependent_type|
        @dependent_type = dependent_type
      end
      
      chain :through do |through_association|
        @through_association = through_association
      end
      
      match do |model|
        reflection = model.class.reflect_on_association(association)
        result = reflection&.macro == :has_many
        
        if result && @dependent_type
          result = reflection.options[:dependent] == @dependent_type
        end
        
        if result && @through_association
          result = reflection.options[:through] == @through_association
        end
        
        result
      end
    end

    RSpec::Matchers.define :accept_nested_attributes_for do |association|
      chain :allow_destroy do |allow_destroy|
        @allow_destroy = allow_destroy
      end
      
      match do |model|
        result = model.class.nested_attributes_options.key?(association)
        
        if result && @allow_destroy
          result = model.class.nested_attributes_options[association][:allow_destroy] == @allow_destroy
        end
        
        result
      end
    end
  end
end

# Define the custom matchers
CustomShouldaMatchers.define_matchers 