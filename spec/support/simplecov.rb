require 'simplecov'

SimpleCov.start 'rails' do
    coverage_dir 'coverage'
    add_filter '/spec/'
end
