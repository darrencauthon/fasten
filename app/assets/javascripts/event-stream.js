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


function buildWorkflowFromNodes(diagram) {

  var getAllSteps = function(diagram) {
    const map = new Map();
    diagram.nodes.forEach(n => map.set(n.id, n));
    return Array.from(map.entries()).map(mapEntry => mapEntry[1].step);
  }

  var getFirstStep = function(steps) {
    const allNextSteps = steps.map(step => step.next_steps).flat();
    return steps.filter(step => !allNextSteps.includes(step))[0];
  }

  const steps = getAllSteps(diagram);
  const firstStep = getFirstStep(steps);

  const workflow = {
    steps: steps,
    first_step: firstStep
  }

  return workflow;
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

  return this;
}();
