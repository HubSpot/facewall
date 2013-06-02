Collection = require './collection'

# By default, email addresses with no Gravatars will be hidden from the Facewall.
# However, adding ?shame to the request URL will show these as empty squares in the Facewall mesh.
defaultGravatarImage = if location.search isnt '?shame' then '404' else 'blank'

USER_JSON = """{"users":[{"firstName":"Adam","lastName":"Schwartz","email":"aschwartz@hubspot.com"},{"firstName":"Brad","lastName":"Osgood","email":"bosgood@hubspot.com"},{"firstName":"Chris","lastName":"Kelly","email":"ckelly@hubspot.com"},{"firstName":"David","lastName":"Cancel","email":"dcancel@hubspot.com"},{"firstName":"Jeremy","lastName":"Crane","email":"jcrane@hubspot.com"},{"firstName":"Mike","lastName":"Axiak","email":"maxiak@hubspot.com"},{"firstName":"Michael","lastName":"Mintz","email":"mmintz@hubspot.com"},{"firstName":"Rachel","lastName":"Decker","email":"rdecker@hubspot.com"},{"firstName":"Sam","lastName":"Siskend","email":"ssiskind@hubspot.com"},{"firstName":"Trevor","lastName":"Burnam","email":"tburnham@hubspot.com"},{"firstName":"Tim","lastName":"Finley","email":"tfinley@hubspot.com"},{"firstName":"Tom","lastName":"Monaghan","email":"tmonaghan@hubspot.com"},{"firstName":"Zack","lastName":"Bloom","email":"zbloom@hubspot.com"}]}"""

class Employees extends Collection

    # Replace this with your own database of employees.
    # You may use a URL which returns JSON in the following format:
    # {
    #    "users":[
    #       {
    #          "id": 1,
    #          "createdAt": 1282254176000,
    #          "email": "aschwartz@hubspot.com",
    #          "firstName": "Adam",
    #          "lastName": "Schwartz",
    #          "role": "Principal Software Engineer"
    #       },
    #       // ...
    #    ]
    # }
    # url: -> "/my-organization-user-database"

    # Or you may hard code a JSON string in place of the example USER_JSON (see above)
    fetch: (options) ->
        @add @parse JSON.parse USER_JSON
        setTimeout (-> options.success()), 100

    parse: (data) ->
        _.map data.users, (employee) =>
            employee.gravatar = "https://secure.gravatar.com/avatar/#{CryptoJS.MD5(employee.email)}?d=#{defaultGravatarImage}"

            # Default to showing full name when role is not available
            employee.role = employee.firstName + ' ' + employee.lastName unless employee.role

            employee

module.exports = Employees