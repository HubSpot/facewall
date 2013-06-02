class Utils

    getHTMLTitleFromHistoryFragment: (fragment) ->
        _.capitalize(fragment.split('\/').join(' '))

    simpleError: (body, callback = ->) ->
        log body
        @simpleConfirm
            header: 'An error occurred'
            body: body
            callback: callback
            buttons: [
                text: 'OK'
                class: 'btn btn-primary'
                close: true
            ]

    simpleAlert: (body, callback = ->) ->
        @simpleConfirm
            header: '&nbsp;'
            body: body
            callback: callback
            buttons: [
                text: 'Done'
                class: 'btn btn-primary'
                close: true
            ]

    simpleConfirm: (options) ->
        options = body: options if typeof options is 'string'

        id = "#{+new Date()}_#{parseDec(Math.random() * 10000)}"

        options = _.extend {},
            id: id
            callback: ->
            header: 'Confirm'
            body: 'Are you sure?'
            buttons: [{
                text: 'OK'
                class: 'btn btn-primary'
                close: true
            }
            {
                text: 'Cancel'
                class: 'btn btn-secondary'
                close: true
            }]
        , options

        $(require('./views/templates/modal')(options)).modal()

        modal = $('#' + options.id)
        modal.find('.btn-primary').unbind().click -> options.callback true
        modal.find('.btn-secondary').unbind().click -> options.callback false

    parseQueryString: (queryString) =>
        queryArray = queryString.split('&')
        stack = {}
        for i of queryArray
            a = queryArray[i].split('=')
            name = a[0]
            value = (if isNaN(a[1]) then a[1] else parseFloat(a[1]))
            if name.match(/(.*?)\[(.*?)]/)
                name = RegExp.$1
                name2 = RegExp.$2
                if name2
                    stack[name] = {}  unless name of stack
                    stack[name][name2] = value
                else
                    stack[name] = []  unless name of stack
                    stack[name].push value
            else
                stack[name] = value
        stack

module.exports = new Utils