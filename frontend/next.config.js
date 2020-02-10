//const withSass = require("@zeit/next-sass");
const withCSS = require("@zeit/next-css");

module.exports = withCSS({
	module: {
		rules: [
			{
				test: /\.md$/i,
				use: "raw-loader"
			}
		]
	}
});