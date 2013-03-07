ForceGraph = require 'mod_graph'
miserablesData = require('miserables')

$ ->
  graphData = links: [], nodes: []
  window.forceGraph = forceGraph = new ForceGraph(selector: 'body')
    .render()
    .updateData(graphData)

  $('BUTTON.load').on 'click', ->
    forceGraph.updateData
      nodes: miserablesData.nodes.slice(0, 70)
      links: []