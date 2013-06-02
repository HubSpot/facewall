View = require './view'

H = undefined
Particle = undefined
W = undefined
animloop = undefined
canvas = undefined
ctx = undefined
dist = undefined
distance = undefined
draw = undefined
i = undefined
minDist = undefined
paintCanvas = undefined
particleCount = undefined
particles = undefined
update = undefined

ever_rendered = false

class PageNotFoundView extends View

    template: require './templates/404'

    render: =>
        $(@el).html @template
        canvas = document.getElementById("page-not-found-canvas")
        ctx = canvas.getContext("2d")
        W = window.innerWidth
        H = window.innerHeight
        canvas.width = W
        canvas.height = H
        particleCount = 150
        particles = []
        minDist = 70
        dist = undefined
        i = 0
        while i < particleCount
            particles.push new Particle()
            i++
        animloop()

# Animation (http://goo.gl/EvUyJ)

window.requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
        window.setTimeout callback, 1000 / 60
)()

paintCanvas = ->
    ctx.fillStyle = $('body').css('background-color')
    ctx.fillRect 0, 0, W, H

Particle = ->
    @x = Math.random() * W
    @y = Math.random() * H
    @vx = -1 + Math.random() * 2
    @vy = -1 + Math.random() * 2
    @radius = 4
    @draw = ->
        ctx.fillStyle = "rgb(#{constants.styles.color_rgb})"
        ctx.beginPath()
        ctx.arc @x, @y, @radius, 0, Math.PI * 2, false
        ctx.fill()
    return

draw = ->
    i = undefined
    p = undefined
    paintCanvas()
    i = 0
    while i < particles.length
        p = particles[i]
        p.draw()
        i++
    update()

update = ->
    i = undefined
    j = undefined
    p = undefined
    p2 = undefined
    _results = undefined
    i = 0
    _results = []
    while i < particles.length
        p = particles[i]
        p.x += p.vx
        p.y += p.vy
        if p.x + p.radius > W
            p.x = p.radius
        else
            p.x = W - p.radius  if p.x - p.radius < 0
        if p.y + p.radius > H
            p.y = p.radius
        else
            p.y = H - p.radius  if p.y - p.radius < 0
        j = i + 1
        while j < particles.length
            p2 = particles[j]
            distance p, p2
            j++
        _results.push i++
    _results

distance = (p1, p2) ->
    ax = undefined
    ay = undefined
    dist = undefined
    dx = undefined
    dy = undefined
    dist = undefined
    dx = p1.x - p2.x
    dy = p1.y - p2.y
    dist = Math.sqrt(dx * dx + dy * dy)
    if dist <= minDist
        ctx.beginPath()
        ctx.strokeStyle = "rgba(#{constants.styles.color_rgb},#{1.2 - dist / minDist})"
        ctx.moveTo p1.x, p1.y
        ctx.lineTo p2.x, p2.y
        ctx.stroke()
        ctx.closePath()
        ax = dx / 2000
        ay = dy / 2000
        p1.vx -= ax
        p1.vy -= ay
        p2.vx += ax
        p2.vy += ay

animloop = ->
    draw()
    requestAnimFrame animloop if $('#page-not-found-canvas').length

module.exports = PageNotFoundView