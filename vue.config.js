'use strict'
const PrerenderSPAPlugin = require('prerender-spa-plugin')
const Renderer = PrerenderSPAPlugin.PuppeteerRenderer
const path = require('path')

function resolve(dir) {
    return path.join(__dirname, dir)
}

const replaceStr = `<div role="alert" class="el-message el-message--error" style="top: 20px; z-index: 2000;"><i class="el-message__icon el-icon-error"></i><p class="el-message__content">Failed to convert value of type 'java.lang.String' to required type 'int'; nested exception is java.lang.NumberFormatException: For input string: "undefined"</p><!----></div>`

module.exports = {
    // 基本路径
    lintOnSave: false,
    outputDir: 'dist',
    configureWebpack: config => {
        if (process.env.NODE_ENV !== 'production') return;
        return {
            plugins: [
                new PrerenderSPAPlugin({
                    staticDir: path.join(__dirname, 'dist'),
                    outputDir: path.join(__dirname, 'dist/prerendered'),
                    routes: ["/", "/about"],

                    postProcess(renderedRoute) {
                        // Ignore any redirects.
                        renderedRoute.route = renderedRoute.originalRoute
                        // Basic whitespace removal. (Don't use this in production.)
                        renderedRoute.html = renderedRoute.html.split(/>[\s]+</gmi).join('><').replace(replaceStr, '')

                        return renderedRoute
                    },
                    renderer: new Renderer({
                        inject: {
                            foo: 'bar'
                        },
                        // headless: true,
                        renderAfterDocumentEvent: 'render-event'
                    })
                })
            ]
        }
    }
}
