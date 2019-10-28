const HtmlWebpackPlugin = require('html-webpack-plugin');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const path = require('path');

const APP_DIR = path.resolve(__dirname, './src');
const MONACO_DIR = path.resolve(__dirname, './node_modules/monaco-editor');

module.exports = {
    mode: "production",

    // Enable sourcemaps for debugging webpack's output.
    devtool: "source-map",

    resolve: {
        // Add '.ts' and '.tsx' as resolvable extensions.
        extensions: [".ts", ".tsx", ".js"]
    },
    entry: {
        main: './src/index.tsx',
        embedded: './src-embedded/index.tsx',
    },

    module: {
        rules: [
            {
                test: /\.ts(x?)$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: "ts-loader"
                    }
                ]
            },
            // All output '.js' files will have any sourcemaps re-processed by 'source-map-loader'.
            {
                enforce: "pre",
                test: /\.js$/,
                loader: "source-map-loader"
            },
            {
                test: /\.less$/,
                use: [
                  {
                    loader: 'style-loader', // creates style nodes from JS strings
                  },
                  {
                    loader: 'css-loader', // translates CSS into CommonJS
                  },
                  {
                    loader: 'less-loader', // compiles Less to CSS
                  },
                ],
            },
            {
                test: /\.css$/,
                include: APP_DIR,
                use: [{
                  loader: 'style-loader',
                }, {
                  loader: 'css-loader',
                  options: {
                    modules: true,
                    namedExport: true,
                  },
                }],
            }, 
            {
                test: /\.css$/,
                include: MONACO_DIR,
                use: ['style-loader', 'css-loader'],  
            }
        ]
    },

    // When importing a module whose path matches one of the following, just
    // assume a corresponding global variable exists and use that instead.
    // This is important because it allows us to avoid bundling all of our
    // dependencies, which allows browsers to cache those libraries between builds.
    externals: {
        "react": "React",
        "react-dom": "ReactDOM"
    },

    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        compress: true,
        port: 9000
    },

    optimization: {
        minimizer: [new UglifyJsPlugin()],
    },

    plugins: [
        new HtmlWebpackPlugin({
            title: "Ballerina Playground",
            template: path.join(__dirname, "src", "index.ejs"),
            filename: "index.html",
            excludeChunks: ["embedded"]
        }),
        new HtmlWebpackPlugin({
            title: "Ballerina Playground Embedded",
            template: path.join(__dirname, "src-embedded", "index.ejs"),
            filename: "index-embedded.html",
            excludeChunks: ["main"]
        }),
        new MonacoWebpackPlugin({
            languages: ['ballerina'],
            features: ['bracketMatching']
        })
    ]
};