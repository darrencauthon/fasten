function buildEventCreationApp(elementId, diagram) {
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
      },
      nextClickIsFrom: true,
      nextClickIsTo: false
    },
    methods: {
      addEdge: (fromNode, toNode) => {
        diagram.edges.add({
          from: fromNode.id,
          to: toNode.id,
          arrows: { to: true }
        });
        if (!fromNode.step.next_steps) {
          fromNode.step.next_steps = [];
        }

        fromNode.step.next_steps.push(toNode.step);
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
        app.nextClickIsFrom = true;
      },
      expectTo: () => {
        app.nextClickIsTo = true;
      },
      refreshStep: (node) => {
        const options = Object.assign(node, {
          label: `${node.step.name}:${node.step.type}`,
        });
        diagram.nodes.update(options);
      },
      addBlankStep: () => addStepAsNode(diagram, {}),
      removeStep: item => {
        const index = items.indexOf(item);
        items.splice(index, 1);
      },
      fireWorkflow: (message) => fireWorkflow(buildWorkflowFromNodes(diagram), message)
    }
  });

  diagram.network.on("selectNode", function (params) {
    const selectedNode = diagram.nodes._data[params.nodes[0]];
    if (app.nextClickIsFrom) {
      app.network.selectedFrom = selectedNode;
      app.nextClickIsFrom = false;
      app.nextClickIsTo = true;
      app.network.selected = selectedNode;
    } else if (app.nextClickIsTo) {
      app.network.selectedTo = selectedNode;
      app.nextClickIsTo = false;
      app.nextClickIsFrom = true;
      app.network.selected = selectedNode;
    }
  });
}
