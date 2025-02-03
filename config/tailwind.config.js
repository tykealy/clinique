const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  safelist: [
    "text-[#F0A04B]",
    "bg-[#F0A04B]",
    "border-[#F0A04B]",
    "bg-[#FCE7C8]"
  ],
  theme: {
    extend: {
      colors: {
        primary: "#92bea0",
        secondary: "#5f908b",
        danger: "#e3342f",
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
