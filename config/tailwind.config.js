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
    "bg-[#FCE7C8]",
    "text-purple-50", "bg-purple-50", "border-purple-50",
    "text-purple-600", "bg-purple-600", "border-purple-600",
    "text-blue-50", "bg-blue-50", "border-blue-50",
    "text-blue-600", "bg-blue-600", "border-blue-600",
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
      animation: {
        progress: 'progress 3s linear forwards'
      },
      keyframes: {
        progress: {
          '0%': { width: '100%' },
          '100%': { width: '0%' },
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
