View = require './view'

class HighScoresView extends View

    initialize: =>
        @collection = app.collections.highScores

    $score: (score) -> """
        <a data-email="#{score.email}" class="employee employee-high-score">
            <span class="name">#{score.name}</span>
            <span class="score">#{score.score}</span>
            <img class="photo" src="https://secure.gravatar.com/avatar/#{CryptoJS.MD5(score.email)}?d=404&s=160" />
        </a>
    """

    render: (callback) =>
        @collection.fetch
            error: -> utils.simpleError("An error occurred while trying to load #{constants.company_name} Facewall Game high scores.")
            success: -> _render()

        _render = =>
            html = ''
            _.each _.first(@collection.toJSON(), 100), (score) =>
                html += @$score score
            callback html

module.exports = HighScoresView