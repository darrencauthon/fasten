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
  const nodesMap = new Map();
  diagram.nodes.forEach(n => nodesMap.set(n.id, n));
  return Array.from(nodesMap.entries()).map(mapEntry => mapEntry[1].step);
}

function buildWorkflowFromNodes(diagram) {
  const steps = getAllSteps(diagram);

  const workflow = {
    steps: steps
  }

  return workflow;
}

function retrieveAllEvents() {
  return Events().findAll();
}

function fireWorkflow(workflow, message) {
  const url = `/events/create?message=${message}`;
  return fetch(url, {
      method : "POST",
      body: JSON.stringify(workflow)
  });
}

var Events = function() {
  this.findAll = function(){
    return fetch('/events/all').then(response => response.json())
  };

  this.findByRunId = function(runId){
    return fetch('/events/all?run_id=' + runId).then(response => response.json())
  };

  return this;
}();