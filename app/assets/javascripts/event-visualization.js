var Elephant = function()
{

  var addBehaviorToTheDiagram = function(diagram)
  {
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

    diagram.addEvent = function (event) {
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

    diagram.addEvents = function(events) {
      events.forEach(x => { diagram.addEvent(x); });
    };

    return diagram;
  };


  var thing = {};

  thing.createDiagram = function(elementId) {
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

  return thing;

}();

var Giraffe = function()
{

  var thing = {};

  thing.createDiagram = function(elementId) {

    var diagram = Elephant.createDiagram(elementId);

    diagram.addEvent = function (event) {
      const map = new Map();

      return function(event) {
        if (map.get(event.step_guid)) {
          const node = map.get(event.step_guid);
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
        map.set(event.step_guid, node);
        diagram.nodes.add(node);
      };

    }();

    return diagram;
  };

  return thing;

}();
