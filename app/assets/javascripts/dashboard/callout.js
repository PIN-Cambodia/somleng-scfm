DashboardCallout = function () {
  var firstLoad = true;
  var provinceCss = '.js-select-province';
  var districtsCommunes = '#districts-communes';
  var allCommunesSelector = '.js-select-all-communes';
  var namelocale = (($('html').attr('lang') == 'km') ? 'name_km' : 'name_en');

  province = new PumiSelectize(provinceCss);

  onProvinceChange = function () {
    $(provinceCss).on('change', function () {
      params = '?province_id=' + this.value;
      districtUrl = $(this).data('pumiDistrictCollectionUrl') + params;
      communeUrl = $(this).data('pumiCommuneCollectionUrl') + params;
      communeIds = $(this).data('defaultCommuneIds');

      getDistricts = $.getJSON(districtUrl);
      getCommunes = $.getJSON(communeUrl);
      getDistricts.then(function (districts) {
        buildDistricts(districts);
      }).done(function () {
        getCommunes.then(function (communes) {
          buildCommunes(communes);
        }).done(function () {
          if (firstLoad) {
            checkCommunes(communeIds);
            firstLoad = false;
          }
        });
      });
    });
  };

  checkCommunes = function (communeIds) {
    $.each(communeIds, function (index, communeId) {
      $('#callout_commune_' + communeId).prop('checked', true);
      findDistrictOf(communeId.slice(0, 4)).prop('checked', true);
    });
  };

  buildDistricts = function (districts) {
    $(districtsCommunes).html('');
    $.each(districts, function (index, district) {
      $(districtsCommunes).append(pumiCheckbox('district', district));
    });
  };

  buildCommunes = function (communes) {
    $.each(communes, function (index, commune) {
      $parent = findDistrictOf(commune.id.slice(0, 4)).parent();
      $parent.append(pumiCheckbox('commune', commune));
    });
  };

  pumiCheckbox = function (type, object) {
    var inputTag = '<div class="form-check">' +
    '<input class="form-check-input ' + type + '-ids" type="checkbox" ' +
    'value=' + object.id + ' name="callout[' + type + '_ids][]" ' +
    'id="callout_' + type + '_' + object.id + '">';

    var labelTag = '<label class="string optional form-check-label"' +
    'for="callout_' + type + '_' + object.id + '">'
    + object[namelocale] + '</label></div>';

    return inputTag + labelTag;
  };

  onCheckDistrict = function () {
    $('body').on('change', '.district-ids', function () {
      $children = $(this).parent().find('.commune-ids');
      if ($(this).is(':checked')) {
        $children.prop('checked', true);
      } else {
        $children.prop('checked', false);
        $(allCommunesSelector).prop('checked', false);
      }
    });
  };

  onCommuneCheckboxChange = function () {
    $(districtsCommunes).on('change', '.commune-ids', function () {
      var $district = findDistrictOf($(this).val());

      if ($(this).is(':checked')) {
        $district.prop('checked', true);
      } else {
        if ($district.parent().find('.commune-ids:checked').length == 0) {
          $district.prop('checked', false);
        }

        $(allCommunesSelector).prop('checked', false);
      }
    });
  };

  findDistrictOf = function (communeId) {
    return $('#callout_district_' + communeId.slice(0, 4));
  };

  onSelectAllCommunes = function () {
    $(allCommunesSelector).on('change', function () {
      if ($(this).is(':checked')) {
        $('#districts-communes .form-check-input').prop('checked', true);
      } else {
        $('#districts-communes .form-check-input').prop('checked', false);
      }
    });
  };

  this.init = function () {
    province.init();
    onProvinceChange();
    onCheckDistrict();
    onCommuneCheckboxChange();
    onSelectAllCommunes();
  };
};

$(document).on('turbolinks:load', function () {
  actions = ['new', 'create', 'edit', 'update'];
  if ((page.controller() !== 'callouts') || !actions.includes(page.action())) {
    return;
  }

  dashboardCallout = new DashboardCallout();
  dashboardCallout.init();
});
