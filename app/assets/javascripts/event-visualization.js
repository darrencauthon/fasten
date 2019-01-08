function showEventBubbles({ network, nodes, edges }, events) {
  events.forEach(thisEvent => {
    edges.add({ from: thisEvent.id, to: thisEvent.prior_event_id });

    nodes.add({
      id: thisEvent.id,
      label: thisEvent.message,
      priorEventId: thisEvent.prior_event_id
    });
  });
}

function createBlankNetworkDiagram(elementId) {
  const nodes = new vis.DataSet([]);
  const edges = new vis.DataSet([]);
  var container = document.getElementById(elementId);
  var data = {
    nodes: nodes,
    edges: edges
  };
  var options = {};
  var network = new vis.Network(container, data, options);

  return { network, nodes, edges }
}