module.exports = class ForceGraph
  constructor: (options) ->
    @options = _.defaults options,
      selector: 'body'
      width: 960
      height: 500
      charge: -60
      radius: 5
      linkDistance: 30
      color: d3.scale.category20()

    @force = undefined
    @svg = undefined
    @graph = undefined

  render: ->
    self = this

    @force = d3.layout.force()
      .charge(@options.charge)
      .linkDistance(@options.linkDistance)
      .size([@options.width, @options.height])
      .nodes([])
      .links([])

    @svg = d3.select(@options.selector).append("svg")
      .attr("width", @options.width)
      .attr("height", @options.height)
      .on 'dblclick', -> self._handleDoubleClick.call self, this

    this

  updateData: (graph) ->
    {@nodes, @links} = graph

    @force
      .nodes(@nodes)
      .links(@links)
      .start();

    link = @svg.selectAll(".link").data(@links)
    link.enter().append("line")
      .attr("class", "link")
      .style("stroke-width", (d) -> Math.sqrt(d.value))
    link.exit().remove()
    # link.on 'click'

    node = @svg.selectAll(".node").data(@nodes)
    node.enter().append("circle")
      .attr("class", "node")
      .attr("r", @options.radius)
      .style("fill", (d) => @options.color(d.group))
      .call(@force.drag)
    node.exit().remove()

    node.append("title")
      .text (d) -> d.name

    @force.on "tick", ->
      link.attr("x1", (d) -> d.source.x)
          .attr("y1", (d) -> d.source.y)
          .attr("x2", (d) -> d.target.x)
          .attr("y2", (d) -> d.target.y)

      node.attr("cx", (d) -> d.x)
          .attr("cy", (d) -> d.y)

    this

  _handleDoubleClick: (el) ->
    [x, y] = d3.mouse(el)
    node = {x, y}
    nodes = @nodes.concat node

    # add links to any nearby nodes
    links = [].concat @links
    for target in nodes
      x = target.x - node.x
      y = target.y - node.y
      if Math.sqrt(x * x + y * y) < 30
        links.push
          source: node
          target: target

    @updateData {nodes, links}