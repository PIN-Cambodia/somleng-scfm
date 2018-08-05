PumiProvinceCommunes = function () {
  var $province = $('.js-select-province');
  var $communes = $('.js-select-communes');
  var districts = [];
  var communes = [];
  var communeIds = $communes.data('defaultValue') || [];
  var provinceId = $province.data('defaultValue');
  var namelocale = (($('html').attr('lang') == 'km') ? 'name_km' : 'name_en');

  initSelectProvince = function () {
    $province.selectize({
      valueField: 'id',
      preload: true,
      searchField: ['name_en', 'name_km'],
      placeholder: $province.data('placeholder'),
      render: {
        item: renderItem,
        option: renderOption,
      },
      load: loadProvinces,
      onChange: getdistrictsCommunes,
    });

    provincetize = $province[0].selectize;
  };

  loadProvinces = function (query, callback) {
    $.when(
      $.getJSON($province.data('provinceUrl'), function (data) {
        callback(data);
      })
    ).done(function () {
      if (provinceId) {
        provincetize.setValue(provinceId);
        provinceId = null;
      }
    });
  };

  initSelectCommunes = function () {
    $communes.selectize({
      options: [],
      optgroups: [],
      valueField: 'id',
      optgroupField: 'district_id',
      optgroupValueField: 'id',
      searchField: ['name_en', 'name_km'],
      placeholder: $communes.data('placeholder'),
      closeAfterSelect: true,
      render: {
        optgroup_header: renderOptGroupHeader,
        item: renderItem,
        option: renderOption,
      },
      onChange: updateCommuneIds,
    });

    communestize = $communes[0].selectize;
  };

  updateCommuneIds = function (value) {
    newValue = [];
    $.when(
      $.map(value, function (value, index) {
        $.each(value.split(','), function (index, val) {
          newValue.push(val);
        });
      })
    ).done(function (data) {
      comparation = $(value).not(newValue).length === 0 && $(newValue).not(value).length === 0;
      if (!comparation) {
        communestize.setValue(newValue);
      }
    });
  };

  renderOptGroupHeader = function (item, escape) {
    var label = item[namelocale];
    return '<div data-selectable data-value="' +
      escape(item.commune_ids) + '" class="optgroup-header">' +
      escape(label) + '</div>';
  };

  renderItem = function (item, escape) {
    var label = item[namelocale];
    return '<div><span class="khmer">' + escape(label) + '</span></div>';
  };

  renderOption = function (item, escape) {
    var label = item[namelocale];
    return '<div><span class="label">' + escape(label) + '</span></div>';
  };

  getdistrictsCommunes = function (provinceId) {
    params = '?province_id=' + provinceId;
    districtUrl = $province.data('pumiDistrictCollectionUrl') + params;
    communeUrl = $province.data('pumiCommuneCollectionUrl') + params;

    request = $.getJSON(districtUrl);
    chained = request.then(function (data) {
      districts = data;
      return $.getJSON(communeUrl);
    });

    chained.done(function (data) {
      communes = data;
      communestize.clearOptions();
      communestize.clearOptionGroups();
      $.when(
        mapDistrictCommune()
      ).then(function () {
        $.each(districts, function (index, district) {
          communestize.addOptionGroup(district.id, district);
        });

        communestize.addOption(communes);
      }).done(function () {
        if (communeIds.length) {
          communestize.setValue(communeIds);
          communeIds = [];
        }
      });
    });
  };

  mapDistrictCommune = function () {
    $.each(districts, function (index, district) {
      $.when(
        district.commune_ids = $.map(communes, function (commune, index) {
          if (commune.id.slice(0, 4) === district.id) {
            commune.district_id = district.id;
            return commune.id;
          }
        })
      ).done(function (data) {
        communes.push({
          district: true, name_en: district.name_en,
          id: district.commune_ids, district_id: district.id,
        });
      });
    });

    return districts;
  };

  this.init = function () {
    initSelectCommunes();
    initSelectProvince();
  };
};
