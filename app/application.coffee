Login = require 'lib/login'
Router = require 'lib/router'
Employees = require 'collections/employees'
HighScores = require 'collections/highScores'

class Application

    initialize: =>
        @login = new Login env

        @views = {}
        @collections = {}

        @setupStyles()

        @login.verifyUser (data) =>
            # Pretend to be somebody else :)
            # @login.context.user.email = 'email@hubspot.com'

            # Get employees before
            # actually starting the app
            @fetchResources =>

                $('#loader').hide()

                @router = new Router

                Backbone.history.start
                    pushState: true
                    root: '/facewall/'

                Object.freeze? @

    fetchResources: (success) =>
        @resolve_countdown = 0

        resolve = =>
            @resolve_countdown -= 1
            success() if @resolve_countdown is 0

        resources = [{
            collection_key: 'employees'
            collection: Employees
            error_phrase: 'employees'
        }, {
            collection_key: 'highScores'
            collection: HighScores
            pre_fetch: false
        }]

        _.each resources, (r) =>
            @resolve_countdown += 1
            @collections[r.collection_key] = new r.collection
            return resolve() if r.pre_fetch is false
            @collections[r.collection_key].fetch
                error: -> utils.simpleError("An error occurred while trying to load #{constants.company_name} #{r.error_phrase}.")
                success: -> resolve()

    setupStyles: ->
        $('body').css
            background: constants.styles.background
            color: "rgb(#{constants.styles.color_rgb})"

module.exports = new Application
