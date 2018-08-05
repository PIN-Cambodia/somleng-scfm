ClickableTableRow = function () {
  onClickTable = function () {
    $('body').on('click', '[data-clickable-link]', function () {
      window.location = $(this).data('clickable-link');
    });
  };

  this.init = function () {
    onClickTable();
  };
};
