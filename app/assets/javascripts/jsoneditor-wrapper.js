var JsonEditor = function() {

  var create = function(params) {

    params.mode = params.mode || 'tree';

    var container = document.getElementById(params.id);

    var options = { mode: params.mode };

    var editor = new JSONEditor(container, options);

    editor.set(params.data);

    return {
      id: params.id,
      editor: editor
    };
  };

  return {
    create: create
  };

}();
