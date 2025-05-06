require 'simplecov'

SimpleCov.start 'rails' do
    coverage_dir 'coverage'
    add_filter '/spec/'
    add_filter %r{^/app/(controllers|models|jobs|mailers|channels)/application_.*\.rb$}
    add_filter %r{^/app/.*/base_.*\.rb$}
    add_filter '/app/serializers'
    add_filter '/app/controllers/concerns/'
    add_filter '/app/models/concerns/'
end
