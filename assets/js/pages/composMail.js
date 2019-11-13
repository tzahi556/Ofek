/*------------------------------------------------------------------
 [Compose Mail Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :	Compose Mail
 -------------------------------------------------------------------*/

jQuery(document).ready(function($) {
    'use strict';

    text_editor_summerNote_load();
    upload_input_set();
    select_to_selectize();
    select_cc_selectize();
    select_bcc_selectize();
    tool_tip_on_mail();
    cc_and_bcc_address_control();
});

function text_editor_summerNote_load(){
    'use strict';

    $('.summernote').summernote({
        height: 150,                 // set editor height
        minHeight: null,             // set minimum height of editor
        maxHeight: null,             // set maximum height of editor

        focus: true,                 // set focus to editable area after initializing summernote
        codemirror: { // codemirror options
            theme: 'monokai'
        }
    });
}

function upload_input_set(){
    'use strict';

    $("#file-3").fileinput({
        showCaption: false,
        browseClass: "btn btn-ls",
        fileType: "any",
        'showUpload': false
    });
}

function tool_tip_on_mail(){
    'use strict';

    $('.tooltipMail').tooltip({
        animation: true
    });
}

function cc_and_bcc_address_control(){
    'use strict';

    $('.addBcc').click(function () {
        $('.addBccView').slideToggle();
    });
    $('.addCc').click(function () {
        $('.addCcView').slideToggle();
    });
}

/*** file input Call end ****/
var REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' +
    '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)';
/******** Select to address Start ********/
function select_to_selectize(){
    'use strict';

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
            {email: 'someone@amil.com', first_name: 'Some', last_name: 'One'},
            {email: 'someone2@mail.com', first_name: 'Some', last_name: 'One 2'},
            {email: 'someone3@mail.com', first_name: 'Some', last_name: 'One 3'},
            {email: 'someone4@mail.com', first_name: 'Some', last_name: 'One 4'},
            {email: 'someone5@mail.com', first_name: 'Some', last_name: 'One 5'},
            {email: 'someone6@mail.com', first_name: 'Some', last_name: 'One 6'},
            {email: 'someone7@mail.com', first_name: 'Some', last_name: 'One 7'},
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
        },
        onChange: function (value) {
            profilePictuerChange(value);
        }
    });
}
var formatName = function (item) {
    return $.trim((item.first_name || '') + ' ' + (item.last_name || ''));
};
function profilePictuerChange(value) {
    'use strict';

    var mainDiv = $('#contact-user-image');
    mainDiv.addClass('user-picture-big')
    $('#user-image-big').remove();
    if (value == 'someone@amil.com') {
        $('#mail-user-icon').remove();
        mainDiv.append("<img id='user-image-big' src='assets/images/userimage/avatar3-115.png' alt=''/>");
    } else if (value == 'someone2@mail.com') {
        $('#mail-user-icon').remove();
        mainDiv.append("<img id='user-image-big' src='assets/images/userimage/avatar2-115.png' alt=''/>");
    } else if (value == 'someone3@mail.com') {

        $('#mail-user-icon').remove();
        mainDiv.append("<img id='user-image-big' src='assets/images/userimage/avatar1-115.png' alt=''/>");
    } else {
        mainDiv.removeClass('user-picture-big');
        $('#mail-user-icon').remove();
        mainDiv.append('<i id="mail-user-icon" class="fa fa-users"></i>');

    }
}
/******** Select to address End ********/

/******** Select CC address Start ********/
function select_cc_selectize(){
    'use strict';

    $('#select-to-cc').selectize({
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
            {email: 'someone@amil.com', first_name: 'Some', last_name: 'One'},
            {email: 'someone2@mail.com', first_name: 'Some', last_name: 'One 2'},
            {email: 'someone3@mail.com', first_name: 'Some', last_name: 'One 3'},
            {email: 'someone4@mail.com', first_name: 'Some', last_name: 'One 4'},
            {email: 'someone5@mail.com', first_name: 'Some', last_name: 'One 5'},
            {email: 'someone6@mail.com', first_name: 'Some', last_name: 'One 6'},
            {email: 'someone7@mail.com', first_name: 'Some', last_name: 'One 7'}
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
/******** Select CC address End ********/

/******** Select BCC Address Start ********/
function select_bcc_selectize(){
    'use strict';

    $('#select-to-bcc').selectize({
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
            {email: 'someone@amil.com', first_name: 'Some', last_name: 'One'},
            {email: 'someone2@mail.com', first_name: 'Some', last_name: 'One 2'},
            {email: 'someone3@mail.com', first_name: 'Some', last_name: 'One 3'},
            {email: 'someone4@mail.com', first_name: 'Some', last_name: 'One 4'},
            {email: 'someone5@mail.com', first_name: 'Some', last_name: 'One 5'},
            {email: 'someone6@mail.com', first_name: 'Some', last_name: 'One 6'},
            {email: 'someone7@mail.com', first_name: 'Some', last_name: 'One 7'}
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
/******** Select BCC Address End ********/