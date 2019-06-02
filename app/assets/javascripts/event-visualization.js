var Elephant = function()
{

  var addBehaviorToTheDiagram = function(thing)
  {
    thing.addEventInstanceAsAggregateNodes = function() {
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
        };
        stepGuidMap.set(event.step_guid, node);
        diagram.nodes.add(node);
      };
    }();

    return thing;
  };



  this.createBlankNetworkDiagram = function(elementId) {
    const nodes = new vis.DataSet([]);
    const edges = new vis.DataSet([]);

    var container = document.getElementById(elementId);

    var data = {
      nodes: nodes,
      edges: edges
    };

    var options = {};

    var network = new vis.Network(container, data, options);

    return addBehaviorToTheDiagram({ network, nodes, edges });
  };

  this.showEventBubbles = function(diagram, events) {
    events.forEach(thisEvent => {
      addEventInstanceAsIndividualNode(diagram, thisEvent);
    });
  };

  this.addEventInstanceAsIndividualNode = function (diagram, event) {
    diagram.edges.add({ from: event.id, to: event.prior_event_id });

    diagram.nodes.add({
      id: event.id,
      label: event.message,
      priorEventId: event.prior_event_id
    });
  };

  this.buildStepNodeObject = function(step, properties, diagram) {
    const { name, type, guid, next_steps } = step;
    return Object.assign({
      id: diagram.nodes.length,
      label: `${name}:${type}:${guid}`,
      widthConstraint: 60,
      shape: 'box',
      step: step
    }, properties);
  };

  this.buildLine = function(fromNode, toNode) {
    return {
      from: fromNode.id,
      to: toNode.id,
      arrows: { to: true }
    }
  };

  this.addStepAsNode = function(diagram, step, parentNode) {
    const { name, type, guid, next_steps } = step;
    const newNode = buildStepNodeObject(step, { id: diagram.nodes.length }, diagram);

    if (parentNode) {
      const newEdge = buildLine(parentNode, newNode);
      diagram.edges.add(newEdge);
      newNode.parentNode = parentNode;
    }

    diagram.nodes.add(newNode);

    if (step.next_steps) {
      const nextSteps = step.next_steps.forEach(step => addStepAsNode(diagram, step, newNode));
      return [newNode].concat(nextSteps);
    } else {
      return [newNode];
    }

    return newNode;
  };

  return this;

};
