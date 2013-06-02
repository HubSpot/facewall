FaceWallView = require 'views/facewall'
FaceWallGameView = require 'views/facewallGame'
PageNotFoundView = require 'views/page_not_found'
NavigationView = require 'views/navigation'

navHandler = ->
    if not app.views.navigationView?
        app.views.navigationView = new NavigationView
    app.views.navigationView.render()

class Router extends Backbone.Router

    routes:
        '': 'facewallHandler'
        '/': 'facewallHandler'

        'game': 'facewallGameHandler'
        'game/': 'facewallGameHandler'

        '*anything': 'show404Page'

    basicPageHandler: ->
        navHandler()
        app.views.current_view = undefined
        $('#page').html require "../views/templates/#{Backbone.history.fragment}"

    facewallHandler: ->
        navHandler()
        if not app.views.facewallView?
            app.views.facewallView = new FaceWallView
        app.views.current_view = app.views.facewallView
        app.views.facewallView.render()

    facewallGameHandler: ->
        navHandler()
        if not app.views.facewallGameView?
            app.views.facewallGameView = new FaceWallGameView
        app.views.current_view = app.views.facewallGameView
        app.views.facewallGameView.render()

    show404Page: ->
        navHandler()
        if not app.views.pageNotFoundView?
            app.views.pageNotFoundView = new PageNotFoundView
        app.views.current_view = app.views.pageNotFoundView
        app.views.pageNotFoundView.render()

module.exports = Router