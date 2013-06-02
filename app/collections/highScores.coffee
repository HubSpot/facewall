Collection = require './collection'

class HighScores extends Collection

    # Optional scoreboard for the Facewall Game.
    # Gamera is a Reddis-styled key/value storage system at HubSpot.
    url: -> "https://#{env.INTERNAL_BASE}/gamera/v1/list/facewall-game/high-scores?access_token=#{app.login.context.auth.access_token.token}"

    parse: (data) ->
        # At the gamera "list" endpoint, ".item" is a list
        _.map data.item, (score) =>
            score.gravatar = "https://secure.gravatar.com/avatar/#{CryptoJS.MD5(score.email)}?d=404&s=160"
            _.extend score, utils.parseQueryString(score.value)
            score.name = score.name.replace('\+', ' ') if score.name
            score.email = decodeURIComponent(score.email)
            score.score = decodeURIComponent(score.score)
            score = @parseScore score
            score

    parseScore: (score) ->
        [guessedCorrectly, guessedIncorrectly] = score.score.split('\/')
        score.guessedCorrectly = parseInt guessedCorrectly, 10
        score.guessedIncorrectly = (parseInt guessedIncorrectly, 10) - score.guessedCorrectly
        score.sortScore = score.guessedCorrectly - score.guessedIncorrectly
        score

    comparator: (a, b) => b.get('sortScore') - a.get('sortScore')

module.exports = HighScores
