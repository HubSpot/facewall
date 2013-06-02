View = require './view'

HighScoresView = require './highScores'

Employees = require 'collections/employees'
HighScores = require 'collections/highScores'

# Make these private for harder tampering
pageHasBeenTamperedWith = false
score =
    guessedCorrectly: 0
    guessedIncorrectly: 0

class FaceWallGameView extends View

    template: require './templates/facewallGame'

    initialize: =>
        view = @

        @collection = app.collections.employees

        @setUpIphoneStuff()

        # Detect cheating
        if env.env isnt 'local'
            chrome.inspector.detector.watch (detector) -> pageHasBeenTamperedWith = true if detector.open

    render: =>
        view = @

        @last_rendered_width = $(window).width()

        return unless @collection.toJSON().length

        window.document.body.style.cssText = 'opacity: 0; background: #fff'

        $(@el).html @template company_name: constants.company_name

        setTimeout (-> window.document.body.style.cssText = 'opacity: 1; background: #fff'), 500

        @$fw = $(@el).find('.facewall')

        employees = app.collections.employees.toJSON()

        @goodEmployees = []

        _.each employees, (employee) ->
            employee_img = new Image()

            employee_img.onload = ->
                employee_loaded()
                view.goodEmployees.push employee

            employee_img.onerror = ->
                employee_loaded()

            employee_img.src = "#{employee.gravatar}&s=160"

        gameStarted = false

        employee_loaded = =>
            if view.goodEmployees.length is 20 and not gameStarted
                gameStarted = true
                @renderSidebars()
                @renderLoggedInUser()
                @setupScoreSubmission()
                @startGame()

    $employee: (employee, size, randex) -> """
        <a data-email="#{employee.email}" data-randex="#{randex}" class="employee facewall-fadein" style="top: #{randex * size}px">
            <span class="name">#{employee.firstName} #{employee.lastName}</span>
            <img class="photo" src="#{employee.gravatar}&s=#{size}" />
        </a>
    """

    renderSidebars: =>
        view = @

        $sidebarsLeft = @$fw.find('.employee-sidebar.left')
        $sidebarsRight = @$fw.find('.employee-sidebar.right')

        renderSidebars = ($sidebars) ->
            $sidebars.removeClass 'hidden'

            shuffdex = -> _.shuffle([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
            randex = shuffdex()

            _.each _.shuffle(view.goodEmployees).slice(0, 10), (employee, index) ->
                _.each $sidebars, (sidebar) ->
                    $(sidebar).append view.$employee(employee, 160, randex[index])

            swapDudes = ->
                return # TODO - fix performance problems with this

                randex = shuffdex()

                _.each _.shuffle(view.goodEmployees).slice(0, 10), (employee, index) ->

                    setTimeout ->
                        rand = randex[index]

                        _.each $sidebars, (sidebar) ->
                            $sidebar = $(sidebar)
                            $sidebar.append view.$employee employee, 160, rand
                            $remove = $sidebar.find(".employee[data-randex='#{rand}']").first()
                            $remove.addClass('facewall-fadein').find('.name').remove()
                            setTimeout (-> $remove.remove()), 3 * 1000

                            if index is 10 - 1 and app.views.current_view is view
                                swapDudes()

                    , index * 2 * 1000

            swapDudes()

        renderSidebars $sidebarsLeft
        renderSidebars $sidebarsRight

    renderLoggedInUser: =>
        return unless app.login.context

        email = app.login.context.user.email
        employeeModel = app.collections.employees.where({ email: email })[0]

        if not employeeModel
            utils.simpleError """
                <p>We're sorry but the email address <b>#{email}</b> could not be found in HubSpot's employee database.</p>
                <p>Please contact the Help Desk to sort that out. In the meantime, you can still use Facewall anonymously!</p>
            """
        else
            employee = employeeModel.toJSON()
            $('.logged-in-employee').html """
                <a data-email="#{employee.email}" class="employee facewall-fadein">
                    <span class="name">#{employee.firstName} #{employee.lastName}</span>
                    <img class="photo" src="#{employee.gravatar}&s=160" />
                </a>
            """

    setupScoreSubmission: =>
        return unless app.login.context

        email = app.login.context.user.email
        employeeModel = app.collections.employees.where({ email: email })[0]
        return if not employeeModel
        employee = employeeModel.toJSON()

        render = ->
            highScoresView = new HighScoresView()
            highScoresView.render (html) -> $('.modal-high-scores-list').html html

        $('.score-board').unbind('click').click ->
            if pageHasBeenTamperedWith
                utils.simpleError """
                    <p>Sorry, we detected that you opened the console at one point or another during gameplay.</p>
                    <p>So forgive us, but we don't want to allow you to submit your score in case you cheated.</p>
                """
                return

            else
                utils.simpleAlert """
                    <p class="facewall-styled clearfix">Submit score of #{score.guessedCorrectly} out of #{score.guessedCorrectly + score.guessedIncorrectly}? <a class="btn submit-score-button">Submit Score</a></p>
                    <p class="facewall-styled submit-score-success hidden">Successfully added your high score.</p>
                    <div class="modal-high-scores-list"></div>
                """
                render()

                $('.submit-score-button').click ->
                    $.ajax
                        type: 'POST'
                        url: app.collections.highScores.url()
                        dataType: 'text'
                        data:
                            email: employee.email
                            name: employee.firstName + ' ' + employee.lastName
                            score: (score.guessedCorrectly) + '\/' + (score.guessedCorrectly + score.guessedIncorrectly)
                        success: ->
                            $('.submit-score-success').removeClass('hidden').prev('p').remove()
                            render()

    startGame: =>
        @nextQuestion()
        @updateScoreBoard()
        @setUpIphoneStuff()

    nextQuestion: =>
        view = @

        currentSize = 400

        $current = @$fw.find('.current-employee')
        $guesses = @$fw.find('.possible-names')

        employeeGuesses = _.shuffle(view.goodEmployees).splice(0, 10)
        currentEmployee = _.shuffle(employeeGuesses)[0]

        thingsLeftBeforeRender = 1

        currentImageLoader = new Image()
        currentImageLoader.onload = =>
            $current.removeClass('guessed-correctly').html @$employee currentEmployee, currentSize, 0
            $current.find('.name').remove()
            removeAndRender()
        currentImageLoader.src = "#{currentEmployee.gravatar}&s=#{currentSize}"

        removeAndRender = -> remove render

        remove = (callback) ->
            if not $guesses.find('.employee').length
                callback()

            else
                $guesses.find('.employee.guessed-correctly').css opacity: 0
                $guesses.find('.employee').remove()
                callback()

        render = ->
            $guesses.removeClass 'guessed-correctly'

            _.each employeeGuesses, (employee, index) ->
                setTimeout ->
                    $employee = $(view.$employee employee, 40, index)
                    $employee.find('.name').html """<span class="first-name">#{employee.firstName}&nbsp;</span><span class="last-name">#{employee.lastName}</span>"""
                    $guesses.prepend $employee
                , index * 50

            $guesses.undelegate('.employee', 'click').delegate '.employee', 'click', (e) ->
                $employee = $(e.target)
                $employee = $employee.parents('.employee') if $employee.parents('.employee').length

                if $employee.data('email') is currentEmployee.email
                    $guesses.undelegate('.employee', 'click')
                    $guesses.addClass 'guessed-correctly'
                    $current.addClass 'guessed-correctly'
                    $employee.addClass 'guessed-correctly'
                    score.guessedCorrectly++
                    setTimeout ->
                        view.nextQuestion()
                    , 500
                else
                    score.guessedIncorrectly++
                    $employee.addClass 'guessed'

                view.updateScoreBoard()

    updateScoreBoard: =>
        @$fw.find('.score-board .guessed-correctly').html score.guessedCorrectly
        @$fw.find('.score-board .guessed-incorrectly').html score.guessedCorrectly + score.guessedIncorrectly

    setUpIphoneStuff: =>
        view = @

        $(window).resize ->
            if app.views.current_view is view and $(window).width() <= 768
                $('.current-employee').css
                    height: $(window).width()
                    width: $(window).width()

                $('.possible-names').css
                    top: $(window).width()
                    height: $(window).height() - $(window).width()

        $(window).resize()

module.exports = FaceWallGameView
