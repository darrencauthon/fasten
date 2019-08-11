var JsonEditor = function() {

  var create = function(params) {

    params.mode = params.mode || 'tree';

    var container = document.getElementById(params.id);

    var options = {
      mode: params.mode,
      mainMenuBar: false,
      search: false
    };

    var editor = new JSONEditor(container, options);

    editor.set(params.data);

    return {
      id: params.id,
      get: function() { return editor.get(); },
      editor: editor
    };
  };

  return {
    create: create
  };

}();
