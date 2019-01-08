function buildEventCreationApp(elementId, diagram) {
  var nextClickIsFrom = false;
  var nextClickIsTo = false;

  const app = new Vue({
    el: elementId,
    data: {
      nodes: diagram.nodes,
      stepName: 'Pickle',
      stepType: 'EventHandler',
      message: 'Buckle up!',
      network: {
        selected:     { step: {} },
        selectedFrom: { step: {} },
        selectedTo:   { step: {} },
      }
    },
    methods: {
      addEdge: (fromNode, toNode) => {
        diagram.edges.add({
          from: fromNode.id,
          to: toNode.id,
          arrows: { to: true }
        });
      },
      removeEdge: (fromNode, toNode) => {
        var edgesToRemove = [];
        diagram.edges.forEach(edge => {
          if (edge.from === fromNode.id && edge.to === toNode.id) {
            edgesToRemove.push(edge);
          }
        });

        edgesToRemove.forEach(edge => {
          diagram.edges.remove(edge.id);
        });
      },
      expectFrom: () => {
        nextClickIsFrom = true;
      },
      expectTo: () => {
        nextClickIsTo = true;
      },
      refreshStep: (node) => {
        const options = Object.assign(node, {
          label: `${node.step.name}:${node.step.type}`,
        });
        diagram.nodes.update(options);
      },
      addStep: addStep,
      removeStep: item => {
        const index = items.indexOf(item);
        items.splice(index, 1);
      },
      fireEvent: (message) => fireSequence(buildSequenceFromNodes(diagram), message)
    }
  });

  diagram.network.on("selectNode", function (params) {
    const selectedNode = diagram.nodes._data[params.nodes[0]];
    if (nextClickIsFrom) {
      app.network.selectedFrom = selectedNode;
      nextClickIsFrom = false;
    } else if (nextClickIsTo) {
      app.network.selectedTo = selectedNode;
      nextClickIsTo = false;
    } else {
      app.network.selected = selectedNode;
    }
  });
}