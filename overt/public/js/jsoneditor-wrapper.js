var JsonEditor = function() {

  var create = function(params) {

    params.mode = params.mode || 'tree';

    var container = document.getElementById(params.id);

    var options = {
      navigationBar: false,
      mode: params.mode,
      mainMenuBar: false,
      search: false
    };

    var editor = undefined;

    var currentEditor = function(){
      if (editor == undefined) editor = new JSONEditor(container, options);
      return editor;
    };

    currentEditor().set(params.data);

    return {
      id: params.id,
      get: function() { return currentEditor().get(); },
      set: function(data) { return currentEditor().set(data); },
      expandAll: function() { return currentEditor().expandAll(); },
      collapseAll: function() { return currentEditor().collapseAll(); },
      destroy: function() {
        var value = editor.destroy();
        return value;
      },
      editor: editor
    };
  };

  return {
    create: create
  };

}();