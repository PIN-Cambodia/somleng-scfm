PumiSelectize = function (element) {
  var filteredProvinceIds = $(element).data('filterProvinceIds');
  var namelocale = (($('html').attr('lang') == 'km') ? 'name_km' : 'name_en');

  loadData = function (selector, url) {
    $.when(
      $.getJSON(url, function (data) {
        var provinces = data;

        if (filteredProvinceIds) {
          provinces = $.grep(data, function (province, index) {
            return ($.inArray(province.id, filteredProvinceIds) >= 0);
          });
        }

        $(selector)[0].selectize.clearOptions();
        $(selector)[0].selectize.addOption(provinces);
      })
    ).done(function (data) {
      if ($(selector).data('defaultValue') && data.length) {
        $(selector)[0].selectize.setValue($(selector).data('defaultValue'));
        $(selector).data('defaultValue', null);
      }
    });
  };

  initSelect = function () {
    $(element).selectize({
      valueField: 'id',
      searchField: ['name_en', 'name_km'],
      closeAfterSelect: false,
      placeholder: $(element).data('placeholder'),
      render: {
        item: renderItem,
        option: renderOption,
      },
    });

    loadData(element, $(element).data('pumiUrl'));
  };

  renderItem = function (item, escape) {
    var label = item[namelocale];
    return '<div><span class="khmer">' + escape(label) + '</span></div>';
  };

  renderOption = function (item, escape) {
    var label = item[namelocale];
    return '<div><span class="label">' + escape(label) + '</span></div>';
  };

  this.init = function () {
    initSelect();
  };
};
