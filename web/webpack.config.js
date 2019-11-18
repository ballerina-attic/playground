const HtmlWebpackPlugin = require('html-webpack-plugin');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const webpack = require("webpack");
const path = require('path');

const APP_DIR = path.resolve(__dirname, './src');
const MONACO_DIR = path.resolve(__dirname, './node_modules/monaco-editor');

module.exports = (env, argv) => {
    const isProduction = (argv.mode === 'production');
    const controllerUrl = isProduction 
            ? "wss://play.ballerina.io/controller"
            : "ws://localhost:9090/controller";
    const gistsApiUrl = isProduction 
            ? "https://play.ballerina.io/gists"
            : "http://localhost:9090/gists";
    return {
        mode: "development",
    
        // Enable sourcemaps for debugging webpack's output.
        devtool: "source-map",
    
        resolve: {
            // Add '.ts' and '.tsx' as resolvable extensions.
            extensions: [".ts", ".tsx", ".js"]
        },
        entry: {
            app: './src/index.tsx',
            embedded: './src-embedded/index.tsx',
        },
        output: {
            filename: '[name].[contenthash].js',
            path: path.resolve(__dirname, 'dist'),
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
            minimizer: [new TerserPlugin()],
            moduleIds: 'hashed',
            runtimeChunk: 'single',
            splitChunks: {
                cacheGroups: {
                    vendor: {
                        test: /[\\/]node_modules[\\/]/,
                        name: 'vendors',
                        chunks: 'all',
                    },
                },
            },
        },
    
        plugins: [
            new CleanWebpackPlugin(),
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
            }),
            new webpack.DefinePlugin({
                CONTROLLER_BACKEND_URL: JSON.stringify(controllerUrl),
                GISTS_API_BACKEND_URL: JSON.stringify(gistsApiUrl)
            }),
            new CopyWebpackPlugin([
                {from:'samples', to:'samples'},
                {from:'images', to:'images'} 
            ])
        ]
    };
}