var JsonEditor = function() {

  var create = function(params) {

    var container = document.getElementById(params.id);

    var options = {};

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
