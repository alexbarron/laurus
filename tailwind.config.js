module.exports = {
  darkMode: 'class',
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./config/initializers/simple_form_tailwind.rb",
    "./node_modules/flowbite/**/*.js"
  ],
  plugins: [
    require('flowbite/plugin')
  ]
}