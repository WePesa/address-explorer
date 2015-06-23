# Address Explorer

BlockApps address explorer. Currently supports viewing account activity and block information.

### Project Layout

The Address Explorer is built like a moder Ethereum app -- there's no server-side templating system, and no requirement for a backend server. Instead, all the code compiles down to raw HTML, CSS and Javascript, and it uses ReactJS and JSX as an interface layer. 

### Building

First, `npm install`, then `npm install -g grunt-cli`.

Before you can run any of the code, you need to turn the CJSX, CoffeeScript and SCSS files into raw HTML, CSS and Javascript. To do so, simply run grunt:

`$ grunt`

If you want grunt to automatically perform these conversions while you're developing, where it watches for changed files, you can run the following:

`$ grunt watch`

From there, a converted, "built" app gets placed `./build` directory. Note that this app isn't ready for deployment: The CSS and Javascript still have comments and aren't minified -- you won't want to deploy those, and the files in the `./build` directory aren't added to the respository. See the "Deployment" section for details on how to deploy the app.

### Running

To run the app during development, simply open up `./build/index.html` in your browser. Viola! It magically works as a single page app.

### Deploying

When you want to create a deployable version of the app, run:

`$ grunt dist`

This will create a "distributable" version, which minifies the Javascript and removes any unneeded information from you the Javascript and CSS. This will place a deployable version inside `./dist`. Like the built version, you can run this version by opening `./dist/index.html` in your browser. 

Note: The distributable versions are uploaded to the respository, as the files in the `./dist` directory are considered deployable at any time. These files are also used for the `gh-pages` branch, though copying those files over needs to be done manually.
