require 'simplecov'

SimpleCov.start 'rails' do
    coverage_dir 'coverage'
    add_filter '/spec/'
    add_filter %r{^/app/(controllers|models|jobs|mailers|channels)/application_.*\.rb$}
end
