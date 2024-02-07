function init_sortables(labelclass) {
  $( '.groups_' + labelclass ).sortable({
    items: 'div.sortable_group',
    connectWith: '.groups_' + labelclass,
    start: function(event, ui) {
      ui.placeholder.height(ui.item.height());
    },
    axis: 'y'
  });
  $( '.sortable_' + labelclass ).sortable({
    connectWith: '.sortable_' + labelclass,
    update: function(event, ui) {
      if (ui.item.parent().hasClass('unsorted')) {
        ui.item.parent().prepend(ui.item);
        ui.item.parent().children('li').each(function () {
          if (parseInt($(this).attr('pos')) < parseInt(ui.item.attr('pos'))) {
            ui.item.insertAfter(this);
          }
        });
      }
    },
    axis: 'y'
  }).disableSelection();
}
function refresh_trackers(tracker) {
  $('.tracker').hide();
  $('#tracker_' + tracker.value).show();
}
function add_label(label, labelclass) {
  var old_label = $(label), new_label = $(label).parent().clone();
  new_label.children().first().val('').trigger('change');
  old_label.attr('src','/images/delete.png').attr('onclick','remove_label(this, "' + labelclass + '");');
  old_label.prev().width('360px');
  old_label.parent().addClass('ui-sortable-handle sortable_group');
  old_label.parent().sortable({
    connectWith: '.groups_' + labelclass
  }).disableSelection();
  old_label.parent().append('<ul id="' + labelclass + '_" class="sortable_items sortable_' + labelclass + '"/>');
  old_label.next().sortable({
    connectWith: '.sortable_' + labelclass
  }).disableSelection();
  old_label.parent().parent().append(new_label);
}
function remove_label(label, labelclass) {
  $(label).next().children().each(function () {
    var item = this;
    $('.unsorted.sortable_' + labelclass).prepend(this);
    $('.unsorted.sortable_' + labelclass).children('li').each(function () {
      if (parseInt($(this).attr('pos')) < parseInt($(item).attr('pos'))) {
        $(item).insertAfter(this);
      }
    });
  });
  $(label).parent().hide();
}
function fill_json_data() {
  var r = {}, gp = 0, cp = 0;
  $('#custom_fields_form').children('div').each(function () {
    var tracker_id = this.id.split('_').pop();
    gp = 0, cp = 0;

    // Group 'nil'
    r[tracker_id] = {};
    record=r[tracker_id];
    record[++gp] = {'cfs': {}};
    $(this).children('.nil').children().each(function () {
      cp++;
      record[gp]['cfs'][cp] = this.id;
    });
    if (! record[gp]['cfs'][1]) { delete record[gp]; }
    $(this).children('.sortable_groups').children().each(function () {
        if ($(this).children('ul').length) {
            selected_attribute_category=$(this).children('select');
            record[++gp] = {
                'name': selected_attribute_category.val(),
                'cfs': {}
            };
            cp = 0;
            $(this).children('ul').children().each(function () {
                record[gp]['cfs'][++cp] = this.id;
            });
        if (! record[gp]['cfs'][1]) { record[gp] = ''; }
      }
    });
    if ( ! r[tracker_id] ) { r[tracker_id] = ''; }
  });
  console.log(r);
    $('#group_issues_custom_fields').val(JSON.stringify(r));
}

