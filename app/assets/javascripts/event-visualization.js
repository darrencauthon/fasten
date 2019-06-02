var Elephant = function()
{

  var addBehaviorToTheDiagram = function(diagram)
  {
    diagram.addEventInstanceAsAggregateNodes = function() {
      const stepGuidMap = new Map();

      return function(event) {
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

    var buildStepNodeObject = function(step, properties) {
      const { name, type, guid, next_steps } = step;
      return Object.assign({
        id: diagram.nodes.length,
        label: `${name}:${type}:${guid}`,
        widthConstraint: 60,
        shape: 'box',
        step: step
      }, properties);
    };

    diagram.addEventInstanceAsIndividualNode = function (event) {
      diagram.edges.add({ from: event.id, to: event.prior_event_id });

      diagram.nodes.add({
        id: event.id,
        label: event.message,
        priorEventId: event.prior_event_id
      });
    };

    diagram.addStepAsNode = function(step, parentNode) {
      const { name, type, guid, next_steps } = step;
      const newNode = buildStepNodeObject(step, { id: diagram.nodes.length });

      if (parentNode) {
        const newEdge = { from: parentNode.id, to: newNode.id, arrows: { to: true } };
        diagram.edges.add(newEdge);
        newNode.parentNode = parentNode;
      }

      diagram.nodes.add(newNode);

      if (step.next_steps) {
        const nextSteps = step.next_steps.forEach(step => diagram.addStepAsNode(step, newNode));
        return [newNode].concat(nextSteps);
      } else {
        return [newNode];
      }

      return newNode;
    };

    diagram.showEventBubbles = function(events) {
      events.forEach(thisEvent => {
        diagram.addEventInstanceAsIndividualNode(thisEvent);
      });
    };

    return diagram;
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

  return this;

};
