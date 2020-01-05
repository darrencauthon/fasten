var Events = function() {
  this.findByRunId = function(runId){
    return fetch('/events/all?run_id=' + runId).then(response => response.json())
  };

  this.findById = function(eventId){
    return fetch('/events/single/' + eventId).then(response => response.json())
  };

  return this;
}();

var EventModal = function() {

  var lastEventEditor = undefined;

  var popThisEvent = function(event_id) {

    var displayEvent = function(event) {
      if (lastEventEditor == undefined)
        lastEventEditor = JsonEditor.create( { id: 'event-view', data: {} } );
      
      lastEventEditor.set(event.data);

      $('#modal-event').find('.modal-title').html(event.message);
      $('#modal-event').modal();
    };

    Events.findById(event_id).then(displayEvent);
  };

  return {
    popThisEvent: popThisEvent
  };

}();

var StepEditor = function(config) {

  var stepEditor = JsonEditor.create( { id: config.stepEditorId, data: {} } );

  var incomingEventDataEditor = JsonEditor.create( { id: config.incomingEventEditorId, data: {} } );
  
  var outgoingEventEditors = [];

  var getStep = function(){
    return stepEditor.get();
  };

  var clearOutgoingEvents = function() {
    config.outgoingEvents().children('div[data-remove=me]').remove();
  };

  var runStep = function() {

    clearOutgoingEvents();

    var request = {
      step: JSON.stringify(getStep()),
      limit: $('#eventLimit').val(),
      incoming_event: JSON.stringify(incomingEventDataEditor.get())
    };

    $('#runStepMessage').html('');

    $.post(config.runStepUrl, request).then(function(data){

      $('#runStepMessage').html(data.count + ' event' + (data.count == 1 ? '' : 's') + '.');

      for(var i = 0; i < data.events.length; i++){
        var event = data.events[i];

        var eventId = 'event-' + event.id;
  
        var eventBox = config.outgoingEventTemplate().clone()
            .attr('data-remove', 'me')
            .attr('id', eventId)
            .show();

        eventBox.appendTo(config.outgoingEvents());

        config.afterEachEvent('#' + eventId, event);

      }
    });
  };

  config.runStepButton().click(runStep);

  var loadStep = function(step, incomingEvent)
  {
    incomingEvent = incomingEvent || {};

    clearOutgoingEvents();

    var setStepType = function(stepType) {
  
      incomingEventDataEditor.set(incomingEvent);

      incomingEventDataEditor.expandAll();

      stepEditor.set(step);

      stepEditor.expandAll();
    };

    setStepType(step.type);
  };

  $('#' + config.incomingEventEditorId + '_load').off().click(function(e){
    var test_event = incomingEventDataEditor.test_event || {};
    incomingEventDataEditor.set(test_event);
    e.preventDefault();
  });
  $('#' + config.incomingEventEditorId + '_save').off().click(function(e){
    incomingEventDataEditor.test_event = incomingEventDataEditor.get();
    e.preventDefault();
  });

  return {
    getStep: getStep,
    loadStep: loadStep
  };

};

var RunViewer = function(){

  var build = function(config){

    var loadEvents = function(events) {

      for(var i = 0; i < events.length; i++) {
        var event = events[i];
        event.label = event.message;
      }

      var nodes = new vis.DataSet(events);
      var edges = new vis.DataSet([]);
      for(var i = 0; i < events.length; i++) {
        var event = events[i];
        if (event.parent_event_id)
          edges.add( {
                       id: event.id + '_' + event.parent_event_id,
                       arrows: { from: { enabled: true } },
                       from: event.id,
                       to: event.parent_event_id
                     } );
      }

      var container = document.getElementById(config.id);
      var options = { layout: { hierarchical: { sortMethod: 'directed', direction: 'DU' } } };
      var data = {
        nodes: nodes,
        edges: edges
      };
      var network = new vis.Network(container, data, options);

      network.on('doubleClick', function(params) {
        var event_id = params.nodes[0];
	if (event_id == undefined) return;
        EventModal.popThisEvent(event_id);

        var options = {
                        scale: 1.0,
                        offset: {x:0,y:0},
                        animation: {
                          duration: 1000,
                          easingFunction: 'linear'
                        }
                      };

        network.focus(event_id, options);

      });
    };

    var reload = function() {
      Events.findByRunId(config.runId).then(loadEvents);
    };

    return {
      reload: reload
    };

  };

  return {
    build: build
  };

}();
