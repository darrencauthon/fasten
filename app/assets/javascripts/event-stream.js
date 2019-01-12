var pusherConfig = {
  wsHost: '192.168.99.100',
  wsPort: 8080
};

function listenForPusherEvents(callback) {
  var pusher = new Pusher('app_key', Object.assign(pusherConfig, {
    enabledTransports: ['ws', 'flash'],
    disabledTransports: ['flash']
  }));

  const channel = pusher.subscribe('channel');

  channel.bind('event', callback);
}

function getAllSteps(diagram) {
  const nodesMap = getNodesMap(diagram)
  const steps = [];
  nodesMap.forEach(node => {
    steps.push(node.step);
  });

  return steps;
}

function getNodesMap(diagram) {
  const nodesMap = new Map();
  diagram.nodes.forEach(n => nodesMap.set(n.id, n));

  return nodesMap;
}

function getFirstStep(steps) {
  const allNextSteps = steps.map(step => step.next_steps).flat();
  return steps.filter(step => !allNextSteps.includes(step))[0];
}

function buildSequenceFromNodes(diagram) {
  const steps = getAllSteps(diagram);
  const firstStep = getFirstStep(steps);

  const sequence = {
    first_step: firstStep
  }

  return sequence;
}

function retrieveAllEvents() {
  return fetch('/events/all').then(response => response.json())
}

function saveSequence(workflow, message) {
  const url = `/events/create?message=${message}`;
  return fetch(url, {
      method : "POST",
      body: JSON.stringify(workflow)
  });
}
