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

function showEventBubbles(diagram, events) {
  events.forEach(thisEvent => {
    addEventInstanceAsIndividualNode(diagram, thisEvent);
  });
}

function addEventInstanceAsIndividualNode(diagram, event) {
  diagram.edges.add({ from: event.id, to: event.prior_event_id });

  diagram.nodes.add({
    id: event.id,
    label: event.message,
    priorEventId: event.prior_event_id
  });
}

var addEventInstanceAsAggregateNodes = function() {
  const stepGuidMap = new Map();

  return function(diagram, event) {
    if (stepGuidMap.get(event.step_guid)) {
      const node = stepGuidMap.get(event.step_guid);
      node.count++;
      node.label = `Step: #${event.step_guid} ${node.count}`
      diagram.nodes.update(node);
      return;
    }

    const node = {
      id: event.step_guid,
      label: `Step: #${event.step_guid} 0`,
      count: 0
    }
    stepGuidMap.set(event.step_guid, node);
    diagram.nodes.add(node);
  };
}();

function addStepAsNode(diagram, step, parentNode, options) {
  const { name, type, guid } = step;
  const newNode = Object.assign({
    id: diagram.nodes.length,
    label: `${name}:${type}:${guid}`,
    widthConstraint: 60,
    shape: 'box',
    step: step
  }, options);

  if (parentNode) {
    const newEdge = {
      from: parentNode.id,
      to: newNode.id,
      arrows: { to: true }
    };
    diagram.edges.add(newEdge);
    newNode.parentNode = parentNode;
  }

  diagram.nodes.add(newNode);

  return newNode;
}