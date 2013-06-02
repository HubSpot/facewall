exports.config =

    paths:
        public: 'public'

    files:

        javascripts:

            defaultExtension: 'coffee'

            joinTo:
                'static/js/app.js': /^app/
                'static/js/vendor.js': /^vendor/

            order:
                before: [
                    'vendor/scripts/core.coffee'
                    'vendor/scripts/chrome.inspector-detector.js'
                    'vendor/scripts/console-helper.js'
                    'vendor/scripts/jquery-1.7.2.js'
                    'vendor/scripts/jquery-ui-min.js'
                    'vendor/scripts/jquery.cookie.js'
                    'vendor/scripts/jquery.mousewheel.js'
                    'vendor/scripts/underscore-1.3.1.js'
                    'vendor/scripts/underscore.string.js'
                    'vendor/scripts/backbone-0.9.2.js'
                    'vendor/scripts/backbone-query-string-param-patch.js'
                    'vendor/scripts/md5.js'
                    'vendor/scripts/urlize.js'
                    'vendor/scripts/bootstrap-modal.js'
                ]

        stylesheets:
            defaultExtension: 'styl'
            joinTo: 'static/css/app.css'
            order:
                before: [
                    'vendor/styles/bootstrap.css'
                    'vendor/styles/bootstrap-responsive.css'
                    'vendor/styles/docs.css'
                ]

        templates:
            defaultExtension: 'hbs'
            joinTo: 'static/js/app.js'

    server:
        base: '/facewall'