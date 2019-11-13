/*------------------------------------------------------------------
 [ selectize  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on Select & Tag
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    select_country_call();
    select_state_call();
    select_state_disabled_call();
    input_sortable_call();
    input_tags_call();
    demo_code_language_call();
    select_repeated_options_call();
    select_to_call();
});
var eventHandler = function (name) {
    return function () {
        /*console.log(name, arguments);*/
    };
};
function select_country_call(){
    var $select = $('#select-country').selectize({
        create: false,
        onChange: eventHandler('onChange'),
        onItemAdd: eventHandler('onItemAdd'),
        onItemRemove: eventHandler('onItemRemove'),
        onOptionAdd: eventHandler('onOptionAdd'),
        onOptionRemove: eventHandler('onOptionRemove'),
        onDropdownOpen: eventHandler('onDropdownOpen'),
        onDropdownClose: eventHandler('onDropdownClose'),
        onInitialize: eventHandler('onInitialize')
    });
}
function select_state_call(){
    $('#select-state').selectize({
        maxItems: 3,
        create: false
    });
}
function select_state_disabled_call(){
    $('#select-state-disabled').selectize({
        maxItems: 3
    });
}
function input_sortable_call(){
    $('.input-sortable').selectize({
        plugins: ['drag_drop'],
        persist: false,
        create: true
    });
}
function input_tags_call(){
    $('.input-tags').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,
        create: function (input) {
            return {
                value: input,
                text: input
            }
        },
        render: {
            item: function (data, escape) {
                return '<div>"' + escape(data.text) + '"</div>';
            }
        },
        onDelete: function (values) {
            return confirm(values.length > 1 ? 'Are you sure you want to remove these ' + values.length + ' items?' : 'Are you sure you want to remove "' + values[0] + '"?');
        }
    });
}
function demo_code_language_call(){
    $('.demo-code-language').selectize({
        sortField: 'text',
        hideSelected: false,
        plugins: {
            'dropdown_header': {
                title: 'Language'
            }
        }
    });
}

function select_repeated_options_call(){
    $('#select-repeated-options').selectize({
        sortField: 'text'
    });
}

var REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' +
    '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)';

var formatName = function (item) {
    return $.trim((item.first_name || '') + ' ' + (item.last_name || ''));
};
function select_to_call(){
    $('#select-to').selectize({
        persist: false,
        maxItems: null,
        valueField: 'email',
        labelField: 'name',
        searchField: ['first_name', 'last_name', 'email'],
        sortField: [
            {field: 'first_name', direction: 'asc'},
            {field: 'last_name', direction: 'asc'}
        ],
        options: [
            {email: 'jone.doe1@mail.com', first_name: 'Jone', last_name: 'Doe 1'},
            {email: 'jone.doe2@mail.com', first_name: 'Jone', last_name: 'Doe 2'},
            {email: 'jone.doe3@mail.com', first_name: 'Jone', last_name: 'Doe 3'},
            {email: 'jone.doe4@mail.com', first_name: 'Jone', last_name: 'Doe 4'},
            {email: 'jone.doe5@mail.com', first_name: 'Jone', last_name: 'Doe 5'},
            {email: 'jone.doe6@mail.com', first_name: 'Jone', last_name: 'Doe 6'},
            {email: 'jone.doe7@mail.com', first_name: 'Jone', last_name: 'Doe 7'},
            {email: 'jone.doe8@mail.com', first_name: 'Jone', last_name: 'Doe 8'},
            {email: 'jone.doe9@mail.com', first_name: 'Jone', last_name: 'Doe 9'},
        ],
        render: {
            item: function (item, escape) {
                var name = formatName(item);
                return '<div>' +
                (name ? '<span class="name">' + escape(name) + '</span>, ' : '') +
                (item.email ? '<span class="email">' + escape(item.email) + '</span>' : '') +
                '</div>';
            },
            option: function (item, escape) {
                var name = formatName(item);
                var label = name || item.email;
                var caption = name ? item.email : null;
                return '<div>' +
                '<span class="label">' + escape(label) + '</span>' +
                (caption ? '<span class="caption">' + escape(caption) + '</span>' : '') +
                '</div>';
            }
        },
        create: function (input) {
            if ((new RegExp('^' + REGEX_EMAIL + '$', 'i')).test(input)) {
                return {email: input};
            }
            var match = input.match(new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i'));
            if (match) {
                var name = $.trim(match[1]);
                var pos_space = name.indexOf(' ');
                var first_name = name.substring(0, pos_space);
                var last_name = name.substring(pos_space + 1);

                return {
                    email: match[2],
                    first_name: first_name,
                    last_name: last_name
                };
            }
            alert('Invalid email address.');
            return false;
        }
    });
}