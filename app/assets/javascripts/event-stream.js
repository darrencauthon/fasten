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

function buildSequenceFromNodes(diagram) {
  const nodesMap = new Map();
  diagram.nodes.forEach(n => nodesMap.set(n.id, n));

  var sortedEdges = diagram.edges.map(e => e).filter(e => e.from != undefined && e.to != undefined).sort((a,b) => a.from - b.from);
  var steps = Array.from(new Set(sortedEdges.map(edge => {
    const fromNode = nodesMap.get(edge.from);
    const toNode = nodesMap.get(edge.to);

    return [fromNode, toNode];
  }).flat())).map(node => node.step);

  return steps;
}

function retrieveAllEvents() {
  return fetch('/events/all').then(response => response.json())
}

function fireSequence(workflow, message) {
  const url = `/events/create?message=${message}`;
  return fetch(url, {
      method : "POST",
      body: JSON.stringify(workflow)
  });
}
