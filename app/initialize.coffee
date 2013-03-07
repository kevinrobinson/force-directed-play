ForceGraph = require 'force_graph'
miserablesData = require('miserables')

$ ->
  graphData = links: [], nodes: []
  forceGraph = new ForceGraph
    selector: 'body'
    gravity: 0
    alpha: 0
    friction: 1

  forceGraph
    .render()
    .updateData(graphData)

  window.forceGraph = forceGraph

  $('BUTTON.load').on 'click', ->
    forceGraph.updateData
      nodes: miserablesData.nodes.slice(0, 70)
      links: []