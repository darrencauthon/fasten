function buildEventCreationApp(elementId, diagram) {
  const app = new Vue({
    el: elementId,
    data: {
      nodes: diagram.nodes,
      stepName: 'Pickle',
      stepType: 'EventHandler',
      message: 'Buckle up!',
      network: {
        selected:     { step: { type: '' } },
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

          const nextStepIndex = fromNode.step.next_steps.findIndex(thisStep => {
            return thisStep.id === edge.to;
          });

          fromNode.step.next_steps.splice(nextStepIndex, 1);
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
      addBlankStep: () => diagram.addStepAsNode({}),
      removeStep: item => {
        const index = items.indexOf(item);
        items.splice(index, 1);
      },
      fireWorkflow: (message) => fireWorkflow(buildWorkflowFromNodes(diagram), message)
    }
  });

  const editor = startJsonEditor(() => {
    app.network.selected.step.config = editor.get();
  });

  diagram.network.on("selectNode", function (params) {
    const selectedNode = diagram.nodes._data[params.nodes[0]];
    if (app.nextClickIsFrom) {
      app.network.selectedFrom = selectedNode;
      app.nextClickIsFrom = false;
      app.nextClickIsTo = true;
      app.network.selected = selectedNode;
      editor.set(selectedNode.step.config || {});
    } else if (app.nextClickIsTo) {
      app.network.selectedTo = selectedNode;
      app.nextClickIsTo = false;
      app.nextClickIsFrom = true;
      app.network.selected = selectedNode;
      editor.set(selectedNode.step.config || {});
    }
  });
}
