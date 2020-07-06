// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jQuery/jquery.min
//= require jquery_ujs
//= require jquery.turbolinks
//= require jQuery/jquery-ui.min
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require bootstrap-fileinput
//= require nprogress
//= require nprogress-ajax
//= require toastr
//= require spin
//= require ladda
//= require ladda.jquery
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require dataTables/dataTables.responsive
//= require dataTables/responsive.bootstrap
//= require dataTables/dataTables.colReorder
//= require dataTables/dataTables.fixedColumns
//= require dataTables/dataTables.fixedHeader
//= require dataTables/buttons/dataTables.buttons
//= require dataTables/buttons/buttons.bootstrap
//= require dataTables/buttons/jszip
//= require dataTables/buttons/pdfmake
//= require dataTables/buttons/vfs_fonts
//= require dataTables/buttons/buttons.html5
//= require dataTables/buttons/buttons.print
//= require dataTables/buttons/buttons.colVis
//= require rwd-table
//= require raphael
//= require morris
//= require datepicker
//= require bootstrap-select
//= require moment
//= require daterangepicker
//= require responsive-paginate
//= require sweetalert
//= require select2
//= require jQDateRangeSlider-min
//= require jQRangeSlider-min
//= require sortable
//= require fileinput
//= require infinite-scroll
//= require_tree .
//= require turbolinks

NProgress.configure({
  showSpinner: false,
  ease: 'ease',
  speed: 500
});

$(function() {
  var flashCallback;
  flashCallback = function() {
    return $(".alert").fadeOut();
  };
  $(".alert").bind('click', (function(_this) {
    return function(ev) {
      return $(".alert").fadeOut();
    };
  })(this));
  return setTimeout(flashCallback, 3000);
});