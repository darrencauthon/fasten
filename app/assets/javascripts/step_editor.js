var StepEditor = function(config) {

  var stepEditor = undefined;
  var incomingEventDataEditor = undefined;
  
  var outgoingEventEditors = [];

  var getStep = function(){
    return stepEditor.get();
  };

  var runStep = function() {

    config.outgoingEvents().children('div[data-remove=me]').remove();

    for(var i = 0; i < outgoingEventEditors.length; i++) {
      var outgoingEventEditor = outgoingEventEditors[i];
      outgoingEventEditor.destroy();
    }
    outgoingEventEditors = [];

    var request = {
      step: JSON.stringify(getStep()),
      incoming_event: JSON.stringify(incomingEventDataEditor.get())
    };

    $.post(config.runStepUrl, request).then(function(data){

      for(var i = 0; i < data.events.length; i++){
        var event = data.events[i];

        var eventId = 'event-' + event.id;
  
        var eventBox = config.outgoingEventTemplate().clone()
            .attr('data-remove', 'me')
            .attr('id', eventId)
            .show();

        eventBox.appendTo(config.outgoingEvents());
  
        $('#' + eventId).find('.box-title').html(event.message);

        var editorId = eventId + '-editor';
        $('#' + eventId).find('div[data-future=editor]').attr('id',editorId);
          outgoingEventEditors.push(JsonEditor.create( { id: editorId, data: event.data, mode: 'view' } ));
        }
    });
  };

  config.runStepButton().click(runStep);

  var loadStep = function(step, incomingEvent)
  {
    incomingEvent = incomingEvent || {};

    var setStepType = function(stepType) {
  
      if (stepEditor != undefined) stepEditor.destroy();
      if (incomingEventDataEditor != undefined) incomingEventDataEditor.destroy();
  
      incomingEventDataEditor = JsonEditor.create( { id: config.incomingEventEditorId, data: incomingEvent } );
      incomingEventDataEditor.expandAll();
  
      stepEditor = JsonEditor.create( { id: config.stepEditorId, data: step } );
      stepEditor.expandAll();
    };

    setStepType(step.type);
  };

  return {
    getStep: getStep,
    loadStep: loadStep
  };

};
