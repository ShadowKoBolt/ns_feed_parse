$(document).on("page:change", initPanelCollapses);

function initPanelCollapses() {
  // start hidden
  // $('.panel.panel-collapse .panel-body').hide();

  // setup icons
  updateToggleIcon($('.panel.panel-collapse .panel-heading'));

  // handle heading click
  $('.panel.panel-collapse .panel-heading').click(function(){
    heading = $(this);
    heading.siblings('.panel-body').slideToggle(400, function(){
      updateToggleIcon(heading);
    });
  })
}

function updateToggleIcon(element) {
  element.find('.panel-toggle-icon').remove();
  body = element.siblings('.panel-body');
  if (body.is(':visible')) {
    element.prepend('<i class="pull-right panel-toggle-icon glyphicon glyphicon-circle-arrow-up" /> ');
  }
  else {
    element.prepend('<i class="pull-right panel-toggle-icon glyphicon glyphicon-circle-arrow-down" /> ');
  }
}
