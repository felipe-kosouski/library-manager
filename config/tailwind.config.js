const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/views/**/*.html.erb',
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  theme: {
    colors: {
      gray: colors.gray,
      red: colors.red,
      blue: colors.blue,
      yellow: colors.amber,
      green: colors.green,
      white: colors.white,
      black: colors.black,
      transparent: 'transparent',
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', 'sans-serif'],
      },
    },
  },
}
